import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';
import 'package:ts_admin/app/core/helpers/realtime_configuration_storage_helper.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/system_rules_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_profile_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_realtime_configuration_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_user_permissions_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/group_conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat_detail/data/repositories/messages_db_manager.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class AuthController extends GetxController {
  // usecases
  final logoutUsecase = sl<LogoutUsecase>();
  final getRealtimeConfigurationUseCase = sl<GetRealtimeConfigurationUseCase>();
  final getProfileUseCase = sl<GetProfileUseCase>();

  // auth state
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  // drive auth state
  final RxBool stoargeOtpVerified = false.obs;

  // auth state setters
  set isAuthenticated(bool value) => _isAuthenticated.value = value;

  final storage = GetStorage();

  Rxn<UserEntity> user = Rxn();
  final _userPermissionHelper = UserPermissionHelper().obs;
  UserPermissionHelper get userPermissionHelper => _userPermissionHelper.value;

  final _isLoggoingOut = false.obs;
  bool get isLoggoingOut => _isLoggoingOut.value;

  /// The one logout path. Idempotent — concurrent 401s collapse into a single
  /// teardown. [callApi] is false when the token is already dead server-side.
  Future<void> logout({bool callApi = true}) async {
    if (_isLoggoingOut.value || !_isAuthenticated.value) return;
    _isLoggoingOut(true);
    // Flip state before any await so concurrent flows (splash, refreshProfile)
    // see it immediately.
    _isAuthenticated.value = false;
    user.value = null;
    try {
      if (callApi) {
        try {
          await logoutUsecase.call(const NoParams());
        } catch (_) {}
      }
      await clearUserData();
    } finally {
      _isLoggoingOut(false);
    }
    // Not awaited: this future only completes when LOGIN is popped.
    unawaited(Get.offAllNamed(Routes.LOGIN));
  }

  Future<void> clearUserData() async {
    userPermissionHelper.reset();
    // Sign out from Firebase Auth
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Firebase Auth signOut failed: $e');
    }
    try {
      await Future.wait(
        [
          storage.remove(UserPrefKeys.userDetails),
          storage.remove(AuthenticationPrefKeys.isLoggedIn),
          storage.remove(AuthenticationPrefKeys.token),
          storage.remove(UserPrefKeys.userId),
          RealtimeConfigurationStorageHelper.clear(),
          SharedPrefrencesHelper.clearMyDetails(),
          SharedPrefrencesHelper.clearClockInOutSessionId(),
        ],
        eagerError: false,
        cleanUp: (_) {},
      );
    } catch (e) {
      // This will catch any errors that were not handled in the onError callback
      debugPrint('Failed to clear all user data: $e');
    } finally {
      // Always dispose of services regardless of errors
      if (Get.isRegistered<PusherManager>()) {
        sl<PusherManager>().dispose();
      }
    }

    //
    // clear converstions
    try {
      //
      await ConversationsDatabase().deleteAllConversation();
    } catch (_) {}

    //
    // clear group converstions
    try {
      //
      await GroupConversationsDatabase().deleteAllGroupConversation();
    } catch (_) {}

    //
    // clear converstions messages
    try {
      //
      await MessagesDatabase().deleteMessages();
    } catch (_) {}
  }

  Future<void> storeRealtimeConfiguration() async {
    final result = await getRealtimeConfigurationUseCase.call(const NoParams());

    await result.fold<Future<void>>(
      (BaseResponse<RealtimeConfiguration> response) async {
        final configuration = response.data;
        if (configuration == null) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: 'Realtime configuration response is empty.',
          );
          return;
        }

        await RealtimeConfigurationStorageHelper.store(configuration);
      },
      (Failure failure) async {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: failure.message,
        );
      },
    );
  }

  /// Server copy replaces both user caches; on failure the cache stands.
  Future<void> refreshProfile() async {
    try {
      final result = await getProfileUseCase.call(const NoParams());

      await result.fold<Future<void>>(
        (fresh) async {
          // A logout may have landed while the request was in flight.
          if (!_isAuthenticated.value) return;
          user.value = fresh;
          final String? token = storage.read(AuthenticationPrefKeys.token);
          await Future.wait([
            storage.write(UserPrefKeys.userDetails, fresh.toEntity()),
            if (token != null)
              SharedPrefrencesHelper.storeMyDetails(fresh, token),
          ]);
        },
        (failure) async {
          debugPrint('Profile refresh skipped: ${failure.message}');
        },
      );
    } catch (e) {
      debugPrint('Profile refresh failed: $e');
    }
  }

  /// FCM `user_role_updated`. Pulls the whole profile — roles ride on it — and
  /// forces re-login when dispatcher access flips, since the tab set changes.
  Future<void> updateUserRoles() async {
    // Read before refreshProfile() overwrites user.value.
    final bool wasDispatcher = userPermissionHelper.isDispatcher();

    await Future.wait([
      refreshProfile(),
      userPermissionHelper.reloadUserPermissions(),
    ]);

    if (userPermissionHelper.isDispatcher() != wasDispatcher) {
      debugPrint('Dispatcher access changed — re-login');
      await logout();
    }
  }
}

class UserPermissionHelper {
  // get user permission usecase
  final _userPermissionsUsecase = sl<GetUserPermissionsUseCase>();

  // user permissions list
  final RxList<UserPermissionEntity> _userPermissions =
      RxList<UserPermissionEntity>();

  // permission success state
  final RxBool _userPermissionsRetrievedSuccessfully = false.obs;
  bool get userPermissionsRetrievedSuccessfully =>
      _userPermissionsRetrievedSuccessfully.value;

  Future<void> init() => _loadUserPermissions();

  /// [resetOnFailure] clears the cached list when the fetch fails — wanted on
  /// a cold load, not on a refresh, where the previous list is still valid.
  Future<void> _fetchUserPermissions({required bool resetOnFailure}) async {
    if (!Get.find<AuthController>().isAuthenticated) {
      return;
    }
    try {
      // calling get user permissions usecase
      final response = await _userPermissionsUsecase.call(const NoParams());

      // processing response
      response.fold(
        (left) {
          if (left.data?.isNotEmpty ?? false) {
            debugPrint('User permissions fetched: ${left.data?.length}');
            _userPermissions.value = left.data!;
            _userPermissionsRetrievedSuccessfully(true);
          }
        },
        (right) {
          if (resetOnFailure) reset();
        },
      );
    } catch (_) {
      if (resetOnFailure) reset();
    }
  }

  Future<void> _loadUserPermissions() =>
      _fetchUserPermissions(resetOnFailure: true);

  /// Clears the cached list — called on logout and on fetch failure.
  void reset() {
    // clear() on an empty RxList still notifies — would loop gated Obx rebuilds.
    if (_userPermissions.isNotEmpty) _userPermissions.clear();
    _userPermissionsRetrievedSuccessfully(false);
  }

  bool _loadInFlight = false;

  void _refreshUserPermissions() {
    if (userPermissionsRetrievedSuccessfully && _userPermissions.isNotEmpty) {
      return;
    }
    if (_loadInFlight) return;
    _loadInFlight = true;
    _loadUserPermissions().whenComplete(() => _loadInFlight = false);
  }

  Future<void> reloadUserPermissions() =>
      _fetchUserPermissions(resetOnFailure: false);

  bool isSuperAdmin() {
    return Get.find<AuthController>().user.value?.hasAnyRole([
          SystemRulesKeys.superAdmin,
        ]) ??
        false;
  }

  bool canManageGroups() {
    _refreshUserPermissions();
    return _userPermissions.firstWhereOrNull(
          (element) => element.name == "manage-chat-groups",
        ) !=
        null;
  }

  bool canCreateGroup() {
    _refreshUserPermissions();
    final groupSuperPermission = canManageGroups();
    return groupSuperPermission ||
        (_userPermissions.firstWhereOrNull(
              (element) => element.name == "create-group",
            ) !=
            null);
  }

  bool canAddParticipantsInGroup() {
    _refreshUserPermissions();
    final groupSuperPermission = canManageGroups();
    return groupSuperPermission ||
        (_userPermissions.firstWhereOrNull(
              (element) => element.name == "add-participant-in-group",
            ) !=
            null);
  }

  bool canRemoveParticipantsInGroup() {
    _refreshUserPermissions();
    final groupSuperPermission = canManageGroups();
    return groupSuperPermission ||
        (_userPermissions.firstWhereOrNull(
              (element) => element.name == "remove-participant-from-group",
            ) !=
            null);
  }

  bool canViewUsers() {
    _refreshUserPermissions();
    return _userPermissions.firstWhereOrNull(
          (element) => element.name == "read-users",
        ) !=
        null;
  }

  bool canCreateUsers() {
    _refreshUserPermissions();
    return _userPermissions.firstWhereOrNull(
          (element) => element.name == "create-users",
        ) !=
        null;
  }

  bool canUpdateUsers() {
    _refreshUserPermissions();
    return (_userPermissions.firstWhereOrNull(
          (element) => element.name == "update-users",
        ) !=
        null);
  }

  bool canReadInvoices() {
    _refreshUserPermissions();
    return (_userPermissions.firstWhereOrNull(
          (element) => element.name == "read-invoices",
        ) !=
        null);
  }

  bool canUpdateInvoices() {
    _refreshUserPermissions();
    return (_userPermissions.firstWhereOrNull(
          (element) => element.name == "update-invoices",
        ) !=
        null);
  }

  bool canResolveAdditionalPays() {
    _refreshUserPermissions();
    return isSuperAdmin() ||
        _userPermissions.firstWhereOrNull(
              (element) => element.name == "resolve-additional-pay-approvals",
            ) !=
            null;
  }

  bool isDispatcher() {
    if (Get.isRegistered<AuthController>()) {
      final AuthController authController = Get.find<AuthController>();
      return authController.user.value?.hasAnyRole([
            SystemRulesKeys.superAdmin,
            SystemRulesKeys.dispatcher,
          ]) ??
          false;
    }
    return false;
  }

  bool canViewMessageNotifications() {
    _refreshUserPermissions();
    return (_userPermissions.firstWhereOrNull(
              (element) => element.name == "unread-messages-notifications",
            ) !=
            null) ||
        isSuperAdmin();
  }
}

// permissions as per current system (last refesh date: 07/May/2024)
// final permissions = [
//   {"id": 1, "name": "create-languages"},
//   {"id": 2, "name": "read-languages"},
//   {"id": 3, "name": "update-languages"},
//   {"id": 4, "name": "export-languages"},
//   {"id": 5, "name": "import-languages"},
//   {"id": 6, "name": "create-options"},
//   {"id": 7, "name": "read-options"},
//   {"id": 8, "name": "update-options"},
//   {"id": 9, "name": "export-options"},
//   {"id": 10, "name": "import-options"},
//   {"id": 11, "name": "create-cities"},
//   {"id": 12, "name": "read-cities"},
//   {"id": 13, "name": "update-cities"},
//   {"id": 14, "name": "export-cities"},
//   {"id": 15, "name": "import-cities"},
//   {"id": 16, "name": "create-states"},
//   {"id": 17, "name": "read-states"},
//   {"id": 18, "name": "update-states"},
//   {"id": 19, "name": "export-states"},
//   {"id": 20, "name": "import-states"},
//   {"id": 21, "name": "create-areas"},
//   {"id": 22, "name": "read-areas"},
//   {"id": 23, "name": "update-areas"},
//   {"id": 24, "name": "export-areas"},
//   {"id": 25, "name": "import-areas"},
//   {"id": 26, "name": "create-zones"},
//   {"id": 27, "name": "read-zones"},
//   {"id": 28, "name": "update-zones"},
//   {"id": 29, "name": "export-zones"},
//   {"id": 30, "name": "import-zones"},
//   {"id": 31, "name": "create-notifications"},
//   {"id": 32, "name": "read-notifications"},
//   {"id": 33, "name": "update-notifications"},
//   {"id": 34, "name": "export-notifications"},
//   {"id": 35, "name": "import-notifications"},
//   {"id": 36, "name": "create-tasks"},
//   {"id": 37, "name": "read-tasks"},
//   {"id": 38, "name": "update-tasks"},
//   {"id": 39, "name": "export-tasks"},
//   {"id": 40, "name": "import-tasks"},
//   {"id": 41, "name": "create-shortcuts"},
//   {"id": 42, "name": "read-shortcuts"},
//   {"id": 43, "name": "update-shortcuts"},
//   {"id": 44, "name": "export-shortcuts"},
//   {"id": 45, "name": "import-shortcuts"},
//   {"id": 46, "name": "create-documentExpirations"},
//   {"id": 47, "name": "read-documentExpirations"},
//   {"id": 48, "name": "update-documentExpirations"},
//   {"id": 49, "name": "export-documentExpirations"},
//   {"id": 50, "name": "import-documentExpirations"},
//   {"id": 51, "name": "create-users"},
//   {"id": 52, "name": "read-users"},
//   {"id": 53, "name": "update-users"},
//   {"id": 54, "name": "export-users"},
//   {"id": 55, "name": "import-users"},
//   {"id": 56, "name": "create-roles"},
//   {"id": 57, "name": "read-roles"},
//   {"id": 58, "name": "update-roles"},
//   {"id": 59, "name": "export-roles"},
//   {"id": 60, "name": "import-roles"},
//   {"id": 61, "name": "create-permissions"},
//   {"id": 62, "name": "read-permissions"},
//   {"id": 63, "name": "update-permissions"},
//   {"id": 64, "name": "export-permissions"},
//   {"id": 65, "name": "import-permissions"},
//   {"id": 66, "name": "create-teams"},
//   {"id": 67, "name": "read-teams"},
//   {"id": 68, "name": "update-teams"},
//   {"id": 69, "name": "export-teams"},
//   {"id": 70, "name": "import-teams"},
//   {"id": 71, "name": "create-permissionCategories"},
//   {"id": 72, "name": "read-permissionCategories"},
//   {"id": 73, "name": "update-permissionCategories"},
//   {"id": 74, "name": "export-permissionCategories"},
//   {"id": 75, "name": "import-permissionCategories"},
//   {"id": 76, "name": "create-trucks"},
//   {"id": 77, "name": "read-trucks"},
//   {"id": 78, "name": "update-trucks"},
//   {"id": 79, "name": "export-trucks"},
//   {"id": 80, "name": "import-trucks"},
//   {"id": 81, "name": "create-trailers"},
//   {"id": 82, "name": "read-trailers"},
//   {"id": 83, "name": "update-trailers"},
//   {"id": 84, "name": "export-trailers"},
//   {"id": 85, "name": "import-trailers"},
//   {"id": 86, "name": "create-drivers"},
//   {"id": 87, "name": "read-drivers"},
//   {"id": 88, "name": "update-drivers"},
//   {"id": 89, "name": "export-drivers"},
//   {"id": 90, "name": "import-drivers"},
//   {"id": 91, "name": "create-companies"},
//   {"id": 92, "name": "read-companies"},
//   {"id": 93, "name": "update-companies"},
//   {"id": 94, "name": "export-companies"},
//   {"id": 95, "name": "import-companies"},
//   {"id": 96, "name": "create-devices"},
//   {"id": 97, "name": "read-devices"},
//   {"id": 98, "name": "update-devices"},
//   {"id": 99, "name": "export-devices"},
//   {"id": 100, "name": "import-devices"},
//   {"id": 101, "name": "create-equipmentTypes"},
//   {"id": 102, "name": "read-equipmentTypes"},
//   {"id": 103, "name": "update-equipmentTypes"},
//   {"id": 104, "name": "export-equipmentTypes"},
//   {"id": 105, "name": "import-equipmentTypes"},
//   {"id": 106, "name": "create-licenses"},
//   {"id": 107, "name": "read-licenses"},
//   {"id": 108, "name": "update-licenses"},
//   {"id": 109, "name": "export-licenses"},
//   {"id": 110, "name": "import-licenses"},
//   {"id": 111, "name": "create-inspections"},
//   {"id": 112, "name": "read-inspections"},
//   {"id": 113, "name": "update-inspections"},
//   {"id": 114, "name": "export-inspections"},
//   {"id": 115, "name": "import-inspections"},
//   {"id": 116, "name": "create-accidents"},
//   {"id": 117, "name": "read-accidents"},
//   {"id": 118, "name": "update-accidents"},
//   {"id": 119, "name": "export-accidents"},
//   {"id": 120, "name": "import-accidents"},
//   {"id": 121, "name": "create-deviceAssigns"},
//   {"id": 122, "name": "read-deviceAssigns"},
//   {"id": 123, "name": "update-deviceAssigns"},
//   {"id": 124, "name": "export-deviceAssigns"},
//   {"id": 125, "name": "import-deviceAssigns"},
//   {"id": 126, "name": "create-checkCategories"},
//   {"id": 127, "name": "read-checkCategories"},
//   {"id": 128, "name": "update-checkCategories"},
//   {"id": 129, "name": "export-checkCategories"},
//   {"id": 130, "name": "import-checkCategories"},
//   {"id": 131, "name": "create-checks"},
//   {"id": 132, "name": "read-checks"},
//   {"id": 133, "name": "update-checks"},
//   {"id": 134, "name": "export-checks"},
//   {"id": 135, "name": "import-checks"},
//   {"id": 136, "name": "create-truckInspections"},
//   {"id": 137, "name": "read-truckInspections"},
//   {"id": 138, "name": "update-truckInspections"},
//   {"id": 139, "name": "export-truckInspections"},
//   {"id": 140, "name": "import-truckInspections"},
//   {"id": 141, "name": "create-roadTests"},
//   {"id": 142, "name": "read-roadTests"},
//   {"id": 143, "name": "update-roadTests"},
//   {"id": 144, "name": "export-roadTests"},
//   {"id": 145, "name": "import-roadTests"},
//   {"id": 146, "name": "create-truckDrivers"},
//   {"id": 147, "name": "read-truckDrivers"},
//   {"id": 148, "name": "update-truckDrivers"},
//   {"id": 149, "name": "export-truckDrivers"},
//   {"id": 150, "name": "import-truckDrivers"},
//   {"id": 151, "name": "create-claims"},
//   {"id": 152, "name": "read-claims"},
//   {"id": 153, "name": "update-claims"},
//   {"id": 154, "name": "export-claims"},
//   {"id": 155, "name": "import-claims"},
//   {"id": 156, "name": "create-claimTypes"},
//   {"id": 157, "name": "read-claimTypes"},
//   {"id": 158, "name": "update-claimTypes"},
//   {"id": 159, "name": "export-claimTypes"},
//   {"id": 160, "name": "import-claimTypes"},
//   {"id": 161, "name": "create-deductions"},
//   {"id": 162, "name": "read-deductions"},
//   {"id": 163, "name": "update-deductions"},
//   {"id": 164, "name": "export-deductions"},
//   {"id": 165, "name": "import-deductions"},
//   {"id": 166, "name": "create-customers"},
//   {"id": 167, "name": "read-customers"},
//   {"id": 168, "name": "update-customers"},
//   {"id": 169, "name": "export-customers"},
//   {"id": 170, "name": "import-customers"},
//   {"id": 171, "name": "create-carriers"},
//   {"id": 172, "name": "read-carriers"},
//   {"id": 173, "name": "update-carriers"},
//   {"id": 174, "name": "export-carriers"},
//   {"id": 175, "name": "import-carriers"},
//   {"id": 176, "name": "create-shipments"},
//   {"id": 177, "name": "read-shipments"},
//   {"id": 178, "name": "update-shipments"},
//   {"id": 179, "name": "export-shipments"},
//   {"id": 180, "name": "import-shipments"},
//   {"id": 181, "name": "create-trips"},
//   {"id": 182, "name": "read-trips"},
//   {"id": 183, "name": "update-trips"},
//   {"id": 184, "name": "export-trips"},
//   {"id": 185, "name": "import-trips"},
//   {"id": 186, "name": "create-requireDocuments"},
//   {"id": 187, "name": "read-requireDocuments"},
//   {"id": 188, "name": "update-requireDocuments"},
//   {"id": 189, "name": "export-requireDocuments"},
//   {"id": 190, "name": "import-requireDocuments"},
//   {"id": 191, "name": "create-folders"},
//   {"id": 192, "name": "read-folders"},
//   {"id": 193, "name": "update-folders"},
//   {"id": 194, "name": "export-folders"},
//   {"id": 195, "name": "import-folders"},
//   {"id": 196, "name": "create-applicants"},
//   {"id": 197, "name": "read-applicants"},
//   {"id": 198, "name": "update-applicants"},
//   {"id": 199, "name": "export-applicants"},
//   {"id": 200, "name": "import-applicants"},
//   {"id": 201, "name": "create-applicantForms"},
//   {"id": 202, "name": "read-applicantForms"},
//   {"id": 203, "name": "update-applicantForms"},
//   {"id": 204, "name": "export-applicantForms"},
//   {"id": 205, "name": "import-applicantForms"},
//   {"id": 206, "name": "create-applicantFormValues"},
//   {"id": 207, "name": "read-applicantFormValues"},
//   {"id": 208, "name": "update-applicantFormValues"},
//   {"id": 209, "name": "export-applicantFormValues"},
//   {"id": 210, "name": "import-applicantFormValues"},
//   {"id": 211, "name": "create-forms"},
//   {"id": 212, "name": "read-forms"},
//   {"id": 213, "name": "update-forms"},
//   {"id": 214, "name": "export-forms"},
//   {"id": 215, "name": "import-forms"},
//   {"id": 216, "name": "create-formFields"},
//   {"id": 217, "name": "read-formFields"},
//   {"id": 218, "name": "update-formFields"},
//   {"id": 219, "name": "export-formFields"},
//   {"id": 220, "name": "import-formFields"},
//   {"id": 221, "name": "create-documentRequests"},
//   {"id": 222, "name": "read-documentRequests"},
//   {"id": 223, "name": "update-documentRequests"},
//   {"id": 224, "name": "export-documentRequests"},
//   {"id": 225, "name": "import-documentRequests"},
//   {"id": 226, "name": "create-answers"},
//   {"id": 227, "name": "read-answers"},
//   {"id": 228, "name": "update-answers"},
//   {"id": 229, "name": "export-answers"},
//   {"id": 230, "name": "import-answers"},
//   {"id": 231, "name": "create-questions"},
//   {"id": 232, "name": "read-questions"},
//   {"id": 233, "name": "update-questions"},
//   {"id": 234, "name": "export-questions"},
//   {"id": 235, "name": "import-questions"},
//   {"id": 236, "name": "create-videos"},
//   {"id": 237, "name": "read-videos"},
//   {"id": 238, "name": "update-videos"},
//   {"id": 239, "name": "export-videos"},
//   {"id": 240, "name": "import-videos"},
//   {"id": 241, "name": "create-traineeVideos"},
//   {"id": 242, "name": "read-traineeVideos"},
//   {"id": 243, "name": "update-traineeVideos"},
//   {"id": 244, "name": "export-traineeVideos"},
//   {"id": 245, "name": "import-traineeVideos"},
//   {"id": 246, "name": "create-inspectionRequests"},
//   {"id": 247, "name": "read-inspectionRequests"},
//   {"id": 248, "name": "update-inspectionRequests"},
//   {"id": 249, "name": "export-inspectionRequests"},
//   {"id": 250, "name": "import-inspectionRequests"},
//   {"id": 251, "name": "create-checklists"},
//   {"id": 252, "name": "read-checklists"},
//   {"id": 253, "name": "update-checklists"},
//   {"id": 254, "name": "export-checklists"},
//   {"id": 255, "name": "import-checklists"},
//   {"id": 256, "name": "create-locations"},
//   {"id": 257, "name": "read-locations"},
//   {"id": 258, "name": "update-locations"},
//   {"id": 259, "name": "export-locations"},
//   {"id": 260, "name": "import-locations"},
//   {"id": 261, "name": "create-batches"},
//   {"id": 262, "name": "read-batches"},
//   {"id": 263, "name": "update-batches"},
//   {"id": 264, "name": "export-batches"},
//   {"id": 265, "name": "import-batches"},
//   {"id": 266, "name": "create-invoices"},
//   {"id": 267, "name": "read-invoices"},
//   {"id": 268, "name": "update-invoices"},
//   {"id": 269, "name": "export-invoices"},
//   {"id": 270, "name": "import-invoices"},
//   {"id": 271, "name": "create-roadsideInspections"},
//   {"id": 272, "name": "read-roadsideInspections"},
//   {"id": 273, "name": "update-roadsideInspections"},
//   {"id": 274, "name": "export-roadsideInspections"},
//   {"id": 275, "name": "import-roadsideInspections"},
//   {"id": 276, "name": "create-media"},
//   {"id": 277, "name": "read-media"},
//   {"id": 278, "name": "update-media"},
//   {"id": 279, "name": "export-media"},
//   {"id": 280, "name": "import-media"},
//   {"id": 281, "name": "create-drugs"},
//   {"id": 282, "name": "read-drugs"},
//   {"id": 283, "name": "update-drugs"},
//   {"id": 284, "name": "export-drugs"},
//   {"id": 285, "name": "import-drugs"},
//   {"id": 291, "name": "create-transactions"},
//   {"id": 292, "name": "read-transactions"},
//   {"id": 293, "name": "update-transactions"},
//   {"id": 294, "name": "export-transactions"},
//   {"id": 295, "name": "import-transactions"},
//   {"id": 296, "name": "create-vehicleMaintenanceRecords"},
//   {"id": 297, "name": "read-vehicleMaintenanceRecords"},
//   {"id": 298, "name": "update-vehicleMaintenanceRecords"},
//   {"id": 299, "name": "export-vehicleMaintenanceRecords"},
//   {"id": 300, "name": "import-vehicleMaintenanceRecords"},
//   {"id": 301, "name": "create-suppliers"},
//   {"id": 302, "name": "read-suppliers"},
//   {"id": 303, "name": "update-suppliers"},
//   {"id": 304, "name": "export-suppliers"},
//   {"id": 305, "name": "import-suppliers"},
//   {"id": 306, "name": "create-shopInventories"},
//   {"id": 307, "name": "read-shopInventories"},
//   {"id": 308, "name": "update-shopInventories"},
//   {"id": 309, "name": "export-shopInventories"},
//   {"id": 310, "name": "import-shopInventories"},
//   {"id": 311, "name": "create-payrollBatches"},
//   {"id": 312, "name": "read-payrollBatches"},
//   {"id": 313, "name": "update-payrollBatches"},
//   {"id": 314, "name": "export-payrollBatches"},
//   {"id": 315, "name": "import-payrollBatches"},
//   {"id": 316, "name": "create-reimbursements"},
//   {"id": 317, "name": "read-reimbursements"},
//   {"id": 318, "name": "update-reimbursements"},
//   {"id": 319, "name": "export-reimbursements"},
//   {"id": 320, "name": "import-reimbursements"},
//   {"id": 321, "name": "delete-inspectionRequests"},
//   {"id": 322, "name": "view_report_deduction-history-details"},
//   {"id": 323, "name": "view_report_deduction-summary"},
//   {"id": 324, "name": "add-clock-in-out-record"},
//   {"id": 325, "name": "delete-clock-in-out-record"},
//   {"id": 326, "name": "visible-clock-module"},
//   {"id": 327, "name": "view_report_invoices-reports"},
//   {"id": 328, "name": "view_report_deductions-report"},
//   {"id": 329, "name": "create-payPlans"},
//   {"id": 330, "name": "read-payPlans"},
//   {"id": 331, "name": "update-payPlans"},
//   {"id": 332, "name": "export-payPlans"},
//   {"id": 333, "name": "import-payPlans"},
//   {"id": 334, "name": "create-banks"},
//   {"id": 335, "name": "read-banks"},
//   {"id": 336, "name": "update-banks"},
//   {"id": 337, "name": "export-banks"},
//   {"id": 338, "name": "import-banks"},
//   {"id": 339, "name": "view_report_timesheet-report"},
//   {"id": 340, "name": "create-settlements"},
//   {"id": 341, "name": "read-settlements"},
//   {"id": 342, "name": "update-settlements"},
//   {"id": 343, "name": "export-settlements"},
//   {"id": 344, "name": "import-settlements"},
//   {"id": 345, "name": "approve-settlements"},
//   {"id": 346, "name": "manage-chat-groups"},
//   {"id": 347, "name": "view_report_deduction-history-report"},
//   {"id": 348, "name": "create-group"},
//   {"id": 349, "name": "add-participant-in-group"},
//   {"id": 350, "name": "remove-participant-from-group"},
//   {"id": 351, "name": "delete-batches"},
//   {"id": 352, "name": "delete-deductions"},
//   {"id": 353, "name": "delete-reimbursements"},
//   {"id": 354, "name": "pay-settlements"},
//   {"id": 355, "name": "reporting-panel"},
//   {"id": 356, "name": "drivers-for-payroll"},
//   {"id": 357, "name": "view_report_fuel-report"},
//   {"id": 358, "name": "view_call_logs"},
//   {"id": 359, "name": "viewHorizon"},
//   {"id": 360, "name": "viewWebSocketsDashboard"},
//   {"id": 362, "name": "edit-timesheet"},
//   {"id": 363, "name": "delete-timesheet"},
//   {"id": 365, "name": "delete-documentRequests"},
//   {"id": 368, "name": "view_report_invoices-report"},
//   {"id": 369, "name": "view_report_settlements-report"},
//   {"id": 370, "name": "view_report_settlements-summary-report"},
//   {"id": 371, "name": "view_report_driver-reimbursement-detail-report"},
//   {"id": 373, "name": "view_report_payment-history-detail-report"},
//   {"id": 374, "name": "view_report_truck-pay-report"},
//   {"id": 378, "name": "view_report_shipments-to-invoice"},
//   {"id": 379, "name": "view_report_collection-report"},
//   {"id": 380, "name": "view_report_settlement-history"},
//   {"id": 386, "name": "view_report_miles-report"},
//   {"id": 435, "name": "read-system"},
//   {"id": 436, "name": "read-hrmanagement"},
//   {"id": 437, "name": "read-lmsmanagement"},
//   {"id": 438, "name": "read-assetmanagement"},
//   {"id": 439, "name": "read-paymanagement"},
//   {"id": 440, "name": "read-safetymanagement"},
//   {"id": 441, "name": "read-drugandalcohol"},
//   {"id": 442, "name": "read-inspectionmanagement"},
//   {"id": 443, "name": "read-dispatchmanagement"},
//   {"id": 444, "name": "read-documentmanagement"},
//   {"id": 445, "name": "read-usermanagement"},
//   {"id": 446, "name": "read-shopmanagement"},
//   {"id": 447, "name": "read-fuelcards"},
//   {"id": 448, "name": "read-accountingledger"},
//   {"id": 449, "name": "read-notification"},
//   {"id": 450, "name": "read-load-tracking"},
//   {"id": 451, "name": "read-reporting"},
//   {"id": 465, "name": "read-violations"}
// ];

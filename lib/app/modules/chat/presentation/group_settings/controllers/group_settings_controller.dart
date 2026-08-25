import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/remove_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_logo_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_name_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_logo_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_name_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_participant_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/add_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/remove_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_group_logo_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_group_name_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_participant_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/views/dialogs/remove_participant_confirmation_dialog.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class GroupSettingsController extends GetxController implements TickerProvider {
  final Rx<GroupSettingsTabs> currentTab = GroupSettingsTabs.admins.obs;

  final AuthController authController = Get.find<AuthController>();

  late TabController tabController;

  final addParticipantsUseCase = sl<AddParticipantsUseCase>();
  final updateGroupNameUsecase = sl<UpdateGroupNameUseCase>();
  final updateGroupLogoUsecase = sl<UpdateGroupLogoUseCase>();
  final removeParticipantsUseCase = sl<RemoveParticipantsUseCase>();
  final updateParticipantsUseCase = sl<UpdateParticipantUsecase>();

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final RxBool autoAddDrivers = false.obs;

  Animation<double>? animation;
  AnimationController? animationController;

  final RxnInt groupId = RxnInt();
  final RxString groupName = ''.obs;
  final RxString groupLogo = ''.obs;
  final RxInt groupCreatorId = 0.obs;

  var removingAtIndex = -1;
  var updatingParticipantAtIndex = -1;
  var removingUserType = ModelType.USERS;

  final Rxn<GroupConversationEntity> group = Rxn();

  //
  //
  // participants list
  final RxList<ParticipantEntity> admins = RxList();
  final RxList<ParticipantEntity> filteredAdmins = RxList();
  final RxList<ParticipantEntity> drivers = RxList();
  final RxList<ParticipantEntity> filteredDrivers = RxList();

  final RxBool _fabMenuOpened = false.obs;
  bool get fabMenuOpened => _fabMenuOpened.value;

  final RxBool _isHeaderExpanded = false.obs;
  bool get isHeaderExpanded => _isHeaderExpanded.value;

  //updating group name state
  final RxBool _isUpdatingGroupName = false.obs;
  bool get isUpdatingGroupName => _isUpdatingGroupName.value;

  //updating group logo state
  final RxBool _isUpdatingGroupLogo = false.obs;
  bool get isUpdatingGroupLogo => _isUpdatingGroupLogo.value;

  // removing participant state
  final RxBool _isRemovingParticipant = false.obs;
  bool get isRemovingParticipant => _isRemovingParticipant.value;

  // update participant state
  final RxBool _isUpdatingParticipant = false.obs;
  bool get isUpdatingParticipant => _isUpdatingParticipant.value;

  // search enabled state
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (tabController.index == 0) {
        currentTab(GroupSettingsTabs.admins);
      } else if (tabController.index == 1) {
        currentTab(GroupSettingsTabs.drivers);
      }
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    loadGroupDetails();

    groupNameController.text = groupName.value;

    searchController.addListener(() {
      _applySearch();
    });
  }

  //
  //
  // this function will apply search on the admin and driver members
  void _applySearch() {
    filteredAdmins.clear();
    filteredDrivers.clear();
    if (searchController.text.isEmpty) {
      _isSearchEnabled(false);

      //
      // resetting admin and driver search filtered list
      filteredAdmins.addAll(admins);
      filteredDrivers.addAll(drivers);
    } else {
      _isSearchEnabled(true);

      //
      // filtering admins participants
      filteredAdmins.addAll(
        admins.where(
          (item) {
            final name = item.name
                    ?.toLowerCase()
                    .contains(searchController.text.toString().toLowerCase()) ??
                false;
            return name;
          },
        ),
      );

      //
      // filtering drivers participants
      filteredDrivers.addAll(
        drivers.where(
          (item) {
            final name = item.name
                    ?.toLowerCase()
                    .contains(searchController.text.toString().toLowerCase()) ??
                false;
            return name;
          },
        ),
      );
    }
  }

  //
  //
  // function will fetch group details and
  // load details in the reactive variables
  GroupConversationEntity? loadGroupDetails() {
    try {
      final group = _getGroup();

      if (group == null) {
        return null;
      }

      this.group.value = group;

      if (group.name != null) {
        groupName.value = group.name!;
      }

      if (group.groupSettings?.logo != null) {
        groupLogo.value = group.groupSettings!.logo!;
      }

      autoAddDrivers.value = group.groupSettings?.autoAddDrivers ?? false;

      _loadGroupCreatorDetails(group);

      admins.clear();
      filteredAdmins.clear();
      drivers.clear();
      filteredDrivers.clear();

      //
      // filter admins
      if ((group.conversations ?? []).isNotEmpty) {
        for (var converstion in group.conversations!) {
          //
          if ((converstion.participants ?? []).isNotEmpty) {
            for (var participant in converstion.participants!) {
              //
              if (participant.modelType == ModelType.USERS) {
                //
                if (admins.firstWhereOrNull((item) =>
                        item.id == participant.id && participant.id != null) ==
                    null) {
                  admins.add(participant);
                }
              } else if (participant.modelType == ModelType.APPLICANTS) {
                //
                if (drivers.firstWhereOrNull((item) =>
                        item.id == participant.id && participant.id != null) ==
                    null) {
                  drivers.add(participant);
                }
              }
            }
          }
        }
      }

      //
      //
      filteredAdmins.addAll(admins);
      filteredDrivers.addAll(drivers);
      return group;
    } catch (_) {
      return null;
    }
  }

  ///
  ///
  /// function to get current group id from params
  int? getGroupId() {
    if (groupId.value == null) {
      final args = Get.arguments;
      if (args == null) {
        return null;
      }

      if (args is! int) {
        return null;
      }

      final int id = args;

      groupId.value = id;
    }

    return groupId.value;
  }

  //
  //
  // function to get current group
  GroupConversationEntity? _getGroup() {
    try {
      //
      final id = getGroupId();

      if (id == null) {
        return null;
      }

      if (!Get.isRegistered<GroupConversationsController>()) {
        return null;
      }

      return Get.find<GroupConversationsController>()
          .groupConversations
          .firstWhereOrNull((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  //
  //
  // function to load group creator details
  _loadGroupCreatorDetails(GroupConversationEntity? group) {
    try {
      //
      if (group != null) {
        //
        // find a conversation in a group having a group creator details
        final conversation = group.conversations
            ?.firstWhereOrNull((item) => item.modelId != null);

        // if converstion found with creator details then store details
        if (conversation != null) {
          groupCreatorId.value = conversation.modelId!;
        }
      }
    } catch (_) {}
  }

  //
  //
  // function will find a participant in the converstion and return conversation id
  int? _getConversationId(ParticipantEntity participant) {
    try {
      if (participant.pid == null) {
        return null;
      }

      final groupDetails = group.value ?? _getGroup();

      if (groupDetails == null) {
        return null;
      }

      return groupDetails.conversations
          ?.firstWhereOrNull((conversation) => (conversation.participants
                  ?.firstWhereOrNull((item) => (item.pid == participant.pid)) !=
              null))
          ?.id;
    } catch (_) {
      return null;
    }
  }

  //
  //
  // function to update participant
  updateParticipant(ParticipantEntity participant, int index) async {
    //
    if (isUpdatingParticipant) {
      return;
    }

    updatingParticipantAtIndex = index;

    // call update participant api
    try {
      final conversationId = _getConversationId(participant);

      if (conversationId == null) {
        return;
      }

      _isUpdatingParticipant(true);
      final Either<BaseResponse<bool>, Failure> result =
          await updateParticipantsUseCase.call(UpdateParticipantParams(
              conversationId: conversationId,
              pid: participant.pid!,
              isGroupAdmin: participant.isGroupAdmin!));

      _isUpdatingParticipant(false);

      result.fold((BaseResponse<bool> updateResponse) {
        if (updateResponse.data ?? false) {
          //
          // notify converstions controller that particiant updated
          try {
            final id = getGroupId();

            if (Get.isRegistered<GroupConversationsController>() &&
                id != null) {
              final converstionController =
                  Get.find<GroupConversationsController>();
              converstionController.onParticipantPermissionsUpdated(
                  id, participant);
            }
          } catch (_) {}
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: updateResponse.message ?? "Some thing went wrong.",
              isError: false);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
            title: 'Error'.tr, message: r.message, isError: false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error'.tr, message: e.toString(), isError: false);
      debugPrint(e.toString());
      _isUpdatingParticipant(false);
    }

    updatingParticipantAtIndex = -1;
  }

  void onFabButtonClicked() {
    if (fabMenuOpened) {
      animationController?.reverse();
    } else {
      animationController?.forward();
    }
    _fabMenuOpened.toggle();
  }

  void setHeaderExpantionState(bool state) {
    _isHeaderExpanded(state);
  }

  //
  //
  // function of hitting api for updating group name
  updateGroupName(UpdateGroupNameParams params) async {
    if (_isUpdatingGroupName.value) {
      return;
    }

    try {
      _isUpdatingGroupName(true);
      final Either<UpdateGroupNameEntity, Failure> result =
          await updateGroupNameUsecase.call(params);

      _isUpdatingGroupName(false);

      result.fold((UpdateGroupNameEntity newGroup) {
        if (newGroup.error == false && newGroup.code == 200) {
          Get.back();

          //
          //
          // notifying main group converstions module that group name updated
          final id = getGroupId();
          if (Get.isRegistered<GroupConversationsController>() && id != null) {
            Get.find<GroupConversationsController>()
                .onGroupNameUpdated(id, params.toGroupName);
          }

          groupName.value = params.toGroupName;
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: newGroup.message ?? "Some thing went wrong.",
              isError: false);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
            title: 'Error'.tr, message: r.message, isError: false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error'.tr, message: e.toString(), isError: false);
      debugPrint(e.toString());
      _isUpdatingGroupName(false);
    }
  }

  //
  //
  // function of hitting api for updating group logo
  _updateGroupLogo(UpdateGroupLogoParams params) async {
    if (_isUpdatingGroupLogo.value) {
      return;
    }

    try {
      _isUpdatingGroupLogo(true);
      final Either<UpdateGroupLogoEntity, Failure> result =
          await updateGroupLogoUsecase.call(params);

      _isUpdatingGroupLogo(false);

      result.fold((UpdateGroupLogoEntity newLogo) {
        if (newLogo.error == false && newLogo.code == 200) {
          if (newLogo.data?.isNotEmpty ?? false) {
            groupLogo.value = newLogo.data!;

            //
            //
            // notifying main group converstions module that group logo updated
            try {
              final id = getGroupId();
              if (Get.isRegistered<GroupConversationsController>() &&
                  id != null) {
                Get.find<GroupConversationsController>()
                    .onGroupLogoUpdated(id, newLogo.data!);
              }
            } catch (_) {}
          }
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: newLogo.message ?? "Some thing went wrong.",
              isError: false);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
            title: 'Error'.tr, message: r.message, isError: false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error'.tr, message: e.toString(), isError: false);
      debugPrint(e.toString());
      _isUpdatingGroupLogo(false);
    }
  }

  void onUpdateLogoClicked() async {
    final file = await pickFile(Get.context!);
    final id = getGroupId();
    if (file != null && id != null) {
      final params = UpdateGroupLogoParams(
        groupId: id,
        file: File(file.path),
      );
      await _updateGroupLogo(params);
    }
  }

  showRemoveParticipantConfirmationDialog(
      ParticipantEntity participant, int index) {
    //
    Get.defaultDialog(
      title: 'Remove Participant',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      titlePadding: EdgeInsets.only(top: 10.h),
      content: RemoveParticipantConfirmationDialog(
        name: participant.name ?? '',
        onRemoveCalled: () {
          //
          // function to notify that user confirmed to remove the user
          if (participant.pid != null) {
            removingAtIndex = index;
            removingUserType = participant.modelType ?? ModelType.USERS;
            Get.back();
            _removeParticipant(
                participant.pid!, participant.id, participant.modelType);
          }
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );
  }

  _removeParticipant(
      int participantId, int? userId, ModelType? modelType) async {
    if (_isRemovingParticipant.value) {
      return;
    }

    // call add participant api
    try {
      _isRemovingParticipant(true);
      final Either<RemoveParticipantsEntity, Failure> result =
          await removeParticipantsUseCase.call(participantId);

      _isRemovingParticipant(false);

      result.fold((RemoveParticipantsEntity addParticipantResponse) {
        if (addParticipantResponse.error == false &&
            addParticipantResponse.code == 200) {
          // closing add participants bottom sheet and clearing states

          CommonWidgets.showSnackBar(
              title: 'Successful',
              message: addParticipantResponse.message ??
                  "Participant removed successfully and moved to Archived.",
              isError: false);

          try {
            //
            // refesh group details
            try {
              final id = getGroupId();
              if (Get.isRegistered<GroupConversationsController>() &&
                  id != null) {
                Get.find<GroupConversationsController>()
                    .onParticipantRemoved(id, userId, modelType);
              }
            } catch (_) {}
          } catch (_) {}
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message:
                  addParticipantResponse.message ?? "Some thing went wrong.",
              isError: false);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
            title: 'Error'.tr, message: r.message, isError: false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error'.tr, message: e.toString(), isError: false);
      debugPrint(e.toString());
      _isRemovingParticipant(false);
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  void onParticipantRemoved(int groupId) {
    final id = getGroupId();
    if (id != groupId) {
      return;
    }
    loadGroupDetails();
  }

  void onParticipantPermissionsUpdated(int groupId) {
    final id = getGroupId();
    if (id != groupId) {
      return;
    }
    loadGroupDetails();
  }

  bool iAmAdmin() {
    if (admins.isEmpty) {
      return false;
    }

    final me = admins.firstWhereOrNull((item) =>
        (item.id == authController.user.value?.id) &&
        (item.id != null) &&
        (item.modelType == ModelType.USERS));

    return me?.isGroupAdmin ?? false;
  }

  bool iAmGroupCreator() {
    if (admins.isEmpty) {
      return false;
    }

    final me = admins.firstWhereOrNull((item) =>
        (item.id != null) &&
        (item.id == authController.user.value?.id) &&
        (item.modelType == ModelType.USERS));

    return (groupCreatorId.value == me?.id);
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    super.onClose();
    groupNameController.dispose();
    searchController.dispose();
    animationController?.dispose();
  }
}

enum GroupSettingsTabs { admins, drivers }

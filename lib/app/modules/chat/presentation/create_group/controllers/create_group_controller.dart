import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_group_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_group_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/create_group_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class CreateGroupController extends GetxController {
  //
  final AuthController authController = Get.find<AuthController>();

  // states
  // 1 -> select admins
  // 2 -> select drivers
  // 3 -> inpput group name
  final RxInt groupCreationState = GroupCreationStates.selectAdmins.obs;

  //
  //
  //  usecases
  final getGroupContactsUseCase = sl<GetGroupContactsUseCase>();
  final creatGroupUseCase = sl<CreateGroupUseCase>();

  //
  //
  // input text controllers
  TextEditingController adminSearchTextController = TextEditingController();
  TextEditingController driverSearchTextController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  RxBool autoAddDrivers = false.obs;

  //
  //
  // refesh controllers
  RefreshController refreshController = RefreshController();

  //
  //
  // lists for the contacts
  final Rxn<GroupContactsEntity> groupContacts = Rxn();
  final RxList<ContactEntity> selectedAdmins = RxList<ContactEntity>();
  final RxList<ContactEntity> filtertedAdmins = RxList<ContactEntity>();
  final RxList<ContactEntity> selectedDrivers = RxList<ContactEntity>();
  final RxList<ContactEntity> filtertedDrivers = RxList<ContactEntity>();

  //
  //
  ////////////////////////// state variables /////////////////////////////////

  //group contacts loading state
  final RxBool _isLoadingGroupContacts = false.obs;
  bool get isLoadingGroupContacts => _isLoadingGroupContacts.value;

  // this states indicates error occured or not while loading contacts
  final RxBool _errorWhileLoadingGroupContacts = false.obs;
  bool get errorWhileLoadingGroupContacts =>
      _errorWhileLoadingGroupContacts.value;

  // creating new group state
  final RxBool _isCreatingGroup = false.obs;
  bool get isCreatingGroup => _isCreatingGroup.value;

  // state that indicates search is enabled in admins contacts list
  final RxBool isAdminSearchEnabled = false.obs;

  // state that indicates search is enabled in drivers contacts list
  final RxBool isDriverSearchEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    // if group contacts already loaded in the group conversation controller
    // get from it else load from api
    try {
      if (Get.isRegistered<GroupConversationsController>()) {
        final groupConversationsController =
            Get.find<GroupConversationsController>();
        if (groupConversationsController.groupContacts.value != null) {
          groupContacts.value =
              groupConversationsController.groupContacts.value;
        } else {
          getGroupContacts();
        }
      } else {
        getGroupContacts();
      }
    } catch (_) {
      getGroupContacts();
    }

    adminSearchTextController.addListener(() {
      _applyAdminsContactsSearch();
    });
    driverSearchTextController.addListener(() {
      _applyDriversContactsSearch();
    });
  }

  //
  //
  // function that will apply search on driver contacts and also update search enabled state
  _applyAdminsContactsSearch() {
    if (adminSearchTextController.text.isNotEmpty) {
      final searchText = adminSearchTextController.text.toLowerCase();
      if (groupContacts.value?.admins?.isNotEmpty ?? false) {
        isAdminSearchEnabled(true);
        filtertedAdmins.clear();
        filtertedAdmins.addAll(groupContacts.value!.admins!.where((element) {
          final name =
              element.name?.toLowerCase().contains(searchText) ?? false;
          final phone =
              element.phone?.toLowerCase().contains(searchText) ?? false;
          return name || phone;
        }));
      }
    } else {
      isAdminSearchEnabled(false);
      filtertedAdmins.clear();
    }
  }

  //
  //
  // function that will apply search on driver contacts and also update search enabled state
  _applyDriversContactsSearch() {
    if (driverSearchTextController.text.isNotEmpty) {
      final searchText = driverSearchTextController.text.toLowerCase();
      if (groupContacts.value?.applicants?.isNotEmpty ?? false) {
        isDriverSearchEnabled(true);
        filtertedDrivers.clear();
        filtertedDrivers
            .addAll(groupContacts.value!.applicants!.where((element) {
          final name =
              element.name?.toLowerCase().contains(searchText) ?? false;
          final phone =
              element.phone?.toLowerCase().contains(searchText) ?? false;
          return name || phone;
        }));
      }
    } else {
      isDriverSearchEnabled(false);
      filtertedDrivers.clear();
    }
  }

  //
  //
  // clear admin search and reset the states admin search states
  void clearAdminsSearch() {
    isAdminSearchEnabled(false);
    filtertedAdmins.clear();
    adminSearchTextController.clear();
  }

  //
  //
  // clear drivers search and reset the states admin search states
  void clearDriversSearch() {
    isDriverSearchEnabled(false);
    filtertedDrivers.clear();
    driverSearchTextController.clear();
  }

  //
  //
  // creating group
  Future<void> createGroup(CreateGroupParams params) async {
    if (_isCreatingGroup.value) {
      return;
    }

    // call create group api
    try {
      _isCreatingGroup(true);
      final Either<CreateGroupEntity, Failure> result =
          await creatGroupUseCase.call(params);

      _isCreatingGroup(false);

      result.fold((CreateGroupEntity newGroup) {
        if (newGroup.error == false && newGroup.code == 200) {
          // closing create group page
          Get.back();
          CommonWidgets.showSnackBar(
              title: 'Successful',
              message: newGroup.message ?? "Group created successfully.",
              isError: false);

          // if data conversations is not empty then add to list from here else refesh groups list
          if (Get.isRegistered<GroupConversationsController>()) {
            try {
              final groupConversationsController =
                  Get.find<GroupConversationsController>();
              if (newGroup.data != null) {
                groupConversationsController
                    .addGroupAndSyncWithDatabase(newGroup.data!);
              } else {
                try {
                  groupConversationsController.getGroupHeads();
                } catch (_) {}
              }
            } catch (_) {}
          }
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
      _isCreatingGroup(false);
    }
  }

  //
  //
  // loading group contacts from api using contacts usecase
  Future<void> getGroupContacts() async {
    if (!(authController.userPermissionHelper.canCreateGroup())) {
      return;
    }
    try {
      _isLoadingGroupContacts(true);
      _errorWhileLoadingGroupContacts(false);

      final Either<GroupContactsEntity, Failure> result =
          await getGroupContactsUseCase.call(const NoParams());

      result.fold((GroupContactsEntity contactsFromRemote) {
        groupContacts.value = contactsFromRemote;
      }, (Failure r) {
        _errorWhileLoadingGroupContacts(true);
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });

      _isLoadingGroupContacts(false);
    } on Exception catch (e) {
      _errorWhileLoadingGroupContacts(true);
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingGroupContacts(false);
    }
  }

  //
  //
  // function to handle the popo scope
  void onBackPressed(bool didPop) {
    if (groupCreationState.value == 3) {
      groupCreationState(2);
    } else if (groupCreationState.value == 2) {
      groupCreationState(1);
    } else if (!didPop) {
      Get.back(canPop: true);
    }
  }
}

class GroupCreationStates {
  static const selectAdmins = 1;
  static const selectDrivers = 2;
  static const nameInput = 3;

  static const values = [1, 2, 3];
}

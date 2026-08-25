import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/add_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/add_participants_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/add_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class AddAdminParticipantsController extends GetxController {
  //
  //
  //  auth controller

  final AuthController authController = Get.find<AuthController>();

  //
  // input controller
  TextEditingController searchController = TextEditingController();

  final RxnInt groupId = RxnInt();
  final RxString groupName = ''.obs;
  final RxString groupLogo = ''.obs;

  //
  //
  // usecases
  final getGroupContactsUseCase = sl<GetGroupContactsUseCase>();
  final addParticipantsUseCase = sl<AddParticipantsUseCase>();

  //
  //
  // contacts lists
  final RxList<ContactEntity> selectedAdmins = RxList<ContactEntity>();
  final RxList<ContactEntity> admins = RxList<ContactEntity>();
  final RxList<ContactEntity> filteredAdmins = RxList<ContactEntity>();

  // adding participant state
  final RxBool _isAddingParticipant = false.obs;
  bool get isAddingParticipant => _isAddingParticipant.value;

  //group contacts loading state
  final RxBool _isLoadingGroupContacts = false.obs;
  bool get isLoadingGroupContacts => _isLoadingGroupContacts.value;

  //search enabled/disabled state
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  @override
  void onInit() {
    super.onInit();

    _loadContacts();

    final group = _getGroup();
    if (group != null) {
      groupName.value = group.name ?? '';
      groupLogo.value = group.groupSettings?.logo ?? '';
    }

    searchController.addListener(() {
      applySearch(searchController.text);
    });
  }

  ///
  ///
  /// This function will load contacts from the group converstions controller
  /// if available else it will load from api and also cashed them.
  _loadContacts() {
    try {
      //
      // check if contacts already loaded and cashed in the group conversations controller
      // load from group converstions controller else load from api
      if (Get.isRegistered<GroupConversationsController>()) {
        final contacts =
            Get.find<GroupConversationsController>().groupContacts.value;

        if (contacts != null) {
          _filterAdmins(contacts);
        }
        //
        // if contacts from controller is null then get from a api
        else {
          _getGroupContactsFromApi();
        }
      }

      //
      // load from api
      else {
        _getGroupContactsFromApi();
      }
    } catch (_) {}
  }

  ///
  ///
  /// loading group contacts from api using contacts usecase
  Future<void> _getGroupContactsFromApi() async {
    if (!(authController.userPermissionHelper.canCreateGroup())) {
      return;
    }
    try {
      _isLoadingGroupContacts(true);
      final Either<GroupContactsEntity, Failure> result =
          await getGroupContactsUseCase.call(const NoParams());

      _isLoadingGroupContacts(false);

      result.fold((GroupContactsEntity contactsFromRemote) {
        _filterAdmins(contactsFromRemote);
        _cacheTheContacts(contactsFromRemote);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingGroupContacts(false);
    }
  }

  ///
  ///
  /// This function will filter the admin contacts from group cantacts
  /// and get only those admin contacts that are not in group participants
  void _filterAdmins(GroupContactsEntity groupContacts) {
    if ((groupContacts.admins ?? []).isEmpty) {
      return;
    }
    //
    final group = _getGroup();
    if (group == null) {
      return;
    }
    final idsToExclude = _fetchAdminParticipantsIds(group);

    admins.clear();
    filteredAdmins.clear();

    //
    // filtering admins whose ids are not in 'idsToExclude' list
    admins.addAll(groupContacts.admins!
        .where((contact) => (!idsToExclude.contains(contact.id))));
    filteredAdmins.addAll(admins);
  }

  ///
  ///
  /// this function will fetch the participants from the group converstions
  List<int> _fetchAdminParticipantsIds(GroupConversationEntity group) {
    //
    // if converstions list empty return empty list
    if ((group.conversations ?? []).isEmpty) {
      return [];
    }

    List<int> idsToExclude = [];

    // getting list of the "list of group participiants"
    final listOfGroupPartcipantsList =
        (group.conversations!.map((e) => e.participants ?? [])).toList();

    // iterating over the lists of the participants
    for (var participantsList in listOfGroupPartcipantsList) {
      // iterating over the participants list
      for (var participant in participantsList) {
        // checking if participant is admin and if its id is not already
        // in the idsToExclude list then add its id in the idsToExclude
        if ((!idsToExclude.contains(participant.id)) &&
            (participant.modelType == ModelType.USERS) &&
            (participant.id != null)) {
          idsToExclude.add(participant.id!);
        }
      }
    }

    return idsToExclude;
  }

  ///
  ///
  /// function to get current group id from params
  int? _getGroupId() {
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

  ///
  ///
  /// function to get current group
  GroupConversationEntity? _getGroup() {
    try {
      //
      final id = _getGroupId();

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

  ///
  ///
  /// This function will cache the contacts in the group conversations controller
  void _cacheTheContacts(GroupContactsEntity? groupContacts) {
    if (groupContacts != null) {
      try {
        //
        if (Get.isRegistered<GroupConversationsController>()) {
          Get.find<GroupConversationsController>().groupContacts.value =
              groupContacts;
        }
      } catch (_) {}
    }
  }

  ///
  ///
  /// This function will call the api of add particiants
  addParticpant(AddParticipantsParams params) async {
    if (_isAddingParticipant.value) {
      return;
    }

    // call add participant api
    try {
      _isAddingParticipant(true);
      final Either<AddParticipantsEntity, Failure> result =
          await addParticipantsUseCase.call(params);

      _isAddingParticipant(false);

      result.fold((AddParticipantsEntity addParticipantResponse) async {
        if (addParticipantResponse.error == false &&
            addParticipantResponse.code == 200) {
          // closing add participants bottom sheet
          Get.back();

          CommonWidgets.showSnackBar(
              title: 'Successful',
              message: addParticipantResponse.message ??
                  "Participants added successfully.",
              isError: false);

          //
          // need to notify main controller that participanst added successfully
          _notifyParticipantsAddedSuccessfully();
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
      _isAddingParticipant(false);
    }
  }

  ///
  ///
  /// this function will notify the main group that particpants added successfully
  void _notifyParticipantsAddedSuccessfully() {
    try {
      //
      final id = _getGroupId();

      if (id == null) {
        return;
      }

      //
      // notify chat detail view that particiapnt added
      try {
        if (Get.isRegistered<ChatDetailController>()) {
          final chatDetailController = Get.find<ChatDetailController>();
          chatDetailController.onParticipantAdded(id);
        }
      } catch (_) {}

      if (!Get.isRegistered<GroupConversationsController>()) {
        return;
      }

      Get.find<GroupConversationsController>().refreshGroupDetails(id);
    } catch (_) {}
  }

  //
  //
  // search by admin name
  void applySearch(String query) {
    if (query.isEmpty) {
      clearSearch();
      return;
    }
    filteredAdmins.clear();
    filteredAdmins.addAll(
      admins.where(
        (item) {
          final nameCheck =
              item.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
          return nameCheck;
        },
      ),
    );
  }

  //
  //
  // clear the search state
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.clear();
    filteredAdmins.clear();
    filteredAdmins.addAll(admins);
  }

  void toggleSearch() {
    _isSearchEnabled.toggle();
  }
}

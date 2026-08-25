import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/chat_navigation.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/create_new_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_all_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ContactsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  //
  //
  // usecases
  final getAllContactsUseCase = sl<GetAllContactsUseCase>();
  final createNewConversationUseCase = sl<CreateNewConversationUseCase>();

  //
  //
  // text edit controllers

  //
  //
  // refresh controllers
  RefreshController contactRefreshController =
      RefreshController(initialRefresh: false);

  //
  //
  // contacts lists
  final RxList<ContactEntity> contacts = RxList<ContactEntity>();
  final RxList<ContactEntity> filteredContacts = RxList<ContactEntity>();

  /////////////////////////// state variables //////////////////////////////////

  //
  //
  //contacts loading state
  final RxBool _isLoadingContacts = false.obs;
  bool get isLoadingContacts => _isLoadingContacts.value;

  // creating new conversation state
  final RxBool _isCreatingNewConversation = false.obs;
  bool get isCreatingNewConversation => _isCreatingNewConversation.value;

  final RxBool isSearchEnabled = false.obs;

  int creatingConverstionAtIndex = -1;

  @override
  void onInit() {
    super.onInit();
    getAllContacts();
  }

  //
  //
  // loading contacts from api using contacts usecase
  Future<void> getAllContacts() async {
    contacts.clear();
    try {
      _isLoadingContacts(true);
      final Either<List<ContactEntity>, Failure> result =
          await getAllContactsUseCase.call(const NoParams());

      _isLoadingContacts(false);

      result.fold((List<ContactEntity> contactsFromRemote) {
        contacts.value = contactsFromRemote;
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
      _isLoadingContacts(false);
    }
  }

  //
  //
  // creating new conversation
  Future<void> createNewConversation(
      String applicantId, String userType, int index) async {
    if (_isCreatingNewConversation.value) {
      return;
    }
    //
    // if trying to create my own chat or trying to naviagate to my own chat from mentioned user
    // then return the function dont create or navigate to it self chat
    final String myId = GetStorage().read(UserPrefKeys.userId).toString();
    if (applicantId == myId && userType == "users") {
      return;
    }

    // check if user is already in conversation then no need
    // to call create conversation api
    ConversationEntity? foundConversation;

    try {
      if (Get.isRegistered<OtoConversationsController>()) {
        foundConversation = Get.find<OtoConversationsController>()
            .conversations
            .firstWhereOrNull((element) {
          return (element.user?.id?.toString() == applicantId) &&
              (element.user?.modelType == userType);
        });
      }
    } catch (_) {}

    if (foundConversation != null) {
      try {
        await ChatNavigation.open(
            ChatNavigation.otoArguments(foundConversation));
      } catch (_) {}
      return;
    }

    // conversation not found so call create conversation api
    try {
      creatingConverstionAtIndex = index;
      _isCreatingNewConversation(true);
      final Either<CreateConversationEntity, Failure> result =
          await createNewConversationUseCase.call(CreateConversationParams(
              userId: applicantId, userType: userType));

      _isCreatingNewConversation(false);

      creatingConverstionAtIndex = -1;

      final ConversationEntity? created = result.fold(
        (CreateConversationEntity newConversation) =>
            newConversation.conversation,
        (Failure r) {
          CommonWidgets.showSnackBar(title: 'Error'.tr, message: r.message);
          return null;
        },
      );

      if (created?.user == null) {
        return;
      }

      // Refresh first so the fetch is in flight during the route transition.
      try {
        Get.find<OtoConversationsController>().getAllConversations();
      } catch (_) {}

      await ChatNavigation.open(ChatNavigation.otoArguments(created!));
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isCreatingNewConversation(false);
      creatingConverstionAtIndex = -1;
    }
  }

  //
  //
  // search by firstname, lastname, name, phone
  void applySearch(String query) {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    isSearchEnabled(true);

    filteredContacts.clear();
    filteredContacts.addAll(contacts.where((item) {
      final name =
          item.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
      final phone =
          item.phone?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return name || phone;
    }));
  }

  //
  //
  //
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    isSearchEnabled(false);
    filteredContacts.clear();
    filteredContacts.addAll(contacts);
  }
}

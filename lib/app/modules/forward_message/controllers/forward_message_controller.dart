import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/forward_message_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/forward_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/forward_message_usecase.dart';
import 'package:ts_admin/app/modules/chat/data/models/conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/group_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ForwardMessageController extends GetxController
    implements TickerProvider {
  late TabController tabController;

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  RxList<ConversationMessageEntity> messages = RxList();

  final Rx<ForwardMessageTabs> currentTab = ForwardMessageTabs.chat.obs;

  final AuthController authController = Get.find<AuthController>();
  final forwardMessageUsecase = sl<ForwardMessageUseCase>();

  TextEditingController searchTextController = TextEditingController();
  TextEditingController innerSearchTextController = TextEditingController();

  // oto conversations list
  final RxList<ConversationEntity> conversations = RxList<ConversationEntity>();
  final RxList<ConversationEntity> filteredConversations =
      RxList<ConversationEntity>();

  // group conversations list
  final RxList<GroupConversationEntity> groupConversations =
      RxList<GroupConversationEntity>();
  final RxList<GroupConversationEntity> filteredGroupConversations =
      RxList<GroupConversationEntity>();

  // inner search list for group conversations
  final RxList<GroupConversationConversationEntity> filteredInnerConversations =
      RxList<GroupConversationConversationEntity>();

  // selected oto conversations
  final RxList<int> selectedConversations = RxList<int>();

  // selected group conversations
  final RxList<int> selectedGroupConversations = RxList<int>();

  final RxInt expandedGroupHead = (-1).obs;
  final String myId = GetStorage().read(UserPrefKeys.userId).toString();

  // states
  final RxBool isSearchEnabled = false.obs;
  final RxBool isInnerSearchEnabled = false.obs;
  final RxBool isForwarding = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      searchTextController.clear();
      if (tabController.index == 0) {
        currentTab(ForwardMessageTabs.chat);
      } else {
        currentTab(ForwardMessageTabs.group);
      }
    });

    try {
      messages.value = Get.arguments as List<ConversationMessageEntity>;
    } catch (_) {}

    if (messages.isEmpty) {
      Get.back();
    }

    // cheking if conversations controller is registered then copy
    // the convesations and group conversations list
    try {
      if (Get.isRegistered<OtoConversationsController>()) {
        // copying conversations
        conversations
            .addAll(Get.find<OtoConversationsController>().conversations);
      }

      if (Get.isRegistered<GroupConversationsController>()) {
        // copying group conversations
        groupConversations.addAll(
            Get.find<GroupConversationsController>().groupConversations);
      }
    } catch (_) {}

    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        isSearchEnabled(false);
        filteredGroupConversations.clear();
        filteredConversations.clear();
        filteredConversations.addAll(conversations);
        filteredGroupConversations.addAll(groupConversations);
      } else {
        applySearch();
      }
    });
    super.onInit();
  }

  // handling when tap on one to one conversation
  onConversationTap(int? id) {
    if (id == null) {
      return;
    }
    if (selectedConversations.contains(id)) {
      selectedConversations.remove(id);
    } else if (getSelectedConversationsCount() < 5) {
      selectedConversations.add(id);
    } else {
      CommonWidgets.showSnackBar(
          title: "",
          message: "Can forward only 5 conversations.",
          isError: false);
    }
  }

  // handling when tap on group conversation
  onGroupConversationTap(int? id) {
    if (id == null) {
      return;
    }
    if (selectedGroupConversations.contains(id)) {
      selectedGroupConversations.remove(id);
    } else if (getSelectedConversationsCount() < 5) {
      selectedGroupConversations.add(id);
    } else {
      CommonWidgets.showSnackBar(
          title: "",
          message: "Can forward only 5 conversations.",
          isError: false);
    }
  }

  // return true if any one inner conversation is selected
  isGroupSelected(
      List<GroupConversationConversationEntity> innerConversations) {
    var contains = false;
    for (var element in innerConversations) {
      if (selectedGroupConversations.contains(element.id)) {
        contains = true;
      }
    }
    return contains;
  }

  // return counts of selected inner conversation
  int groupInnerConversationsSelectedCount(
      List<GroupConversationConversationEntity> innerConversations) {
    var count = 0;
    for (var element in innerConversations) {
      if (selectedGroupConversations.contains(element.id)) {
        count += 1;
      }
    }
    return count;
  }

  List<int> _getSelectedConversations() {
    List<int> list = [];
    list.addAll(selectedConversations);
    list.addAll(selectedGroupConversations);
    return list;
  }

  int getSelectedConversationsCount() {
    int count = 0;
    count += selectedConversations.length;
    count += selectedGroupConversations.length;
    return count;
  }

  void clearSearch() {
    searchTextController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearInnerSearch(
      List<GroupConversationConversationEntity> innerConversations) {
    innerSearchTextController.clear();
    filteredInnerConversations.clear();
    filteredInnerConversations.addAll(innerConversations);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // applying search in the bases of selected tab and add then to filtered list
  // search by firstname, lastname, name, phone
  void applySearch() {
    isSearchEnabled(true);
    // if active tab is chat then apply search on the conversations
    if (currentTab.value == ForwardMessageTabs.chat) {
      filteredConversations.clear();
      filteredConversations.addAll(conversations.where((item) {
        final phone = item.user?.phone
                ?.toLowerCase()
                .contains(searchTextController.text.toString().toLowerCase()) ??
            false;
        final name = item.user?.name
                ?.toLowerCase()
                .contains(searchTextController.text.toString().toLowerCase()) ??
            false;
        return phone || name;
      }));
    }

    // if active tab is group then apply search on group conversations list
    else if (currentTab.value == ForwardMessageTabs.group) {
      filteredGroupConversations.clear();
      filteredGroupConversations.addAll(groupConversations.where((item) {
        final nameCheck = item.name
                ?.toLowerCase()
                .contains(searchTextController.text.toString().toLowerCase()) ??
            false;
        return nameCheck;
      }));
    }
  }

  // applying search in the inner conversation of selected group
  // search by firstname, lastname, name, phone
  void applyInnerSearch(
      List<GroupConversationConversationEntity> innerConversations) {
    filteredInnerConversations.clear();
    if (innerSearchTextController.text.isEmpty) {
      filteredInnerConversations.addAll(innerConversations);
    } else {
      filteredInnerConversations.addAll(innerConversations.where((item) {
        final name = item.name?.toLowerCase().contains(
                innerSearchTextController.text.toString().toLowerCase()) ??
            false;
        return name;
      }));
    }
  }

  String getSelectedConversationsName() {
    String names = "";

    // checking for the selected oto conversations and filtering names
    if (selectedConversations.isNotEmpty) {
      final cons =
          conversations.where((p0) => selectedConversations.contains(p0.id));
      names = cons
          .map((e) => (e.name ?? ""))
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', '');
    }

    if (selectedGroupConversations.isNotEmpty) {
      for (var group in groupConversations) {
        final groupNames = group.conversations
            ?.where((p0) => selectedGroupConversations.contains(p0.id))
            .map((e) => (e.name ?? ""))
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '');
        if (groupNames?.isNotEmpty ?? false) {
          if (names.isEmpty) {
            names = groupNames!;
          } else {
            names += ", ${groupNames!}";
          }
        }
      }
    }
    return names;
  }

  forwardMessage(ConversationMessageEntity message) async {
    //
    //
    if (getSelectedConversationsCount() < 1) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: "Please select at least one conversation.",
      );
      return;
    }
    //
    //
    try {
      isForwarding(true);
      final Either<ForwardMessageEntity, Failure> result =
          await forwardMessageUsecase.call(ForwardMessageParams(
              messageId: message.id!,
              conversations: _getSelectedConversations()));
      isForwarding(false);
      result.fold((ForwardMessageEntity forwardedMessage) {
        if (forwardedMessage.code == 200) {
          //
          // sorting conversations lists on the bases of forwaded last message

          try {
            message.createdAt = DateTime.now();

            if (Get.isRegistered<OtoConversationsController>()) {
              final conversationsController =
                  Get.find<OtoConversationsController>();

              // checking and sorting oto conversations
              if (selectedConversations.isNotEmpty) {
                for (var element in selectedConversations) {
                  conversationsController.moveConversationOnTop(element,
                      ConversationLastMessageModel.fromJson(message.toJson()));
                }
              }
            }

            // checking and sorting group conversations
            if (selectedGroupConversations.isNotEmpty &&
                Get.isRegistered<GroupConversationsController>()) {
              final groupConversationsController =
                  Get.find<GroupConversationsController>();
              for (var element in selectedGroupConversations) {
                groupConversationsController.onNewMessage(
                    element, GroupLastMessageModel.fromJson(message.toJson()));
              }
            }
          } catch (_) {}

          //
          //
          if (message.id! == messages.last.id!) {
            Get.back();
            CommonWidgets.showSnackBar(
                title: 'Success'.tr,
                message:
                    "Message${messages.length > 1 ? "'s" : ""} forwarded successfully.",
                isError: false);
          }
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: forwardedMessage.message ?? "Something went wrong.",
          );
        }
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
      isForwarding(false);
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '$hours:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
    } else {
      return '${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

enum ForwardMessageTabs { chat, group }

import 'dart:async';
import 'dart:convert';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';

import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';
import 'package:ts_admin/app/modules/chat/data/models/presence_added_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/presence_data_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/contacts/controllers/contacts_controller.dart';

import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/controllers/message_notifications_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ConversationsController extends GetxController implements TickerProvider {
  final Rx<ConversationTabs> currentTab = ConversationTabs.chat.obs;

  late TabController tabController;

  final AuthController authController = Get.find<AuthController>();

  TextEditingController searchTextController = TextEditingController();

  // getting pusher manager
  final pusher = sl<PusherManager>();

  StreamSubscription<ChannelReadEvent>? messageNotificationSubscription;
  StreamSubscription<ChannelReadEvent>? onlineSubscriptionSucceededSubscription;
  StreamSubscription<ChannelReadEvent>? onlineUserAddedSubscription;
  StreamSubscription<ChannelReadEvent>? onlineUserRemovedSubscription;

  // list of the online user ids
  final RxList<OnlineUser> onlineUsers = RxList<OnlineUser>();

  final RxInt _otoUnreadCounts = 0.obs;
  int get otoUnreadCounts => _otoUnreadCounts.value;

  final RxInt _groupUnreadCounts = 0.obs;
  int get groupUnreadCounts => _groupUnreadCounts.value;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      searchTextController.clear();
      if (tabController.index == 0) {
        currentTab(ConversationTabs.chat);
      } else if (tabController.index == 1) {
        currentTab(ConversationTabs.group);
      } else {
        currentTab(ConversationTabs.contacts);
      }
    });

    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        clearSearch();
      } else {
        applySearch();
      }
    });

    // attaching message notification listener
    attachNotificationListener();
  }

  attachNotificationListener() async {
    var messageNotificationChannel =
        await pusher.subscribeToMessageNotificationChannel();
    messageNotificationSubscription =
        messageNotificationChannel.bind("message-received").listen((event) {
      try {
        if (event.data != null) {
          final jsonData = jsonDecode(event.data);
          final int conversationId = jsonData['conversation_id'];
          final dynamic message = jsonData['message'];

          //
          //
          // notify oto conversations controller
          try {
            if (Get.isRegistered<OtoConversationsController>()) {
              Get.find<OtoConversationsController>().moveConversationOnTop(
                conversationId,
                ConversationLastMessageEntity.fromJson(message),
                incrementUnread: true,
              );
            }
          } catch (_) {}

          //
          //
          // notify group conversations controller
          try {
            if (Get.isRegistered<GroupConversationsController>()) {
              Get.find<GroupConversationsController>().onNewMessage(
                conversationId,
                GroupLastMessageEntity.fromJson(message),
              );
            }
          } catch (_) {}

          //
          //
          // notify message notifications controller
          try {
            //
            // check if that conversation is already active
            // no need to notify message notifications controller
            if (Get.isRegistered<ChatDetailController>()) {
              if (Get.find<ChatDetailController>().conversationId ==
                  conversationId) {
                return;
              }
            }

            //
            // notify message notifications controller
            if (Get.isRegistered<MessageNotificationsController>()) {
              if (jsonData["group_head_id"] != null) {
                message["group"] = {
                  "id": jsonData["group_head_id"],
                  "name": jsonData["conversation_group_name"],
                };
              }
              Get.find<MessageNotificationsController>()
                  .insertNewMessageNotification(
                MessageNotificationEntity.fromJson(message),
              );
            }
          } catch (_) {}
        }
      } catch (_) {}
    });

    //
    // online users channel
    final onlineUserChannel = await pusher.subscribeToOnlineChannel();

    // when subscription succeded handling already online user data
    onlineSubscriptionSucceededSubscription =
        onlineUserChannel.whenSubscriptionSucceeded().listen((event) {
      try {
        if (event.data != null) {
          // fetching data (converting from map to dart model)
          final presenceData = presenceDataModelFromJson(event.data);
          onlineUsers.clear();
          if (presenceData.presence?.hash != null) {
            presenceData.presence!.hash!.forEach((key, value) {
              onlineUsers
                  .add(OnlineUser(id: value.id, modelType: value.modelType));
            });
          }
        }
      } catch (_) {}
    });

    //lisner when new user added or join the socket
    onlineUserAddedSubscription =
        onlineUserChannel.whenMemberAdded().listen((event) {
      try {
        if (event.data != null) {
          // fetching data
          final newUser = presenceUserAddedModelFromJson(event.data).user;

          // print(
          //     "////////////////////// on user added called ===> ${event.data.toString()}");
          if (newUser != null) {
            if (onlineUsers.firstWhereOrNull((element) =>
                    (element.id == newUser.id) &&
                    (element.modelType == newUser.modelType)) ==
                null) {
              onlineUsers.add(
                  OnlineUser(id: newUser.id, modelType: newUser.modelType));
            }
          }
        }
      } catch (_) {}
    });

    // listener when user is removed or disconnected
    onlineUserRemovedSubscription =
        onlineUserChannel.whenMemberRemoved().listen((event) {
      // {event: pusher:member_removed, channel: presence-online-channel, data: {"user_id":"14"}}
      try {
        if (event.data != null) {
          // fetching data
          final json = jsonDecode(event.data);

          // print(
          //     "////////////////////// on user removed called ===> ${event.data.toString()}");

          if (json['user_id'] != null) {
            final removedUserId = json['user_id'];
            onlineUsers.removeWhere(
                (element) => element.id.toString() == removedUserId.toString());
          }
        }
      } catch (_) {}
    });
  }

  bool isUserOnline(int? id, String? modelType) {
    return (onlineUsers.firstWhereOrNull(
            (element) => element.id == id && element.modelType == modelType) !=
        null);
  }

  void updateOtoUnreadCounts() {
    _otoUnreadCounts.value = 0;

    //
    // getting unread counts from one to one conversation
    try {
      if (Get.isRegistered<OtoConversationsController>()) {
        _otoUnreadCounts.value =
            Get.find<OtoConversationsController>().otoUnreadCounts.value;
      }
    } catch (_) {}
  }

  void updateGroupUnreadCounts() {
    _groupUnreadCounts.value = 0;

    //
    // getting unread counts from one to one conversation
    try {
      if (Get.isRegistered<GroupConversationsController>()) {
        _groupUnreadCounts.value =
            Get.find<GroupConversationsController>().groupUnreadCounts.value;
      }
    } catch (_) {}
  }

  @override
  void onClose() async {
    messageNotificationSubscription?.cancel();
    onlineSubscriptionSucceededSubscription?.cancel();
    onlineUserAddedSubscription?.cancel();
    onlineUserRemovedSubscription?.cancel();

    pusher.unsubscribeMessageNotificationChannel();
    pusher.unsubscribeOnlineChannel();

    super.onClose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  void applySearch() {
    if (currentTab.value == ConversationTabs.chat) {
      _getOtoConversationsController()?.applySearch(searchTextController.text);
    } else if (currentTab.value == ConversationTabs.group) {
      _getGroupConversationsController()
          ?.applySearch(searchTextController.text);
    } else if (currentTab.value == ConversationTabs.contacts) {
      _getContactsController()?.applySearch(searchTextController.text);
    }
  }

  void clearSearch() {
    _getOtoConversationsController()?.clearSearch();
    _getGroupConversationsController()?.clearSearch();
    _getContactsController()?.clearSearch();
  }

  OtoConversationsController? _getOtoConversationsController() {
    try {
      if (Get.isRegistered<OtoConversationsController>()) {
        return Get.find<OtoConversationsController>();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  GroupConversationsController? _getGroupConversationsController() {
    try {
      if (Get.isRegistered<GroupConversationsController>()) {
        return Get.find<GroupConversationsController>();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  ContactsController? _getContactsController() {
    try {
      if (Get.isRegistered<ContactsController>()) {
        return Get.find<ContactsController>();
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

enum ConversationTabs { chat, group, contacts }

class OnlineUser {
  int? id;
  String? modelType;
  OnlineUser({
    this.id,
    this.modelType,
  });
}

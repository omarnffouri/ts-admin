import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_documents_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_thumbnail_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/data/models/messages_notifications_db_model.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/messages_notifications_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_message_notifications_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/message_mark_as_read_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class MessageNotificationsController extends GetxController {
  //
  //
  // data variables
  final RxList<MessageNotificationEntity> messagesNotifications = RxList();
  final Rxn<MessageNotificationPaginationEntity> currentPagination = Rxn();
  final RxDouble audioPlayerSpeed = (1.0).obs;
  final Rxn<AudioPlayer> currentAudioPlayer = Rxn();

  //
  //
  // use cases
  final getMessageNotificationsUsecase = sl<GetMessageNotificationsUseCase>();
  final messageMarkAsReadUseCase = sl<MessageMarkAsReadUseCase>();

  //
  // controllers
  final txtSearchController = TextEditingController();
  final refreshController = RefreshController();
  final fileExtensionHelper = FileExtensionHelper();
  final chatVideosThumbnailManager = Get.find<ChatVideosThumbnailManager>();
  final chatDocumentsManager = Get.find<ChatDocumentsManager>();
  final searchDebounce = Debouncer(delay: const Duration(seconds: 1));

  final messagesNotificationsDB = sl<MessagesNotificationsDatabase>();

  //
  //
  // state variables
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isLoadingMore = false.obs;
  bool get isLaodingMore => _isLoadingMore.value;

  final RxBool _errorWhileLoading = false.obs;
  bool get errorWhileLoading => _errorWhileLoading.value;

  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  final Rx<MessageNotificationSearchTypes> selectedSearchType =
      MessageNotificationSearchTypes.oto.obs;

  //
  //
  // onint
  @override
  void onInit() {
    //
    // loading initial data
    loadInitialData();

    //
    // adding search input listener
    txtSearchController.addListener(() {
      searchDebounce.call(() {
        try {
          loadInitialData();
        } catch (_) {}
      });
    });

    selectedSearchType.listen((_) {
      searchDebounce.call(() {
        try {
          loadInitialData();
        } catch (_) {}
      });
    });

    super.onInit();
  }

  ///
  ///
  /// function that will check if next page exist in pagination
  /// it will build param for pagination else build default params
  Map<String, dynamic> _buildPaginationParams() {
    if (currentPagination.value != null) {
      final pagination = currentPagination.value!;

      if (pagination.currentPage != null &&
          pagination.total != null &&
          pagination.perPage != null) {
        //
        // check if have next page then navigate to next page
        final haveNextPage = ((pagination.total! / pagination.perPage!) >
            pagination.currentPage!);
        if (haveNextPage) {
          return {
            "currentPage": pagination.currentPage! + 1,
            "group":
                selectedSearchType.value == MessageNotificationSearchTypes.group
                    ? txtSearchController.text.trim()
                    : "",
            "name":
                selectedSearchType.value == MessageNotificationSearchTypes.oto
                    ? txtSearchController.text.trim()
                    : "",
            "pageSize": 50,
          };
        }
      }
    }
    return {
      "currentPage": 1,
      "group": selectedSearchType.value == MessageNotificationSearchTypes.group
          ? txtSearchController.text.trim()
          : "",
      "name": selectedSearchType.value == MessageNotificationSearchTypes.oto
          ? txtSearchController.text.trim()
          : "",
      "pageSize": 50,
    };
  }

  ///
  ///
  /// function to load initial data
  Future<void> loadInitialData() async {
    _isLoading.value = true;
    _errorWhileLoading.value = false;
    currentPagination.value = null;
    try {
      final response =
          await getMessageNotificationsUsecase.call(_buildPaginationParams());

      response.fold((data) async {
        //
        // clear previous list and process data
        messagesNotifications.clear();
        await _processMessagesNotifications(data.data ?? []);

        //
        // if have pagination then store it
        if (data.pagination != null) {
          currentPagination.value = data.pagination;
        }
      }, (_) {
        _errorWhileLoading.value = true;
      });
    } catch (_) {
      _errorWhileLoading.value = true;
    }
    _isLoading.value = false;
  }

  ///
  ///
  /// function to load the paginated data, it will automatically check
  /// and load next page data
  Future<void> loadPaginatedData() async {
    if (currentPagination.value == null) {
      return;
    }

    final pagination = currentPagination.value!;

    final haveNextPage =
        ((pagination.total! / pagination.perPage!) > pagination.currentPage!);
    if (isLaodingMore || (!haveNextPage)) {
      return;
    }
    _isLoadingMore.value = true;
    try {
      final response =
          await getMessageNotificationsUsecase.call(_buildPaginationParams());

      response.fold((data) async {
        //
        // process data
        await _processMessagesNotifications(data.data ?? []);

        //
        // if have pagination then store it
        if (data.pagination != null) {
          currentPagination.value = data.pagination;
        }
      }, (_) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Something went wrong while loading more notifications.",
        );
      });
    } catch (_) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong while loading more notifications.",
      );
    }
    _isLoadingMore.value = false;
  }

  ///
  ///
  /// function that will handle search controller changes
  void handleSearchChange(String? query) {
    //
  }

  //
  //
  void toggleSearch() {
    _isSearchEnabled.toggle();
  }

  //
  //
  // this convert the duration from seconds to presentable format string
  String formatAudioMessageDuration(int audioDuration) {
    var tick = audioDuration;

    // calculating minutes
    final minutes = tick ~/ 60;

    // removing minutes and getting seconds
    final seconds = tick % 60;
    String duration =
        "${minutes <= 9 ? '0' : ''}$minutes:${seconds <= 9 ? '0' : ''}$seconds";
    return duration;
  }

  ///
  ///
  /// function that will restore the viewed and read states of the notifications
  /// from the offline DB
  Future<void> _processMessagesNotifications(
      List<MessageNotificationEntity> notifications) async {
    if (notifications.isEmpty) {
      return;
    }

    //
    // build the list of the messages ids
    final messageIds = notifications
        .map((item) => item.message?.id)
        .where((item) => item != null)
        .map((item) => item!)
        .toList();

    List<MessagesNotificationsDbModel> dbMessagesNotifications = [];

    //
    // fetch messages notifications states from offline DB
    try {
      dbMessagesNotifications = await messagesNotificationsDB
          .getMessagesNotificationsByMessageIds(messageIds);
    } catch (_) {}

    //
    // if no state found then add messsages notifcations as it is
    if (dbMessagesNotifications.isEmpty) {
      messagesNotifications.addAll(notifications);
    }
    //
    // restore the states and then add to list
    else {
      for (var notification in notifications) {
        // find the message notification from list
        final dbNotification = dbMessagesNotifications.firstWhereOrNull((item) {
          return (notification.message?.id == item.messageId) &&
              (notification.message?.id != null);
        });

        // if notification found then retsore states
        if (dbNotification != null) {
          notification.viewed.value = dbNotification.viewed;
          notification.read.value = dbNotification.read;
        }

        //
        // now add notification to list
        messagesNotifications.add(notification);
      }
    }

    //
    //
    // insert the message in db
    try {
      await messagesNotificationsDB.insertMessagesNotifications(notifications);
    } catch (_) {}
  }

  ///
  ///
  /// funtion will mark message notification as read in list and offline DB
  void markMessageNotificationAsRead(
      MessageNotificationEntity messageNotification) async {
    if (messageNotification.message?.id == null) {
      return;
    }

    try {
      final result = await messageMarkAsReadUseCase
          .call(messageNotification.message!.id!.toString());

      result.fold((readDetails) async {
        if (readDetails.code == 200 && readDetails.error == false) {
          //
          // mark as read in list
          messageNotification.read.value = true;
          messageNotification.viewed.value = true;

          //
          // delete message from offline DB
          await messagesNotificationsDB.deleteMessageNotification(
            messageNotification.message!.id!,
          );

          if ((currentPagination.value?.total ?? 0) > 0) {
            currentPagination.value?.total =
                (currentPagination.value?.total ?? 0) - 1;
          }
        }
      }, (_) {
        // print("/////////// faliure in updating message read status.");
      });
    } catch (_) {
      // print("/////////// faliure in updating message read status.");
    }
  }

  ///
  ///
  /// funtion will delete the messages which are marked as read and
  ///  mark all remaining messages notifications as viewed in list and offline DB
  void markAllMessagesNotificationsAsViewed() async {
    //
    // build ids on the messages that are read by user
    // final messageIds = messagesNotifications
    //     .where((item) => item.read.value)
    //     .map((item) => item.message?.id)
    //     .where((item) => item != null)
    //     .map((item) => item!)
    //     .toList();

    //
    // delete read messages from the list
    messagesNotifications.removeWhere((item) => item.read.value);

    //
    // also delete the read messages from the offline db
    // try {
    //   await messagesNotificationsDB
    //       .deleteMessagesNotificationsByMessagesIds(messageIds);
    // } catch (_) {}

    //
    // mark as viewed in list
    for (var msg in messagesNotifications) {
      msg.viewed.value = true;
    }

    //
    // mark as viewed in offline DB
    try {
      await messagesNotificationsDB.markAllMessagesNotificationsAsViewed();
    } catch (_) {}
  }

  ///
  ///
  /// function that will inser the live notifcations form websocket
  /// into list as well as offline DB
  void insertNewMessageNotification(MessageNotificationEntity message) async {
    //
    // inserting message notification into the offline DB
    try {
      await messagesNotificationsDB.insertMessageNotification(message);
    } catch (_) {}

    //
    // inserting message notification into the list
    try {
      messagesNotifications.insert(
        0,
        message,
      );
    } catch (_) {}
  }

  ///
  ///
  /// function that will removes messages notifications from list and offline DB
  /// that are read by active conversation in chat details
  void removeActiveChatMessageNotifications(int conversationId) async {
    //
    // removing messages related to this conversation from the list
    messagesNotifications.removeWhere(
      (item) =>
          item.message?.conversationId?.toString() == conversationId.toString(),
    );

    //
    // removing messages related to this conversation from the offline DB
    try {
      await messagesNotificationsDB
          .deleteConversationNotifications(conversationId);
    } catch (_) {}
  }

  ///
  ///
  /// function that will check and return the MessageNotificationsController
  /// from the get DI
  static MessageNotificationsController? getController() {
    try {
      if (Get.isRegistered<MessageNotificationsController>()) {
        return Get.find<MessageNotificationsController>();
      }
    } catch (_) {}
    return null;
  }
}

enum MessageNotificationSearchTypes { oto, group }

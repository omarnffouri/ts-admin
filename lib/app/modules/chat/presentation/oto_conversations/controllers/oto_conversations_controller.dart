import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/archive_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/archive_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_all_conversations_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/components/mute_dialog_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/main_screen/controllers/main_screen_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class OtoConversationsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final String myId = GetStorage().read(UserPrefKeys.userId).toString();

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  //
  //
  // getting usecases
  final getAllConversationsUseCase = sl<GetAllConversationsUseCase>();
  final updateConversationStatusUseCase = sl<ArchiveConversationUseCase>();
  final muteConversationUseCase = sl<MuteConversationUseCase>();

  //
  //
  // refresh controllers
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //
  //
  // conversations list
  final RxList<ConversationEntity> conversations = RxList<ConversationEntity>();
  final RxList<ConversationEntity> normalConversations =
      RxList<ConversationEntity>();
  final RxList<ConversationEntity> filteredConversations =
      RxList<ConversationEntity>();
  final RxList<ConversationEntity> archiveConversations =
      RxList<ConversationEntity>();

  /////////////////////////////////////// state variables /////////////////////

  //
  //
  // one to one conversations loading state
  final RxBool _isLoadingConversations = false.obs;
  bool get isLoadingConversations => _isLoadingConversations.value;

  //updating conversation status state
  final RxBool _isUpdatingConversationStatus = false.obs;
  bool get isUpdatingConversationStatus => _isUpdatingConversationStatus.value;

  // conversations from database loading state
  final RxBool _isLoadingConversationsFromDatabase = false.obs;
  bool get isLoadingConversationsFromDatabase =>
      _isLoadingConversationsFromDatabase.value;

  // conversations list empty from database
  final RxBool _isConversationsListEmptyFromDatabase = false.obs;
  bool get isConversationsListEmptyFromDatabase =>
      _isConversationsListEmptyFromDatabase.value;

  //updating conversation status state
  final RxBool _isMutingConversation = false.obs;
  bool get isMutingConversation => _isMutingConversation.value;

  final RxBool isSearchEnabled = false.obs;
  final RxBool isViewingArchivedChats = false.obs;

  final conversationsDatabase = sl<ConversationsDatabase>();

  final RxInt otoUnreadCounts = 0.obs;
  final RxInt mutingAtIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    // getting conversations
    loadConversationsFromDatabase();
    // adding listener so check if search text is empty then load full list else apply search

    conversations.listen((p0) {
      updateChatUnreadCountsForDependencies();
    });
  }

  loadConversationsFromDatabase() async {
    conversations.clear();
    try {
      _isLoadingConversationsFromDatabase(true);
      conversations.addAll(await conversationsDatabase.getAllConversations());
      _isLoadingConversationsFromDatabase(false);
      if (conversations.isEmpty) {
        _isConversationsListEmptyFromDatabase(true);
      }
    } catch (_) {
      _isLoadingConversationsFromDatabase(false);
    }
    _refreshArchivedChats();
    getAllConversations();
  }

  moveConversationOnTop(
      int conversationId, ConversationLastMessageEntity lastMessage,
      {bool incrementUnread = false}) {
    int? conversationIndex;

    // finding item and updating unread count and last seen time in conversations list
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == conversationId) {
        conversations[i].dateTimeInHumans = "1 second ago";
        if (incrementUnread) {
          conversations[i].unreadCount =
              ((conversations[i].unreadCount ?? 0) + 1);
        }
        conversations[i].message = lastMessage;
        conversationIndex = i;
        if (i == 0) {
          conversations.refresh();
        }
        break;
      }
    }

    // checking if conversation is found in conversations list then move that index item to 0 index
    if (conversationIndex != null) {
      if (conversationIndex > 0 && conversationIndex < conversations.length) {
        final itemToMove = conversations[conversationIndex];
        conversations.removeAt(conversationIndex);
        conversations.insert(0, itemToMove);
      }
    }

    _refreshArchivedChats();
  }

  onMessageDelete(int conversationId, int messageId) {
    int? conversationIndex;

    // finding item and updating deleted_at and last seen time in conversations list
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == conversationId) {
        if (conversations[i].message?.id == messageId) {
          conversations[i].dateTimeInHumans = "1 second ago";
          conversations[i].message?.deletedAt = DateTime.now();
          conversationIndex = i;
          if (i == 0) {
            conversations.refresh();
          }
        }
        break;
      }
    }

    // checking if conversation is found in conversations list then move that index item to 0 index
    if (conversationIndex != null) {
      if (conversationIndex > 0 && conversationIndex < conversations.length) {
        final itemToMove = conversations[conversationIndex];
        conversations.removeAt(conversationIndex);
        conversations.insert(0, itemToMove);
      }
    }

    _refreshArchivedChats();
  }

  setConversationUnreadCountToZero(int conversationId) {
    // finding item and updating unread count and last seen time in conversations list
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == conversationId) {
        conversations[i].unreadCount = 0;
        conversations.refresh();
        break;
      }
    }
    _refreshArchivedChats();
  }

  _refreshArchivedChats() {
    //
    archiveConversations.clear();
    normalConversations.clear();
    archiveConversations
        .addAll(conversations.where((p0) => p0.status == "archive"));
    normalConversations
        .addAll(conversations.where((p0) => p0.status != "archive"));
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

    filteredConversations.clear();
    filteredConversations.addAll(conversations.where((item) {
      final phone =
          item.user?.phone?.toLowerCase().contains(query.toLowerCase()) ??
              false;
      final name =
          item.user?.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return phone || name;
    }));
  }

  //
  //
  //
  void moveConversationToArchive(ConversationEntity conversation) async {
    try {
      final result = await updateConversationStatus(ArchiveConversationParams(
          conversationId: conversation.id?.toString() ?? "", type: 'archive'));
      if (result) {
        conversation.status = 'archive';
        normalConversations.remove(conversation);
        archiveConversations.add(conversation);
        archiveConversations.sort((a, b) =>
            (b.lastMessagedAt ?? 0).compareTo((a.lastMessagedAt ?? 0)));
      }
    } catch (_) {}
  }

  //
  //
  //
  void removeConversationFromArchive(ConversationEntity conversation) async {
    try {
      final result = await updateConversationStatus(ArchiveConversationParams(
          conversationId: conversation.id?.toString() ?? "", type: 'normal'));
      if (result) {
        conversation.status = 'normal';
        normalConversations.add(conversation);
        archiveConversations.remove(conversation);
        normalConversations.sort((a, b) =>
            (b.lastMessagedAt ?? 0).compareTo((a.lastMessagedAt ?? 0)));
      }
    } catch (_) {}
  }

  //
  //
  /// This mute the conversation, hit api and also sync in local DB
  void unmuteConversation(ConversationEntity conversation, int index) async {
    if (conversation.id == null || isMutingConversation) {
      return;
    }

    _isMutingConversation.value = true;
    mutingAtIndex.value = index;

    try {
      final result = await _updateConversationMuteState(
        MuteConversationParams(
          muteDuration: null,
          conversations: [conversation.id!],
        ),
      );
      if (result) {
        conversation.notificationMuted = false;
        conversations.refresh();
        normalConversations.refresh();
        archiveConversations.refresh();

        //
        //
        // also update in local DB
        try {
          _updateConversationInDB(conversation);
        } catch (_) {}
      }
    } catch (_) {}

    _isMutingConversation.value = false;
    mutingAtIndex.value = (-1);
  }

  void muteConversation(ConversationEntity conversation, int index) {
    Get.dialog(
      MuteDialogView(
        onDurationSelection: (muteDuration) {
          _muteConversation(conversation, muteDuration, index);
        },
        onCancle: () {
          //
        },
      ),
    );
  }

  //
  //
  /// This mute the conversation, hit api and also sync in local DB
  void _muteConversation(
      ConversationEntity conversation, String muteDuration, int index) async {
    if (conversation.id == null || isMutingConversation) {
      return;
    }

    _isMutingConversation.value = true;
    mutingAtIndex.value = index;

    try {
      final result = await _updateConversationMuteState(
        MuteConversationParams(
          muteDuration: muteDuration,
          conversations: [conversation.id!],
        ),
      );
      if (result) {
        conversation.notificationMuted = true;
        conversations.refresh();
        normalConversations.refresh();
        archiveConversations.refresh();

        //
        //
        // also update in local DB
        try {
          _updateConversationInDB(conversation);
        } catch (_) {}
      }
    } catch (_) {}

    _isMutingConversation.value = false;
    mutingAtIndex.value = (-1);
  }

//
//
  /// This will update the conversation in local DB passed in params
  _updateConversationInDB(ConversationEntity conversation) async {
    try {
      await conversationsDatabase.updateConversation(conversation);
    } catch (_) {}
  }

  //
  //
  // make conversation mute and unmute usecase
  Future<bool> _updateConversationMuteState(
      MuteConversationParams params) async {
    try {
      _isMutingConversation(true);
      final result = await muteConversationUseCase.call(params);

      _isMutingConversation(false);

      bool done = false;

      result.fold((BaseResponse<bool> data) {
        //
        //
        done = (data.code == 200);
        //
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        done = false;
      });

      return done;
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isMutingConversation(false);
      return false;
    }
  }

  //
  //
  //
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    isSearchEnabled(false);
    filteredConversations.clear();
    filteredConversations.addAll(conversations);
  }

  //
  //
  // make conversation archive and normal usecase usecase
  Future<bool> updateConversationStatus(
      ArchiveConversationParams params) async {
    try {
      _isUpdatingConversationStatus(true);
      final Either<ArchiveConversationEntity, Failure> result =
          await updateConversationStatusUseCase.call(params);

      _isUpdatingConversationStatus(false);

      bool done = false;

      result.fold((ArchiveConversationEntity archiveConversation) {
        //
        //
        done = (!(archiveConversation.error ?? true));
        //
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        done = false;
      });

      return done;
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isUpdatingConversationStatus(false);
      return false;
    }
  }

  //
  //
  // loading all one to one conversations from api using conversations usecase
  Future<void> getAllConversations() async {
    try {
      _isLoadingConversations(true);
      final Either<List<ConversationEntity>, Failure> result =
          await getAllConversationsUseCase.call(const NoParams());

      _isLoadingConversations(false);

      result.fold((List<ConversationEntity> conversationsFromRemote) async {
        conversations.clear();

        conversations.value = conversationsFromRemote;
        _refreshArchivedChats();

        // syncing with offline database
        try {
          await conversationsDatabase.deleteAllConversation();
          await conversationsDatabase.insertConversations(conversations);
        } catch (_) {}
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
      _isLoadingConversations(false);
    }
  }

  //
  //
  //
  String getCallText(
      int? callPlacedBy, String conversationType, String event, int? duration) {
    //
    if (conversationType == "group") {
      //
      return "group call";
    } else {
      //
      switch (event) {
        //
        // event the call status is not updated
        case AgoraCallEvents.incommingCall:
          return "Missed.";
        //
        // event the call is declined
        case AgoraCallEvents.callDeclined:
          return "Declined.";
        //
        // event the call is not answered
        case AgoraCallEvents.noAnswer:
          return "Not Answered.";
        //
        // event the call is not answered
        case AgoraCallEvents.callEnded:
          return duration != null ? _formatDuration(duration) : "";

        default:
          return "Missed.";
      }
    }
  }

  //
  //
  //
  String _formatDuration(int totalTicks) {
    var tick = totalTicks;
    // // calculating days from tick
    // days.value = tick ~/ (24 * 3600);

    // // subracting days from the tick
    // tick = tick % (24 * 3600);

    // calculating hours
    final hours = tick ~/ 3600;

    // subracting hours from tick
    tick = tick % 3600;

    // calculating minutes
    final minutes = tick ~/ 60;

    // removing minutes and getting seconds
    final seconds = tick % 60;
    String duration =
        "${hours <= 9 ? '0' : ''}$hours-${minutes <= 9 ? '0' : ''}$minutes-${seconds <= 9 ? '0' : ''}$seconds";
    return duration;
  }

  //
  //
  //
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

  //
  //
  //
  updateChatUnreadCountsForDependencies() {
    otoUnreadCounts.value = conversations.isEmpty
        ? 0
        : conversations
            .map((e) => e.unreadCount ?? 0)
            .reduce((value, e) => value + e);

    try {
      Get.find<MainScreenController>().updateUnreadMessageCounts();
    } catch (_) {}
    try {
      Get.find<ConversationsController>().updateOtoUnreadCounts();
    } catch (_) {}
  }
}

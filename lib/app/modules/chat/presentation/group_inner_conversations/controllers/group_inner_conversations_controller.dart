import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/controllers/call_events_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/on_going_call_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/archive_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/archive_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/components/mute_dialog_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/native_calling/channels/native_calling_method_channel.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:uuid/uuid.dart';

class GroupInnerConversationsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  TextEditingController searchTextController = TextEditingController();

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  final updateConversationStatusUseCase = sl<ArchiveConversationUseCase>();
  final muteConversationUseCase = sl<MuteConversationUseCase>();

  final RxnInt groupId = RxnInt();
  final RxString groupName = ''.obs;
  final RxString groupLogo = ''.obs;

  final RxList<GroupConversationConversationEntity> archivedConversations =
      RxList<GroupConversationConversationEntity>();

  final RxList<GroupConversationConversationEntity>
      filteredArchivedConversations =
      RxList<GroupConversationConversationEntity>();

  final RxList<GroupConversationConversationEntity> unarchivedConversations =
      RxList<GroupConversationConversationEntity>();

  final RxList<GroupConversationConversationEntity>
      filteredUnarchivedConversations =
      RxList<GroupConversationConversationEntity>();

  //updating conversation status state
  final RxBool _isUpdatingConversationStatus = false.obs;
  bool get isUpdatingConversationStatus => _isUpdatingConversationStatus.value;

  final RxBool _isViewingArchiveConversations = false.obs;
  bool get isViewingArchiveConversations =>
      _isViewingArchiveConversations.value;

  //updating conversation status state
  final RxBool _isMutingConversation = false.obs;
  bool get isMutingConversation => _isMutingConversation.value;

  //
  // state variables
  final RxBool _searchEnabled = false.obs;
  bool get searchEnabled => _searchEnabled.value;
  final RxInt mutingAtIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    loadGroupDetails();

    searchTextController.addListener(() {
      if (searchTextController.text.isNotEmpty) {
        _applySearch();
      }
    });
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
  // function will fetch group details and
  // load details in the reactive variables
  GroupConversationEntity? loadGroupDetails() {
    try {
      final group = _getGroup();

      if (group == null) {
        return null;
      }

      if ((group.conversations ?? []).isNotEmpty) {
        _loadConversationsLists(group.conversations!);
      }

      if (group.name != null) {
        groupName.value = group.name!;
      }

      if (group.groupSettings?.logo != null) {
        groupLogo.value = group.groupSettings!.logo!;
      }
      return group;
    } catch (_) {
      return null;
    }
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
  // function will filter teh archived and unarchived conversations
  // and load initial data in the all conversations lists
  _loadConversationsLists(
      List<GroupConversationConversationEntity> conversations) {
    archivedConversations.clear();
    filteredArchivedConversations.clear();
    unarchivedConversations.clear();
    filteredUnarchivedConversations.clear();

    //
    // filtering archived and unarchived conversation
    archivedConversations.addAll(conversations
        .where((item) => item.status == "archive" || item.chatAble == false));
    unarchivedConversations.addAll(conversations
        .where((item) => item.status == "normal" && item.chatAble == true));

    //
    // setting initail data for the archived and unarchived filtered lists
    filteredArchivedConversations.addAll(archivedConversations);
    filteredUnarchivedConversations.addAll(unarchivedConversations);
  }

  //
  //
  //  function that process the event names to presentable status
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
  // convert total seconds or ticks to hh:mm:ss format to present
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

  //
  //
  // removing conversation frm archive and making api
  void removeConversationFromArchiveInGroup(
      GroupConversationConversationEntity innerConversation) async {
    final result = await _updateConversationStatus(ArchiveConversationParams(
        conversationId: innerConversation.id?.toString() ?? "",
        type: 'normal'));
    if (result) {
      innerConversation.status = 'normal';
      archivedConversations.remove(innerConversation);
      filteredArchivedConversations.remove(innerConversation);
      unarchivedConversations.add(innerConversation);
      filteredUnarchivedConversations.add(innerConversation);
      _updateConverstionStatusInMainGroup(innerConversation.id, 'normal');
    }
  }

  //
  //
  // moving conversation to archive and making api
  void moveConversationToArchiveInGroup(
      GroupConversationConversationEntity innerConversation) async {
    final result = await _updateConversationStatus(ArchiveConversationParams(
        conversationId: innerConversation.id?.toString() ?? "",
        type: 'archive'));
    if (result) {
      innerConversation.status = 'archive';
      unarchivedConversations.remove(innerConversation);
      filteredUnarchivedConversations.remove(innerConversation);
      archivedConversations.add(innerConversation);
      filteredArchivedConversations.add(innerConversation);
      _updateConverstionStatusInMainGroup(innerConversation.id, 'archive');
    }
  }

  //
  //
  // make conversation archive and normal usecase api call
  Future<bool> _updateConversationStatus(
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

  RxList<GroupConversationConversationEntity> getConversationsList() {
    return isViewingArchiveConversations
        ? searchEnabled
            ? filteredArchivedConversations
            : archivedConversations
        : searchEnabled
            ? filteredUnarchivedConversations
            : unarchivedConversations;
  }

  //
  //
  // function will update data on the main group conversations controller
  void _updateConverstionStatusInMainGroup(int? conversationId, String status) {
    if (conversationId == null) {
      return;
    }
    if (status.isEmpty) {
      return;
    }

    final id = getGroupId();

    if (id == null) {
      return;
    }

    try {
      if (Get.isRegistered<GroupConversationsController>()) {
        Get.find<GroupConversationsController>()
            .updateInnerConversationStatus(id, conversationId, status);
      }
    } catch (_) {}
  }

  //
  //
  // toggle search which enable disable search bar
  void toggleSearch() {
    _searchEnabled.toggle();
  }

  //
  //
  // toggle archive which will switch between archived and unarchived list
  void toggleArchive() {
    _isViewingArchiveConversations.toggle();
  }

  openGroupSettings() {
    final id = getGroupId();
    Get.toNamed(Routes.GROUP_SETTINGS, arguments: id);
  }

  //
  //
  // this function will apply search on the archived and unarchived inner conversations
  void _applySearch() {
    filteredArchivedConversations.clear();
    filteredUnarchivedConversations.clear();
    if (searchTextController.text.isEmpty) {
      //
      // resetting archived and unarchived search filtered list
      filteredArchivedConversations.addAll(archivedConversations);
      filteredUnarchivedConversations.addAll(unarchivedConversations);
    } else {
      //
      // filtering archived concersations
      filteredArchivedConversations.addAll(
        archivedConversations.where(
          (item) {
            final name = item.name?.toLowerCase().contains(
                    searchTextController.text.toString().toLowerCase()) ??
                false;
            return name;
          },
        ),
      );

      //
      // filtering unarchived concersations
      filteredUnarchivedConversations.addAll(
        unarchivedConversations.where(
          (item) {
            final name = item.name?.toLowerCase().contains(
                    searchTextController.text.toString().toLowerCase()) ??
                false;
            return name;
          },
        ),
      );
    }
  }

  //
  //
  // function to clear the search and reset states of archived and unarchived
  //inner conversation
  void clearSearch() {
    _searchEnabled(false);
    searchTextController.clear();

    // clearing filters list
    filteredArchivedConversations.clear();
    filteredUnarchivedConversations.clear();

    // adding default data for the list
    filteredArchivedConversations.addAll(archivedConversations);
    filteredUnarchivedConversations.addAll(unarchivedConversations);

    //
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //
  //
  /// This function will sort and refresh the conversations list
  void onNewMessage(String? groupName, int conversationId,
      GroupLastMessageEntity lastMessage) {
    if (groupName != this.groupName.value) {
      return;
    }

    _sortList(unarchivedConversations);
    _sortList(filteredUnarchivedConversations);
    _sortList(archivedConversations);
    _sortList(filteredArchivedConversations);
  }

  //
  //
  /// This function will sort and refresh the conversations list
  void onMessageDelete(String? groupName, int conversationId, int messageId) {
    if (groupName != this.groupName.value) {
      return;
    }

    _sortList(unarchivedConversations);
    _sortList(filteredUnarchivedConversations);
    _sortList(archivedConversations);
    _sortList(filteredArchivedConversations);
  }

  ///
  ///
  /// This function will sort list passed in params
  _sortList(RxList<GroupConversationConversationEntity> list) {
    list.sort((a, b) {
      DateTime? aDate = a.message?.updatedAt ?? a.message?.createdAt;
      DateTime? bDate = b.message?.createdAt ?? b.message?.createdAt;

      if (aDate == null && bDate != null) {
        return 1;
      } else if (bDate == null && aDate != null) {
        return -1;
      } else if (bDate == null && aDate == null) {
        return 0;
      } else {
        return bDate!.compareTo(aDate!);
      }
    });
    list.refresh();
  }

  //
  //
  /// This function will sort and refresh the conversations list
  void resetUnreadCount(String groupName, int conversationId) {
    if (groupName != this.groupName.value) {
      return;
    }

    _sortList(unarchivedConversations);
    _sortList(filteredUnarchivedConversations);
    _sortList(archivedConversations);
    _sortList(filteredArchivedConversations);
  }

  ///
  ///
  /// This function will update the group name in view
  void groupNameUpdated(int groupId, String newName) {
    final id = getGroupId();

    if (id == null) {
      return;
    }
    if (groupId == id) {
      groupName.value = newName;
    }
  }

  ///
  ///
  /// This function will update the group logo in view
  void groupLogoUpdated(int groupId, String logo) {
    final id = getGroupId();

    if (id == null) {
      return;
    }
    if (groupId == id) {
      groupLogo.value = logo;
    }
  }

  void onParticipantRemoved(int groupId) {
    final id = getGroupId();

    if (id == null) {
      return;
    }
    if (groupId != id) {
      return;
    }
    loadGroupDetails();
  }

  bool iAmAdmin() {
    final group = _getGroup();
    if (group == null) {
      return false;
    }
    if ((group.conversations ?? []).isEmpty) {
      return false;
    }

    bool iAmAdmin = false;

    if ((group.conversations ?? []).isNotEmpty) {
      for (var item in group.conversations!) {
        //
        // participants list empty means i am not in participanst
        if ((item.participants ?? []).isEmpty) {
          break;
        }

        //
        // find current user in participants
        final participant = item.participants!.firstWhereOrNull((participant) =>
            ((participant.id?.toString() ==
                    authController.user.value?.id?.toString()) &&
                (authController.user.value?.id != null)) &&
            (participant.modelType == ModelType.USERS));

        if (participant != null) {
          iAmAdmin = participant.isGroupAdmin ?? false;
        }
      }
    }

    return iAmAdmin;
  }

  void onParticipantPermissionsUpdated(int groupId) {
    final id = getGroupId();

    if (id == null) {
      return;
    }
    if (groupId != id) {
      return;
    }
    loadGroupDetails();
  }

  //
  //
  /// This mute the conversation, hit api and also sync in local DB
  void unmuteConversation(
      GroupConversationConversationEntity conversation, int index) async {
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
        archivedConversations.refresh();
        filteredArchivedConversations.refresh();
        unarchivedConversations.refresh();
        filteredUnarchivedConversations.refresh();

        //
        //
        // also notify main group
        try {
          final id = getGroupId();

          if (Get.isRegistered<GroupConversationsController>() && id != null) {
            Get.find<GroupConversationsController>()
                .onConversationMuteStateChange(
              id,
              conversation.id!,
              false,
            );
          }
        } catch (_) {}
      }
    } catch (_) {}

    _isMutingConversation.value = false;
    mutingAtIndex.value = (-1);
  }

  void muteConversation(
      GroupConversationConversationEntity conversation, int index) {
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
  void _muteConversation(GroupConversationConversationEntity conversation,
      String muteDuration, int index) async {
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
        archivedConversations.refresh();
        filteredArchivedConversations.refresh();
        unarchivedConversations.refresh();
        filteredUnarchivedConversations.refresh();

        //
        //
        // also notify main group
        try {
          final id = getGroupId();
          if (Get.isRegistered<GroupConversationsController>() && id != null) {
            Get.find<GroupConversationsController>()
                .onConversationMuteStateChange(
              id,
              conversation.id!,
              true,
            );
          }
        } catch (_) {}
      }
    } catch (_) {}

    _isMutingConversation.value = false;
    mutingAtIndex.value = (-1);
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

  Future<void> joinOngoingCall(
      OngoingCallEntity ongoingCall, String receiverName,
      {int? conversationId}) async {
    final isVideoCall = ongoingCall.callType == "video";
    if (!(await hasEnoughPermissions(isVideoCall))) {
      Get.snackbar(
          'Permissions Required',
          isVideoCall
              ? 'In order to join a video call, please grant camera and microphone permissions.'
              : 'In order to join a call, please grant microphone permission.');
      return;
    }

    //
    // check can we start call in native layer
    if (!(await NativeCallingMethodChannel.canStartCall())) {
      // if user try to join ongoing call, but already in that call in native layer
      // then just open call UI
      try {
        final currentCall = Get.find<CallEventsController>().currentCall.value;
        if (currentCall != null) {
          if (currentCall.conversationId == conversationId &&
              conversationId != null &&
              currentCall.tempCallId != null) {
            await NativeCallingMethodChannel.openNativeCallUI(
              currentCall.tempCallId!,
            );
            return;
          }
        }
      } catch (_) {}
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "You can't start a call. When one call is already in process.",
      );
      return;
    }

    if (Platform.isAndroid) {
      if ((await Permission.phone.request()) != PermissionStatus.granted) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message:
              "Please first grant phone access in settings, in order to place call.",
        );
      }
    }

    final notificationPayload = {
      'channelName':
          'call-conversation-${ongoingCall.conversationId ?? conversationId}',
      'conversationId': ongoingCall.conversationId ?? conversationId,
      'callType': ongoingCall.callType,
      'caller_id': ongoingCall.modelId,
      'conversationType': "group",
      'caller_model_type': ongoingCall.modelType,
      'caller_name': groupName.value == receiverName
          ? groupName.value
          : "${groupName.value}($receiverName)",
      'caller_image': groupLogo.value,
      'call_placed_at': DateTime.now().toUtc().millisecondsSinceEpoch,
      'temp_call_id': const Uuid().v4(),
      'incomming_declined': false,
      'messageId': ongoingCall.id,
      'receiverName': receiverName,
    };

    final result =
        await NativeCallingMethodChannel.joingOngoingCall(notificationPayload);

    debugPrint("result from placing native call is ===> $result");
  }

  Future<bool> hasEnoughPermissions(bool isVideoCall) async {
    // Microphone is required for every call type.
    bool micStatus = await PermissionHelper.haveMicPermission(
        "Grant microphone permission in settings to make a call.");

    if (!micStatus) {
      return false;
    }

    // Camera is only required for video calls.
    if (isVideoCall) {
      bool cameraStatus = await PermissionHelper.haveCameraPermission(
          "Grant camera permission in settings to make a video call.");

      return cameraStatus;
    }

    return true;
  }
}

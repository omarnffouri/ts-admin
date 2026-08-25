import 'dart:async';
import 'dart:convert';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/chat/data/models/on_going_call_model.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/group_conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_heads_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_conversatiosn_details_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/components/mute_dialog_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_inner_conversations/controllers/group_inner_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';
import 'package:ts_admin/app/modules/main_screen/controllers/main_screen_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class GroupConversationsController extends GetxController {
  final Rx<GroupCreationStates> groupCreationState =
      GroupCreationStates.selectAdmins.obs;

  final AuthController authController = Get.find<AuthController>();

  final String myId = GetStorage().read(UserPrefKeys.userId).toString();

  // getting usecases
  final getGroupHeadsUseCase = sl<GetGroupHeadsUseCase>();
  final getGroupConversationDetailsUseCase =
      sl<GetGroupConversationDetailsUseCase>();
  final getGroupContactsUseCase = sl<GetGroupContactsUseCase>();
  final muteConversationUseCase = sl<MuteConversationUseCase>();

  StreamSubscription<ChannelReadEvent>? agoraCallEndSubscription;
  StreamSubscription<ChannelReadEvent>? ongoingCallEventSubscription;
  StreamSubscription<ChannelReadEvent>? callAcceptedWhisperSubscription;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // getting pusher manager
  final pusher = sl<PusherManager>();

  // group conversations lists
  final RxList<GroupConversationEntity> groupConversations =
      RxList<GroupConversationEntity>();
  final RxList<GroupConversationEntity> filteredGroupConversations =
      RxList<GroupConversationEntity>();

  //
  //
  // contacts lists
  final Rxn<GroupContactsEntity> groupContacts = Rxn();

  // group conversations loading state
  final RxBool _isLoadingGroupHeads = false.obs;
  bool get isLoadingGroupHeads => _isLoadingGroupHeads.value;

  // group conversations from database loading state
  final RxBool _isLoadingGroupConversationsFromDatabase = false.obs;
  bool get isLoadingGroupConversationsFromDatabase =>
      _isLoadingGroupConversationsFromDatabase.value;

  // group conversations list empty from database
  final RxBool _isGroupConversationsListEmptyFromDatabase = false.obs;
  bool get isGroupConversationsListEmptyFromDatabase =>
      _isGroupConversationsListEmptyFromDatabase.value;

  //group contacts loading state
  final RxBool _isLoadingGroupContacts = false.obs;
  bool get isLoadingGroupContacts => _isLoadingGroupContacts.value;

  //mute conversation  state
  final RxBool _isMutingConversation = false.obs;
  bool get isMutingConversation => _isMutingConversation.value;

  final RxBool isSearchEnabled = false.obs;
  final RxBool isInnerSearchEnabled = false.obs;

  final RxInt groupUnreadCounts = 0.obs;

  final RxInt mutingAtIndex = (-1).obs;

  final groupConversationsDatabase = sl<GroupConversationsDatabase>();

  @override
  void onInit() {
    super.onInit();

    //
    loadGroupConversationsFromDatabase();
    getGroupContacts();
    _subscribeForCallChannelEvents();

    groupConversations.listen((p0) {
      updateChatUnreadCountsForDependencies();
    });
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ////////////////////// Api call or data loader functions /////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  // loading group contacts from api using contacts usecase
  Future<void> getGroupContacts() async {
    if (!(authController.userPermissionHelper.canCreateGroup())) {
      return;
    }
    try {
      _isLoadingGroupContacts(true);
      final Either<GroupContactsEntity, Failure> result =
          await getGroupContactsUseCase.call(const NoParams());

      _isLoadingGroupContacts(false);

      result.fold((GroupContactsEntity contactsFromRemote) {
        groupContacts.value = contactsFromRemote;
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

  //
  //
  // loading group conversation from the local db
  loadGroupConversationsFromDatabase() async {
    groupConversations.clear();
    try {
      _isLoadingGroupConversationsFromDatabase(true);
      final cons = await groupConversationsDatabase.getAllGroups();
      groupConversations.addAll(cons);
      _isLoadingGroupConversationsFromDatabase(false);
      if (groupConversations.isEmpty) {
        _isGroupConversationsListEmptyFromDatabase(true);
      }

      _sortGroupConversations();
    } catch (_) {
      _isGroupConversationsListEmptyFromDatabase(true);
      _isLoadingGroupConversationsFromDatabase(false);
    }
    await getGroupHeads();
  }

  //
  //
  // loading all group conversation from api using group conversations usecase
  Future<void> getGroupHeads() async {
    try {
      _isLoadingGroupHeads(true);
      final Either<List<GroupConversationEntity>, Failure> result =
          await getGroupHeadsUseCase.call(const NoParams());

      _isLoadingGroupHeads(false);

      result.fold((List<GroupConversationEntity> groupHeadsFromRemote) async {
        //
        // removing alreted groups from list and local db
        try {
          await _removeChangedAndDeletedGroups(groupHeadsFromRemote);
        } catch (_) {}
        //
        // syncing group inner conversations and group settings with the local db
        for (var groupHead in groupHeadsFromRemote) {
          bool found = false;
          for (var group in groupConversations) {
            group.isLoadingSubGroups(true);
            if (groupHead.id == group.id) {
              group.conversationsCount = groupHead.conversationsCount;
              group.name = groupHead.name;
              group.groupSettings = groupHead.groupSettings;
              found = true;
              break;
            }
          }
          if (!found) {
            //
            // making conversations list null is important.
            // don't remove this statement
            groupHead.conversations = null;
            groupConversations.add(groupHead);
          }
        }

        //
        _sortGroupConversations();
        groupConversations.refresh();
        _syncHeadsWithDatabaseAndProceed();

        //
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
      _isLoadingGroupHeads(false);
    }
  }

  //
  //
  // get sub groups of the group head
  Future<GroupConversationEntity?> _getGroupConversationDetails(int id) async {
    try {
      final response = await getGroupConversationDetailsUseCase.call(id);
      GroupConversationEntity? data;
      response.fold((l) {
        data = l;
      }, (r) {});
      return data;
    } catch (e) {
      debugPrint(
          "Got exception while getting group conversation details ===> $e");
      return null;
    }
  }

  ///
  ///
  /// update inner conversation status and also sync in the DB.
  updateInnerConversationStatus(
      int groupId, int? conversationId, String status) async {
    if (conversationId == null) {
      return;
    }
    if (status.isEmpty) {
      return;
    }
    GroupConversationEntity? groupDetails;
    try {
      for (var group in groupConversations) {
        if (group.id == groupId) {
          if ((group.conversations ?? []).isNotEmpty) {
            for (var conversation in group.conversations!) {
              if (conversation.id == conversationId) {
                conversation.status = status;
                groupDetails = group;
                break;
              }
            }
          }
          break;
        }
      }
    } catch (_) {}

    // syncing sub groups to database
    if (groupDetails != null) {
      try {
        //
        await groupConversationsDatabase.updateGroup(groupId, groupDetails);
      } catch (e) {
        //
        debugPrint(
            "Got exception while syncing group on converstion status update ===> $e");
      }
    }
  }

  //
  //
  // function handle the null conversations or refeshing the group details
  refreshGroupDetails(int groupId) async {
    final group =
        groupConversations.firstWhereOrNull((element) => element.id == groupId);

    if (group == null) {
      return;
    }

    group.isLoadingSubGroups(true);
    groupConversations.refresh();

    try {
      final groupDetails = await _getGroupConversationDetails(groupId);
      if (groupDetails != null) {
        group.name = groupDetails.name;
        group.conversations = groupDetails.conversations;
        group.conversationsCount = groupDetails.conversationsCount;
        group.groupSettings = groupDetails.groupSettings;
        group.unreadCount = groupDetails.unreadCount;

        // sync with local database
        try {
          groupDetails.isLoadingSubGroups(false);
          await groupConversationsDatabase.updateGroup(groupId, groupDetails);
        } catch (_) {}

        //
        // also notify inner group converstions module if that module is active
        if (Get.isRegistered<GroupInnerConversationsController>()) {
          Get.find<GroupInnerConversationsController>().loadGroupDetails();
        }

        //
        // also notify group settings module if that module is active
        if (Get.isRegistered<GroupSettingsController>()) {
          Get.find<GroupSettingsController>().loadGroupDetails();
        }
      }
    } catch (_) {}
    group.isLoadingSubGroups(false);
    groupConversations.refresh();
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  /////////////////////// Search on groups related  functions //////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  // search by group name
  void applySearch(String query) {
    if (query.isEmpty) {
      clearSearch();
      return;
    }
    final searchQuery = query.toLowerCase();

    isSearchEnabled(true);
    filteredGroupConversations.clear();
    filteredGroupConversations.addAll(groupConversations.where((group) {
      //
      // check if group name conatins search query
      final nameCheck =
          group.name?.toLowerCase().contains(searchQuery) ?? false;

      if (nameCheck) {
        return true;
      }
      //
      // check if any participant name in any conversation contains search query
      final conversation =
          group.conversations?.firstWhereOrNull((conversation) {
        //
        // check if any participant name contains search query
        final participan =
            conversation.participants?.firstWhereOrNull((participant) {
          return participant.name?.toLowerCase().contains(searchQuery) ?? false;
        });

        return participan != null;
      });

      return conversation != null;
    }));
  }

  //
  //
  // clear the groups search state
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    isSearchEnabled(false);
    filteredGroupConversations.clear();
    filteredGroupConversations.addAll(groupConversations);
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  /////////////////// Syncing and Database related functions ///////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  // removing the changed or name updated groups etc
  _removeChangedAndDeletedGroups(List<GroupConversationEntity> groups) async {
    List<int> groupsToDelete = [];
    groupConversations.removeWhere((element) {
      //
      // checking that current index group exist in new groups list or not
      final groupNotExist = (groups.firstWhereOrNull(
              (e) => (e.id == element.id) && (e.id != null)) ==
          null);

      if (groupNotExist) {
        groupsToDelete.add(element.id!);
      }

      return groupNotExist;
    });

    if (groupsToDelete.isEmpty) {
      return;
    }

    try {
      //
      // deleteing altered records
      await groupConversationsDatabase.deleteGroups(groupsToDelete);
    } catch (_) {}
    return;
  }

  //
  //
  // syncing group heads with db and then process inner convresations
  _syncHeadsWithDatabaseAndProceed() async {
    // storing and updating the group heads
    try {
      await groupConversationsDatabase
          .insertGroupConversations(groupConversations);
    } catch (_) {}

    for (var groupHead in groupConversations) {
      if (groupHead.id != null && authController.isAuthenticated) {
        final groupDetails = await _getGroupConversationDetails(groupHead.id!);

        if (groupDetails != null) {
          groupHead.isLoadingSubGroups(false);
          groupHead.name = groupDetails.name;
          groupHead.conversations = groupDetails.conversations;
          groupHead.conversationsCount = groupDetails.conversationsCount;
          groupHead.unreadCount = groupDetails.unreadCount;
          groupHead.groupSettings = groupDetails.groupSettings;
          groupConversations.refresh();

          // syncing sub groups to database
          try {
            //
            await groupConversationsDatabase.updateGroup(
              groupHead.id!,
              groupDetails,
            );
          } catch (e) {
            //
            debugPrint("Got exception while syncing sub groups ===> $e");
          }
        }
      }
    }
  }

  //
  //
  // function to add group to list and also add to local database
  addGroupAndSyncWithDatabase(GroupConversationEntity? data) async {
    //
    if (data == null) {
      return;
    }

    groupConversations.add(data);
    groupConversations.refresh();

    try {
      if (data.id != null) {
        final group = await _getGroupConversationDetails(data.id!);
        if (group != null) {
          final foundGroup = groupConversations
              .firstWhereOrNull((element) => element.id == data.id);

          if (foundGroup != null) {
            foundGroup.isLoadingSubGroups(false);
            foundGroup.name = group.name;
            foundGroup.unreadCount = group.unreadCount;
            foundGroup.conversations = group.conversations;
            foundGroup.conversationsCount = group.conversationsCount;
            foundGroup.groupSettings = group.groupSettings;
            groupConversations.refresh();
            // aslo insert group in local database
            try {
              await groupConversationsDatabase
                  .insertGroupConversations([foundGroup]);
            } catch (_) {}
          }
        }
      }
    } catch (_) {}

    // aslo insert group in local database
    try {
      await groupConversationsDatabase.insertGroupConversations([data]);
    } catch (_) {}
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// mute conversation functions ////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///

  //
  //
  /// This mute the group conversations, hit api and also sync in local DB
  void unmuteGroup(GroupConversationEntity group, int index) async {
    if ((group.conversations ?? []).isEmpty || isMutingConversation) {
      return;
    }

    _isMutingConversation.value = true;
    mutingAtIndex.value = index;

    List<int> ids = [];

    for (var item in group.conversations!) {
      if (item.id != null) {
        ids.add(item.id!);
      }
    }

    try {
      final result = await _updateConversationMuteState(
        MuteConversationParams(
          muteDuration: null,
          conversations: ids,
        ),
      );
      if (result) {
        for (var item in group.conversations!) {
          item.notificationMuted = false;
        }
        groupConversations.refresh();
        filteredGroupConversations.refresh();

        //
        //
        // also update in local DB
        try {
          if (group.name != null) {
            groupConversationsDatabase.updateGroup(
              group.id!,
              group,
            );
          }
        } catch (_) {}
      }
    } catch (_) {}

    _isMutingConversation.value = false;
    mutingAtIndex.value = (-1);
  }

  void muteGroup(GroupConversationEntity group, int index) {
    Get.dialog(
      MuteDialogView(
        onDurationSelection: (muteDuration) {
          _muteGroup(group, muteDuration, index);
        },
        onCancle: () {
          //
        },
      ),
    );
  }

  //
  //
  /// This mute the group conversations, hit api and also sync in local DB
  void _muteGroup(
      GroupConversationEntity group, String muteDuration, int index) async {
    if ((group.conversations ?? []).isEmpty || isMutingConversation) {
      return;
    }

    _isMutingConversation.value = true;
    mutingAtIndex.value = index;

    List<int> ids = [];

    for (var item in group.conversations!) {
      if (item.id != null) {
        ids.add(item.id!);
      }
    }

    try {
      final result = await _updateConversationMuteState(
        MuteConversationParams(
          muteDuration: muteDuration,
          conversations: ids,
        ),
      );
      if (result) {
        for (var item in group.conversations!) {
          item.notificationMuted = true;
        }
        groupConversations.refresh();
        filteredGroupConversations.refresh();

        //
        //
        // also update in local DB
        try {
          if (group.name != null) {
            groupConversationsDatabase.updateGroup(
              group.id!,
              group,
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
  /// make conversation mute and unmute usecase
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

  void onConversationMuteStateChange(
      int groupId, int conversationId, bool muted) async {
    try {
      final group =
          groupConversations.firstWhereOrNull((item) => item.id == groupId);

      if (group == null) {
        return;
      }

      final conversation = group.conversations
          ?.firstWhereOrNull((item) => item.id == conversationId);

      if (conversation != null) {
        conversation.notificationMuted = muted;
        groupConversations.refresh();

        try {
          await groupConversationsDatabase.updateGroup(groupId, group);
        } catch (_) {}
      }
    } catch (_) {}
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// Pusher related functions ///////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///

  ///
  ///
  /// This function to subscribe for the call channel and
  /// attach event listeners
  void _subscribeForCallChannelEvents() {
    _subscribeForAgoraCallEndEvent();
    _subscribeForOngoingCallEvent();
    _subscribeForCallAcceptedWhipser();
  }

  ///
  ///
  /// function to subscribe for the agora call end event
  /// and also notify the group inner conversations controller
  void _subscribeForAgoraCallEndEvent() async {
    try {
      final callChannel = await pusher.subscribeToCallEventChannel();

      agoraCallEndSubscription =
          callChannel.bind("agora-call-ended").listen((event) {
        //channelName
        //conversationId
        //conversationType
        try {
          if (event.data != null) {
            final jsonData = jsonDecode(event.data);

            if (jsonData['conversationType'] == "group") {
              final int conversationId = jsonData['conversationId'];

              for (var group in groupConversations) {
                final conversation =
                    group.conversations?.firstWhereOrNull((conversation) {
                  return conversation.id == conversationId;
                });

                if (conversation != null) {
                  conversation.ongoingCall = null;
                  groupConversations.refresh();
                  // updating group inner conversations controller
                  try {
                    if (Get.isRegistered<GroupInnerConversationsController>()) {
                      Get.find<GroupInnerConversationsController>()
                          .loadGroupDetails();
                    }
                  } catch (_) {}
                  break;
                }
              }
            }
          }
        } catch (_) {}
      });
    } catch (_) {}
  }

  ///
  ///
  /// function to subscribe for the ongoing call event
  /// and also notify the group inner conversations controller
  void _subscribeForOngoingCallEvent() async {
    try {
      final callChannel = await pusher.subscribeToCallEventChannel();

      ongoingCallEventSubscription =
          callChannel.bind("ongoing-call").listen((event) {
        try {
          if (event.data != null) {
            final jsonData = jsonDecode(event.data);

            if (jsonData['conversation_type'] == "group") {
              final ongoingCallPayload = OngoingCallModel.fromJson(jsonData);

              if (ongoingCallPayload.conversationId == null) {
                return;
              }

              for (var group in groupConversations) {
                final conversation =
                    group.conversations?.firstWhereOrNull((conversation) {
                  return conversation.id == ongoingCallPayload.conversationId;
                });

                if (conversation != null) {
                  conversation.ongoingCall = ongoingCallPayload;
                  groupConversations.refresh();
                  // updating group inner conversations controller
                  try {
                    if (Get.isRegistered<GroupInnerConversationsController>()) {
                      Get.find<GroupInnerConversationsController>()
                          .loadGroupDetails();
                    }
                  } catch (_) {}
                  break;
                }
              }
            }
          }
        } catch (_) {}
      });
    } catch (_) {}
  }

  ///
  ///
  /// function to subscribe for the call accepted whisper
  /// and also notify the group inner conversations controller
  /// so dont show a join button if already accepted on remote
  /// just show a ongoing call
  void _subscribeForCallAcceptedWhipser() async {
    try {
      final callChannel = await pusher.subscribeToCallEventChannel();

      callAcceptedWhisperSubscription =
          callChannel.bind("client-call-accepted").listen((event) {
        try {
          if (event.data != null) {
            final jsonData = event.data;

            if (jsonData['conversationType'] == "group") {
              final int conversationId = jsonData['conversationId'];

              for (var group in groupConversations) {
                final conversation =
                    group.conversations?.firstWhereOrNull((conversation) {
                  return conversation.id == conversationId;
                });

                if (conversation != null) {
                  conversation.ongoingCall?.isAccepted.value = true;
                  groupConversations.refresh();
                  // updating group inner conversations controller
                  try {
                    if (Get.isRegistered<GroupInnerConversationsController>()) {
                      Get.find<GroupInnerConversationsController>()
                          .loadGroupDetails();
                    }
                  } catch (_) {}
                  break;
                }
              }
            }
          }
        } catch (_) {}
      });
    } catch (_) {}
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// Other functions ////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///

  //
  //
  // sort the group conversations list
  _sortGroupConversations() {
    //
    // Sort the inner conversations list and then sort the main list
    for (var groupConversation in groupConversations) {
      // Sort the inner conversations list based on message.createdAt
      groupConversation.conversations?.sort((a, b) {
        DateTime? aDate = a.message?.updatedAt ?? a.message?.createdAt;
        DateTime? bDate = b.message?.updatedAt ?? b.message?.createdAt;

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
    }

    //
    // Now, sort the main list based on the first conversation's date
    groupConversations.sort((a, b) {
      DateTime? aDate = (a.conversations?.isNotEmpty ?? false)
          ? a.conversations?.first.message?.createdAt
          : null;
      DateTime? bDate = (b.conversations?.isNotEmpty ?? false)
          ? b.conversations?.first.message?.createdAt
          : null;

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
    groupConversations.refresh();
  }

  //
  //
  // function to calculate the unread counts of the archived group inner conversations
  int getUnnreadOfArchivedGroupConversations(
      List<GroupConversationConversationEntity> innerConversations) {
    int count = 0;
    for (var element in innerConversations) {
      if (element.status == 'archive') {
        count += (element.unreadCount ?? 0);
      }
    }
    return count;
  }

  void resetUnreadCount(int conversationId) {
    String? groupName;

    // finding item and setting unread count to zero in group conversations list
    for (int j = 0; j < groupConversations.length; j++) {
      final conversationsList = groupConversations[j].conversations ?? [];
      var done = false;

      //
      for (int i = 0; i < conversationsList.length; i++) {
        if (conversationsList[i].id == conversationId) {
          groupConversations[j].unreadCount =
              (groupConversations[j].unreadCount ?? 0) -
                  (conversationsList[i].unreadCount ?? 0);
          conversationsList[i].unreadCount = 0;
          done = true;
          groupName = groupConversations[j].name;
          if ((groupConversations[j].unreadCount ?? 0) < 0) {
            groupConversations[j].unreadCount = 0;
          }
          groupConversations.refresh();
          break;
        }
      }
      if (done) {
        break;
      }
    }

    //
    // if inner conversations list module is active and
    // presenting a current group innner converstions
    // then also notify the inner converstions module
    try {
      if (groupName != null &&
          Get.isRegistered<GroupInnerConversationsController>()) {
        Get.find<GroupInnerConversationsController>()
            .resetUnreadCount(groupName, conversationId);
      }
    } catch (_) {}
  }

  ///
  ///
  /// This function will update the unread counts and last message,
  /// also notify the inner conversations module for new message
  onNewMessage(int conversationId, GroupLastMessageEntity lastMessage) {
    // // updating in group conversations list
    String? groupName;

    // finding item and updating unread count and last seen time in group conversations list
    for (int j = 0; j < groupConversations.length; j++) {
      final conversationsList = groupConversations[j].conversations ?? [];
      var done = false;

      //
      for (int i = 0; i < conversationsList.length; i++) {
        if (conversationsList[i].id == conversationId) {
          groupConversations[j].unreadCount =
              (groupConversations[j].unreadCount ?? 0) + 1;
          conversationsList[i].unreadCount =
              ((conversationsList[i].unreadCount ?? 0) + 1);
          conversationsList[i].dateTimeInHumans = "1 second ago";
          try {
            conversationsList[i].message = lastMessage;
          } catch (_) {}
          groupName = groupConversations[j].name;
          done = true;
          groupConversations.refresh();
          break;
        }
      }
      if (done) {
        break;
      }
    }

    //
    // if inner conversations list module is active and
    // presenting a current group innner converstions
    // then also notify the inner converstions module
    try {
      if (groupName != null &&
          Get.isRegistered<GroupInnerConversationsController>()) {
        Get.find<GroupInnerConversationsController>()
            .onNewMessage(groupName, conversationId, lastMessage);
      }
    } catch (_) {}

    //
    // sort the groups and inner conversations
    _sortGroupConversations();
  }

  ///
  ///
  /// This function will update the deleted_at of last message,
  /// also notify the inner conversations module for message deletion
  onMessageDelete(int conversationId, int messageId) {
    String? groupName;

    // finding item and updating deleted_at and last seen time in group conversations list
    for (int j = 0; j < groupConversations.length; j++) {
      final conversationsList = groupConversations[j].conversations ?? [];
      var done = false;

      //
      for (int i = 0; i < conversationsList.length; i++) {
        //
        // finding conversation
        if (conversationsList[i].id == conversationId) {
          //
          // check if last message id match
          if (conversationsList[i].message?.id == messageId) {
            conversationsList[i].dateTimeInHumans = "1 second ago";
            conversationsList[i].message?.deletedAt = DateTime.now();
            groupName = groupConversations[j].name;
            groupConversations.refresh();
          }
          done = true;
          break;
        }
      }
      if (done) {
        break;
      }
    }

    //
    // if inner conversations list module is active and
    // presenting a current group innner converstions
    // then also notify the inner converstions module
    try {
      if (groupName != null &&
          Get.isRegistered<GroupInnerConversationsController>()) {
        Get.find<GroupInnerConversationsController>()
            .onMessageDelete(groupName, conversationId, messageId);
      }
    } catch (_) {}

    //
    // sort the groups and inner conversations
    _sortGroupConversations();
  }

  ///
  ///
  /// This function update the unread counts in the dependecies modules
  /// like main screen bottom nav, conversations tab bar etc
  updateChatUnreadCountsForDependencies() {
    groupUnreadCounts.value = groupConversations.isEmpty
        ? 0
        : groupConversations
            .map((e) => e.unreadCount ?? 0)
            .reduce((value, e) => value + e);

    try {
      Get.find<MainScreenController>().updateUnreadMessageCounts();
    } catch (_) {}

    try {
      Get.find<ConversationsController>().updateGroupUnreadCounts();
    } catch (_) {}
  }

  ///
  ///
  /// This function will update the group name in list and also in the local DB.
  /// This will also notify sub modules that group name is updated.
  void onGroupNameUpdated(int groupId, String newName) async {
    try {
      for (var group in groupConversations) {
        if (group.id == groupId) {
          group.name = newName;
          group.conversations?.forEach((innerConversation) {
            innerConversation.groupName = newName;
          });
          groupConversations.refresh();

          //
          // updating group in local db
          try {
            //
            groupConversationsDatabase.updateGroup(groupId, group);
          } catch (_) {}

          //
          // notify sub modukes that group name has been updated
          try {
            if (Get.isRegistered<GroupInnerConversationsController>()) {
              Get.find<GroupInnerConversationsController>()
                  .groupNameUpdated(groupId, newName);
            }
          } catch (_) {}

          break;
        }
      }
    } catch (_) {}
  }

  ///
  ///
  /// This function will update the group logo in list and also in the local DB.
  /// This will also notify sub modules that group logo is updated.
  void onGroupLogoUpdated(int groupId, String logo) async {
    try {
      for (var group in groupConversations) {
        if (group.id == groupId) {
          group.groupSettings?.logo = logo;
          groupConversations.refresh();

          //
          // updating group in local db
          try {
            //
            await groupConversationsDatabase.updateGroup(groupId, group);
          } catch (_) {}

          //
          // notify sub modukes that group logo has been updated
          try {
            if (Get.isRegistered<GroupInnerConversationsController>()) {
              Get.find<GroupInnerConversationsController>()
                  .groupLogoUpdated(groupId, logo);
            }
          } catch (_) {}

          break;
        }
      }
    } catch (_) {}
  }

  ///
  ///
  /// This function will remove the participant from group->converstions->participants
  /// and also update in the local DB.
  /// This will also notify sub modules that participant is removed.
  void onParticipantRemoved(int groupId, int? userId, ModelType? modelType) {
    //
    // if given info is not good enought to process then return
    if (userId == null || modelType == null) {
      return;
    }

    // find group head
    final groupHead =
        groupConversations.firstWhereOrNull((group) => group.id == groupId);

    // head not found return
    if (groupHead == null) {
      return;
    }

    //
    // group head converstion not exists then return
    if ((groupHead.conversations ?? []).isEmpty) {
      return;
    }

    //
    // this variable indicates that removing user is currently logged-in user
    final removingMe =
        ((userId.toString() == myId) && (modelType == ModelType.USERS));

    //
    // remove participant from the group converstions
    for (var conversation in groupHead.conversations!) {
      //
      // if removed user is  me then make chatable false
      if (removingMe) {
        conversation.chatAble = false;
      }

      bool removingApplicant = false;

      //
      // if participants list not empty then remove user from participants
      if ((conversation.participants ?? []).isNotEmpty) {
        //
        // if removed user is driver then make chatable false
        if (modelType == ModelType.APPLICANTS) {
          removingApplicant = conversation.participants?.firstWhereOrNull(
                  (participant) =>
                      participant.id == userId &&
                      modelType == ModelType.APPLICANTS) !=
              null;
        }

        if (removingApplicant) {
          conversation.chatAble = false;
          conversation.status = "archive";
        }

        //
        // removing participant
        conversation.participants!.removeWhere((participant) =>
            (participant.id == userId) && (participant.modelType == modelType));
      }
    }

    //
    //
    // sync group details with DB.
    try {
      //
      groupConversationsDatabase.updateGroup(groupId, groupHead);
    } catch (_) {}

    //
    //
    // notify active sub modules that participants is removed from group
    try {
      if (Get.isRegistered<GroupInnerConversationsController>()) {
        Get.find<GroupInnerConversationsController>()
            .onParticipantRemoved(groupId);
      }

      if (Get.isRegistered<GroupSettingsController>()) {
        Get.find<GroupSettingsController>().onParticipantRemoved(groupId);
      }
    } catch (_) {}
  }

  ///
  ///
  /// This function will update the participant in group->converstions->participants
  /// and also update in the local DB.
  /// This will also notify sub modules that participant is updated.
  void onParticipantPermissionsUpdated(
      int groupId, ParticipantEntity participant) {
    // invalid participant entity
    if ((participant.pid == null) || (participant.id == null)) {
      return;
    }

    // find group head
    final groupHead =
        groupConversations.firstWhereOrNull((group) => group.id == groupId);

    // head not found return
    if (groupHead == null) {
      return;
    }

    //
    // group head converstion not exists then return
    if ((groupHead.conversations ?? []).isEmpty) {
      return;
    }

    //
    // find and update participant in the group conversations
    for (var conversation in groupHead.conversations!) {
      // if conversation participants exist then find and update it
      if ((conversation.participants ?? []).isNotEmpty) {
        //
        // iterate over participnats list in order to find a participant in a conversation
        for (ParticipantEntity item in conversation.participants!) {
          if ((item.id == participant.id) &&
              (item.modelType == participant.modelType)) {
            if (participant.isGroupAdmin != null) {
              item.isGroupAdmin = participant.isGroupAdmin;
            }
            break;
          }
        }
      }
    }

    //
    //
    // sync group details with DB.
    try {
      //
      groupConversationsDatabase.updateGroup(groupId, groupHead);
    } catch (_) {}

    //
    //
    // notify active sub modules that participants is removed from group
    try {
      if (Get.isRegistered<GroupInnerConversationsController>()) {
        Get.find<GroupInnerConversationsController>()
            .onParticipantPermissionsUpdated(groupId);
      }

      if (Get.isRegistered<GroupSettingsController>()) {
        Get.find<GroupSettingsController>()
            .onParticipantPermissionsUpdated(groupId);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    agoraCallEndSubscription?.cancel();
    ongoingCallEventSubscription?.cancel();
    callAcceptedWhisperSubscription?.cancel();
    super.dispose();
  }
}

enum GroupCreationStates { selectAdmins, selectDrivers, nameInput }

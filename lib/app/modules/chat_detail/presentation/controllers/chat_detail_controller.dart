// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cr_mentions/scr/models/mention_data.dart';
import 'package:cr_mentions/scr/models/mention_model.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_audios_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_documents_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_theme_file_helper.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_manager.dart';
import 'package:ts_admin/app/core/helpers/clipboard_helper.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_thumbnail_manager.dart';
import 'package:ts_admin/app/core/helpers/image_helper.dart';
import 'package:ts_admin/app/core/helpers/ios_clipboard_service.dart';
import 'package:ts_admin/app/core/helpers/location_picker.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';
import 'package:ts_admin/app/core/helpers/sound_recorder.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:ts_admin/app/core/widgets/rich_text_wrapper/controllers/controller.dart';
import 'package:ts_admin/app/core/widgets/rich_text_wrapper/models/match_target_item.dart';
import 'package:ts_admin/app/modules/chat/data/models/chat_theme_model.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/bottom_sheets/add_participants_bs_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/controllers/message_notifications_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/call_event_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/call_event_param.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/call_event_usecase.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/group_conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/buzz_message_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_participant_params.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/buzz_message_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_participant_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_typing_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/new_message_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/edit_message_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/edit_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/react_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_files_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/data/repositories/messages_db_manager.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/get_previous_messages_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/message_sent_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/delete_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/edit_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_conversation_details_usercase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_previous_messages_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/message_mark_as_read_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/react_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/send_text_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_info_tags_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/old_messages_syncer.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/bottom_sheets/message_reactions_bottom_sheet.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/bottom_sheets/participants_bottom_sheet.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/dialogs/delete_message_confirmation_dialog.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/dialogs/edit_text_message_dialog.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_receiver_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_sender_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_image_preview.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/reaction_components/widgets/chat_reactions.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/reaction_components/model/reactions_menu_item.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/reaction_components/utilities/reactions_default_data.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/reaction_components/utilities/reactions_dialog_route.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/remove_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/remove_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/auth/data/models/login_model.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/tenor/tenor_gif_picker.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/tenor/tenor_service.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/widgets/location_bottom_sheet.dart';
import 'package:ts_admin/app/native_calling/channels/native_calling_method_channel.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:vibration/vibration.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/injection_service.dart';
import '../../domain/usecases/send_file_message_usecase.dart';

class ChatDetailController extends GetxController {
  String type = "group";
  bool iAmParticipant = true;
  String groupName = "Group";
  RxString userName = "".obs;
  final RxnInt groupId = RxnInt();
  final RxString userImage = "".obs;
  final RxString groupImage = "".obs;
  final RxString userPhone = "".obs;
  int conversationId = -1;
  int receiverId = 0;
  bool chatable = false;
  String receiverModelType = "";

  final departmentName = "".obs;
  final _count = 0.obs;
  get count => _count.value;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ////////////////////////// Chat data variables ///////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsNotifier =
      ItemPositionsListener.create();
  final ScrollController textScrollController = ScrollController();

  final Rxn<ChatThemeModel> chatThemeData = Rxn();
  final Rxn<File> chatBackgroundFile = Rxn();

// Create an instance of Random
  final random = Random();

  // TextEditingController textEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //
  //
  // this holds the index of the currently scrolled message index
  // from a indexesOfSearchedMessages List
  final _currentScrolledIndexOfSearchedMessage = 0.obs;

  //
  // index of the searched message in a messages list which appears in search
  // and currenly presenting in views
  final currentSearchedIndex = (-1).obs;

  Rxn<ConversationDetailsEntity> conversationDetails = Rxn();

  /// this list holds the indexes of the searched messages from a messages list
  /// indexes stored in this list, points towards the indexes of searched messages
  /// in a messages list
  final RxList<int> indexesOfSearchedMessages = RxList();

  final focusNode = FocusNode().obs;

  bool me = false;

  String typingMessage = "typing...";

  final RxList<ConversationMessageEntity> _messagesList =
      <ConversationMessageEntity>[].obs;
  List<ConversationMessageEntity> get messages => _messagesList;

  final String myId = GetStorage().read(UserPrefKeys.userId).toString();
  final storage = GetStorage();
  String myName = '';
  late String myImageUrl;

  final RxList<AttachmentModel> selectedAttachments = RxList();

  // list contains the ids of those message for that mark as read api is called
  final RxList<int> _messagesMarkedAsRead = <int>[].obs;

  final Rxn<ConversationMessageEntity> selectedMessageForReply = Rxn();

  final RxDouble audioPlayerSpeed = (1.0).obs;
  final Rxn<AudioPlayer> currentAudioPlayer = Rxn();

  //
  // indicates the id of the message which have a buzz
  final RxnInt buzzOnMessageId = RxnInt();

  final RxList<int> selectedMessages = RxList<int>();

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ////////////////////////// Chat file manager /////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  final chatDocumentsManager = Get.find<ChatDocumentsManager>();
  final chatVideosManager = Get.find<ChatVideosManager>();
  final chatVideosThumbnailManager = Get.find<ChatVideosThumbnailManager>();

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////// Recording Related Things ///////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final _blink = false.obs;
  get blink => _blink.value;

  final _recordingDuration = Duration.zero.obs;
  get recordingDuration => _recordingDuration;
  final SoundRecorder _recorder = SoundRecorder();

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////// Audio Player Related Things ////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final _currentPlayerId = "2".obs;
  get currentPlayerId => _currentPlayerId.value;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// Location Related Things ////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  // final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  final locationAddress = "".obs;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// chat usecases etc //////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final sendTextMessageUseCase = sl<SendTextMessageUseCase>();
  final sendFileMessageUseCase = sl<SendFileMessageUseCase>();
  final messageMarkAsReadUseCase = sl<MessageMarkAsReadUseCase>();
  final getPreviousMessagesUseCase = sl<GetPreviousMessagesUseCase>();
  final removeParticipantsUseCase = sl<RemoveParticipantsUseCase>();
  final updateParticipantsUseCase = sl<UpdateParticipantUsecase>();
  final messagesDatabase = sl<MessagesDatabase>();
  final callEventUsecase = sl<CallEventUsecase>();
  final deleteMessageUsecase = sl<DeleteMessageUseCase>();
  final getConversationDetailsUseCase = sl<GetConversationDetailsUseCase>();
  final editMessageUseCase = sl<EditTextMessageUseCase>();
  final reactMessageUseCase = sl<ReactMessageUseCase>();
  final buzzMessageUseCase = sl<BuzzMessageUsecase>();
  final authController = Get.find<AuthController>();
  final pusher = sl<PusherManager>();
  final chatInfoTagController =
      Get.put<ChatInfoTagsController>(ChatInfoTagsController());

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// pusher event subscriptions /////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  StreamSubscription<ChannelReadEvent>? messageReceivedSubscription;
  StreamSubscription<ChannelReadEvent>? messageReadSubscription;
  StreamSubscription<ChannelReadEvent>? typingSubscription;
  StreamSubscription<ChannelReadEvent>? messageReactionSubscription;
  StreamSubscription<ChannelReadEvent>? messageDeletionSubscription;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// loading and api states /////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  final RxBool _isLoadingChatDetails = false.obs;
  bool get isLoadingChatDetails => _isLoadingChatDetails.value;

  final RxBool _isLoadingPreviousMessagesFromApi = false.obs;
  bool get isLoadingPreviousMessagesFromApi =>
      _isLoadingPreviousMessagesFromApi.value;

  final RxBool _isLoadingPreviousMessagesFromDB = false.obs;
  bool get isLoadingPreviousMessagesFromDB =>
      _isLoadingPreviousMessagesFromDB.value;

  final RxBool _isLoadingFromDatabase = false.obs;
  bool get isLoadingFromDatabase => _isLoadingFromDatabase.value;

  final RxBool _isDatabaseListEmpty = false.obs;
  bool get isDatabaseListEmpty => _isDatabaseListEmpty.value;

  final RxBool _isDeletingMessage = false.obs;
  bool get isDeletingMessage => _isDeletingMessage.value;

  // removing participant state
  final RxBool _isRemovingParticipant = false.obs;
  bool get isRemovingParticipant => _isRemovingParticipant.value;

  // update participant state
  final RxBool _isUpdatingParticipant = false.obs;
  bool get isUpdatingParticipant => _isUpdatingParticipant.value;

  // place call state
  final RxBool _isPlacingCaling = false.obs;
  bool get isPlacingCaling => _isPlacingCaling.value;

  final RxBool _isEditingMessage = false.obs;
  bool get isEditingMessage => _isEditingMessage.value;

  final RxBool _isSendingBuzz = false.obs;
  bool get isSendingBuzz => _isSendingBuzz.value;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// chat realed states /////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  bool noMoreMessages = false;

  var removingAtIndex = -1;
  var updatingParticipantAtIndex = -1;

  final _hideSendIcon = false.obs;
  get hideSendIcon => _hideSendIcon.value;

  final _recorderEnabled = true.obs;
  get recorderEnabled => _recorderEnabled.value;

  final isEmojiPickerVisible = false.obs;

  final RxBool _isTyping = false.obs;
  bool get isTyping => _isTyping.value;

  late OldMessagesSyncer messageSyncer;

  final RxBool _isMessageSelectionEnabled = false.obs;
  bool get isMessageSelectionEnabled => _isMessageSelectionEnabled.value;

  final RxBool _messageTempHighlightEnabled = false.obs;
  bool get messageTempHighlightEnabled => _messageTempHighlightEnabled.value;

  final RxInt tempHighlightMessageId = (-1).obs;

  final RxBool _showMentionMenu = false.obs;
  bool get showMentionMenu => _showMentionMenu.value;

  final RxBool _receivedBuzz = false.obs;
  bool get receivedBuzz => _receivedBuzz.value;

  final RxBool isSearchEnabled = false.obs;

  final RxBool haveImageInClipBoard = false.obs;

  final RxBool buzzPressed = false.obs;

  //
  final showScrollDownButton = false.obs;

////////////// mention related variables
  // late final richTextController =
  //     MentionTextController(lastMention: lastMention);

  final lastMention = ValueNotifier<MentionModel?>(null);
  final RxList<MentionData<UserModel>> usersMentioned =
      RxList<MentionData<UserModel>>();

  final tenorService = TenorService(
    apiKey: 'REPLACE_WITH_GOOGLE_API_KEY',
    clientKey: 'mychatapp',
    locale: Get.locale?.toLanguageTag(),
  );

  // Add a controller
  late final RichTextController richTextController = RichTextController(
    targetMatches: [
      //
      //
      // bold + italic regix
      MatchTargetItem(
        regex: RegExp(r'\*_(.*?)_\*'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        regixCharStyle: const TextStyle(
          color: Colors.grey,
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // bold regix
      MatchTargetItem(
        regex: RegExp(r'\*(.*?)\*'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        regixCharStyle: const TextStyle(
          color: Colors.grey,
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // italic regix
      MatchTargetItem(
        regex: RegExp(r'_(.*?)_'),
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
        regixCharStyle: const TextStyle(
          color: Colors.grey,
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // strike through regix
      MatchTargetItem(
        regex: RegExp(r'~(.*?)~'),
        style: const TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
        regixCharStyle: const TextStyle(
          color: Colors.grey,
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // shipment tag regix
      MatchTargetItem(
        regex: RegExp(r'\$(.*?)\$'),
        regixCharStyle: TextStyle(
          color: Colors.grey.applyOpacity(0.5),
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // driver tag regix
      MatchTargetItem(
        regex: RegExp(r'!(.*?)!'),
        regixCharStyle: TextStyle(
          color: Colors.grey.applyOpacity(0.5),
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // truck tag regix
      MatchTargetItem(
        regex: RegExp(r'/(.*?)/'),
        regixCharStyle: TextStyle(
          color: Colors.grey.applyOpacity(0.5),
        ),
        allowInlineMatching: true,
      ),

      //
      //
      // underline regix
      // MatchTargetItem(
      //   regex: RegExp(r'<([^>]+)>'),
      //   style: const TextStyle(
      //     decoration: TextDecoration.underline,
      //   ),
      //   regixCharStyle: const TextStyle(
      //     color: Colors.grey,
      //   ),
      //   allowInlineMatching: true,
      // ),
    ],
    onMatch: (List<String> matches) {},
    deleteOnBack: false,
    regExpUnicode: false,
    lastMention: lastMention,
  );

  final nowDateTime = DateTime.now();

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      final arguments = Get.arguments;
      receiverId = arguments['userId'] ?? 0;
      userName.value = arguments['userName'] ?? "";
      userImage.value = arguments['userImage'] ?? "";
      userPhone.value = arguments['userPhone'] ?? "";
      type = arguments['type'] ?? "group";
      chatable = arguments['chatable'] ?? false;
      receiverModelType = arguments['modelType'] ?? "";
      iAmParticipant = arguments['i_am_participant'] ?? false;
      groupName = arguments['group_name'] ?? "Group";
      conversationId = arguments['conversation_id'] ?? -1;
      _receivedBuzz.value = arguments['haveBuzz'] ?? false;
      buzzOnMessageId.value = arguments['buzzOnMessage'];
      groupId.value = arguments['groupId'];
      if (conversationId == -1) {
        Get.back();
      }
    } else {
      Get.back();
    }

    messageSyncer = OldMessagesSyncer(conversationId);
    //
    // reset buzz states
    Future.delayed(const Duration(seconds: 3), () {
      _receivedBuzz.value = false;
      buzzOnMessageId.value = null;
    });

    if (type == "group") {
      _loadGroupIcon();
    }

    // generating my name from prefs
    try {
      final Map<String, dynamic> myDetails =
          storage.read(UserPrefKeys.userDetails);
      final String firstName = myDetails['first_name'] ?? "";
      final String middleName = myDetails['middle_name'] ?? "";
      final String maidenName = myDetails['maiden_name'] ?? "";
      final String lastName = myDetails['last_name'] ?? "";
      myImageUrl = myDetails['profile'] ?? "";

      if (firstName.isNotEmpty) {
        myName = firstName;
      }
      if (middleName.isNotEmpty) {
        if (myName.isEmpty) {
          myName = middleName;
        } else {
          myName += ' $middleName';
        }
      }
      if (maidenName.isNotEmpty) {
        if (myName.isEmpty) {
          myName = maidenName;
        } else {
          myName += ' $maidenName';
        }
      }
      if (lastName.isNotEmpty) {
        if (myName.isEmpty) {
          myName = lastName;
        } else {
          myName += ' $lastName';
        }
      }
    } catch (_) {}

    itemPositionsNotifier.itemPositions.addListener(() {
      int firstVisibleIndex =
          itemPositionsNotifier.itemPositions.value.first.index;
      if (firstVisibleIndex > 0 && (!showScrollDownButton.value)) {
        showScrollDownButton(true);
      } else if (firstVisibleIndex < 1 && showScrollDownButton.value) {
        showScrollDownButton(false);
      }
    });

    loadDataMessagesFromDatabase();

    await _configureMessageAndEmojiPickerThings();

    await _configureAudioRecorder();

    // await _configureLocationPickerCamera();

    /// if user is not chatable then no need to attach listeners for messages
    // if (type == "group" && iAmParticipant) {
    //   await _setChatListeners();
    // } else if (type == "oto") {
    //   await _setChatListeners();
    // }
    if (chatable) {
      await _setChatListeners();
    }

// mention listner attching
    if (type == "group") {
      lastMention.addListener(_mentionsListener);
    }

    richTextController.addListener(_onTextChanged);
    chatInfoTagController.initializeTextController(richTextController);
    chatInfoTagController.chatDetailController = this;

    //
    // notify message notifications controller for active chat
    try {
      if (Get.isRegistered<MessageNotificationsController>()) {
        Get.find<MessageNotificationsController>()
            .removeActiveChatMessageNotifications(conversationId);
      }
    } catch (_) {}

    //
    // loading chat background theme data
    _loadChatBackgroundThemeData();
  }

  ////
  ///
  /// on text change listener for message input
  /// that will emit typing event and update send icon
  /// also check for the info tags etc
  void _onTextChanged() {
    _count.value = richTextController.text.trim().length;

    if (_count.value > 0) {
      pusher.emitTypingEvent({
        'user': {'id': myId, 'model_type': 'users', 'name': myName},
        'typing': true
      });
    }
    updateSendIcon();
    if (Platform.isIOS) {
      checkForImageInIosClipboard();
    }
  }

  ///
  ///
  /// function that will load the chat background theme data
  void _loadChatBackgroundThemeData() async {
    try {
      final themeData = await storage.read(UserPrefKeys.chatTheme);
      chatThemeData.value = ChatThemeModel.fromJson(themeData);

      if (chatThemeData.value != null) {
        if (chatThemeData.value!.type == ChatThemeType.image) {
          chatBackgroundFile.value =
              await ChatThemeFileHelper.instance.loadThemeFile();
        }
      }
    } catch (_) {}
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//////////////////////// Mention Related functions /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// mention listner and try for query
  void _mentionsListener() {
    final mention = lastMention.value;
    if (mention != null) {
      final text = mention.mentionName ?? '@';
      _makeQueryAndTryRequestSuggestions(text);
    } else {
      usersMentioned.clear();
    }
  }

// making and trying mention search query
// if maked search query is null clear old mesntions list
// if search query is empty then add all users in mentioned list
// else apply search for suggestions
  void _makeQueryAndTryRequestSuggestions(String query) {
    String? searchQuery = richTextController.makeQuerySuggestions(query);
    if (searchQuery != null) {
      if (searchQuery.isNotEmpty) {
        _searchSimulation(searchQuery);
      } else {
        usersMentioned.addAll(conversationDetails.value?.participants
                ?.where((element) => ((element.id?.toString() != myId) ||
                    (element.modelType != "users")))
                .map(
                  (e) => MentionData<UserModel>(
                    id: e.pId,
                    mentionName: e.name,
                    data: UserModel(
                        id: e.id,
                        name: e.name,
                        modelType: e.modelType,
                        image: e.image),
                  ),
                ) ??
            []);
      }
    } else {
      usersMentioned.clear();
    }
  }

// applying search on
  void _searchSimulation(String searchQuery) {
    usersMentioned.clear();
    usersMentioned.addAll(
      conversationDetails.value?.participants?.where(
            (user) {
              final mentionName = user.name;
              if (mentionName != null &&
                  ((user.id?.toString() != myId) ||
                      (user.modelType != "users"))) {
                return mentionName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
              } else {
                return false;
              }
            },
          ).map(
            (e) => MentionData<UserModel>(
              id: e.pId,
              mentionName: e.name,
              data: UserModel(
                  id: e.id,
                  name: e.name,
                  modelType: e.modelType,
                  image: e.image),
            ),
          ) ??
          [],
    );
  }

  // on tapping the suggestion adding user mentioned to mention controller
  // and clear mentioned list
  void onUserTapped(MentionData<UserModel> model) {
    // textEditingController.insertMention(model);
    richTextController.insertMention(model);
    usersMentioned.clear();
  }

  // replace a mentioned user names with pid
  String replaceMentionOccurance(String text) {
    var newText = text;
    conversationDetails.value?.participants?.forEach((element) {
      newText = newText.replaceAll('@${element.name}', '[~${element.pId}]');
    });
    return newText;
  }

  // get a list of mentioned user in a message
  List<MessageMention> getMentionsOfMessage(String text) {
    List<MessageMention> list = [];
    conversationDetails.value?.participants?.forEach((element) {
      if (text.contains('@${element.name}')) {
        list.add(MessageMention(
            pid: element.pId ?? 0,
            modelType: element.modelType ?? "",
            modelId: element.id ?? 0));
      }
    });
    return list;
  }

  // get a list of mentions in a message inorder to add then in a local message
  List<ConversationMentionEntity> getMentionsOfMessageForLocalList(
      String text) {
    List<ConversationMentionEntity> list = [];
    conversationDetails.value?.participants?.forEach((element) {
      if (text.contains('@${element.name}')) {
        list.add(ConversationMentionEntity(
            participantId: element.pId ?? 0,
            modelType: element.modelType ?? "",
            modelId: element.id ?? 0,
            user: MentionUserModel(
                id: element.id,
                modelType: element.modelType ?? "",
                name: element.name,
                image: element.image)));
      }
    });
    return list;
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  Future<void> _loadGroupIcon() async {
    try {
      final dbManager = GroupConversationsDatabase();
      final group = await dbManager.getGroupByName(groupName);
      if (group != null) {
        groupImage.value = group.groupSettings?.logo ?? "";
        groupId.value = group.id;
      }
    } catch (_) {}
  }

  clearSearch() {
    searchController.clear();
    indexesOfSearchedMessages.clear();
    indexesOfSearchedMessages.refresh();
    currentSearchedIndex.value = -1;
    _currentScrolledIndexOfSearchedMessage.value = 0;
    scrollController.scrollTo(
        index: 0, duration: const Duration(milliseconds: 500));
  }

  scrollToSearchedMessageIndex(bool next) {
    if (next) {
      final nextIndex = _currentScrolledIndexOfSearchedMessage.value - 1;
      if (nextIndex < indexesOfSearchedMessages.length && nextIndex >= 0) {
        _scrollToIndex(indexesOfSearchedMessages[nextIndex]);
        currentSearchedIndex.value = indexesOfSearchedMessages[nextIndex];
        _currentScrolledIndexOfSearchedMessage.value = nextIndex;
      }
    } else {
      final previousIndex = _currentScrolledIndexOfSearchedMessage.value + 1;
      if (previousIndex < indexesOfSearchedMessages.length &&
          previousIndex >= 0) {
        _scrollToIndex(indexesOfSearchedMessages[previousIndex]);
        currentSearchedIndex.value = indexesOfSearchedMessages[previousIndex];
        _currentScrolledIndexOfSearchedMessage.value = previousIndex;
      }

      //
      // check if scrolled to last message then go again for previous messages
      try {
        if (previousIndex == (indexesOfSearchedMessages.length - 1) &&
            messages.isNotEmpty) {
          if (messages.last.id != null) {
            loadPreviousMessagesFromDB(messages.last.id!);
          }
        }
      } catch (_) {}
    }
  }

  scrollToRepliedMessage(int? messageId, {int tries = 1}) async {
    //
    if (messageId == null) {
      return;
    }
    try {
      final index =
          _messagesList.indexWhere((element) => element.id == messageId);
      if (index < 0) {
        if (tries > 5) {
          return;
        }
        if (messages.last.id != null) {
          await loadPreviousMessagesFromDB(messages.last.id!);
          await Future.delayed(const Duration(seconds: 1));
          return scrollToRepliedMessage(messageId, tries: tries + 1);
        }
        return;
      }
      _scrollToIndex(index);

      // store temp hilghlight id and enable higlighting
      tempHighlightMessageId.value = messageId;
      _messageTempHighlightEnabled.value = true;

      // disable message highlighting and reset temp hilghlight id
      Future.delayed(const Duration(milliseconds: 1500), () {
        _messageTempHighlightEnabled.value = false;
        tempHighlightMessageId.value = (-1);
      });
    } catch (_) {}
  }

  scrollToMessageAtIndex(int index) {
    //
    try {
      _scrollToIndex(index);
    } catch (_) {}
  }

  int getPreviousSearchCount() {
    final count = (indexesOfSearchedMessages.length -
        (_currentScrolledIndexOfSearchedMessage.value + 1));
    return count;
  }

  int getNextSearchCount() {
    final count = indexesOfSearchedMessages.length -
        (indexesOfSearchedMessages.length -
            (_currentScrolledIndexOfSearchedMessage.value));
    return count;
  }

  void _scrollToIndex(int index) {
    scrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  loadDataMessagesFromDatabase() async {
    // messages.clear();
    try {
      _isLoadingFromDatabase(true);
      messages.addAll(await messagesDatabase.getAllMessages(conversationId));
      _isLoadingFromDatabase(false);
      if (messages.isEmpty) {
        _isDatabaseListEmpty(true);
      } else {
        _sortMessagesList();
      }
    } catch (_) {
      _isLoadingFromDatabase(false);
    }
    getChatDetails();
  }

  // sort messages list on the bases of the created at
  _sortMessagesList() {
    messages.sort((a, b) {
      DateTime? aDate = a.createdAt;
      DateTime? bDate = b.createdAt;

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

  _configureMessageAndEmojiPickerThings() async {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        indexesOfSearchedMessages.clear();
      } else {
        _appMessagesSearch();
      }
    });

    focusNode.value.addListener(() {
      if (focusNode.value.hasFocus) {
        isEmojiPickerVisible.value = false;
      }
    });
  }

  _appMessagesSearch() {
    indexesOfSearchedMessages.clear();
    final searchText = searchController.text.toLowerCase();
    for (int i = 0; i < messages.length; i++) {
      final messagesString = messages[i].message?.toLowerCase() ?? "";
      String fileName = "";

      // checking if message contains media then also search for filename
      if (messages[i].attachments?.isNotEmpty ?? false) {
        // checking if file is only document or attachmnet then search for file name else skip
        if ((messages[i].type != MessageTypes.image) &&
            (messages[i].type != MessageTypes.audio) &&
            (messages[i].type != MessageTypes.recorded)) {
          fileName = messages[i].attachments![0].fileName?.toLowerCase() ?? "";
        }
      }
      if (messagesString.contains(searchText) ||
          (fileName.contains(searchText) && fileName.isNotEmpty)) {
        indexesOfSearchedMessages.add(i);
      }
    }
    indexesOfSearchedMessages.refresh();
    if (indexesOfSearchedMessages.isNotEmpty) {
      scrollController.scrollTo(
        index: indexesOfSearchedMessages.first,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
      _currentScrolledIndexOfSearchedMessage.value = 0;
      currentSearchedIndex.value = indexesOfSearchedMessages[0];
    } else {
      try {
        if (messages.isNotEmpty && messages.last.id != null) {
          loadPreviousMessagesFromDB(messages.last.id!);
        }
      } catch (_) {}
    }
  }

  List<int> _findSearchedMessagesIds(
      List<ConversationMessageEntity> messagesList) {
    final searchText = searchController.text.toLowerCase();

    return messagesList
        .where((message) {
          final messagesString = message.message?.toLowerCase() ?? "";
          String fileName = "";

          // checking if message contains media then also search for filename
          if (message.attachments?.isNotEmpty ?? false) {
            // checking if file is only document or attachmnet then search for file name else skip
            if ((message.type != MessageTypes.image) &&
                (message.type != MessageTypes.audio) &&
                (message.type != MessageTypes.recorded)) {
              fileName = message.attachments![0].fileName?.toLowerCase() ?? "";
            }
          }
          return (messagesString.contains(searchText) ||
              (fileName.contains(searchText) && fileName.isNotEmpty));
        })
        .map((message) => message.id)
        .whereType<int>()
        .toList();
  }

  _configureAudioRecorder() async {
    await _recorder.init();
    _recorder.addDurationChangeListener((duration) {
      _recordingDuration.value = duration;
    });
  }

  // ignore: unused_element
  _configureLocationPickerCamera() async {
    if (await PermissionHelper.haveLocationPermission(
        "Grant location permission in settings to track deliveries.")) {
      var position = await getCurrentLocation();

      if (position != null) {
        cameraPosition = CameraPosition(
          target: LatLng(position.altitude, position.longitude),
          zoom: 14.4746,
        );
      }
    }
  }

  updateSendIcon() {
    String trimmedString = richTextController.text.trim();
    if (trimmedString.isEmpty &&
        selectedAttachments.isEmpty &&
        (!_recorderEnabled.value)) {
      setMicIcon();
    } else if (((trimmedString.isNotEmpty) ||
            (selectedAttachments.isNotEmpty)) &&
        _recorderEnabled.value) {
      setSendIcon();
    }
  }

  removeSelectedAttachment() {
    selectedAttachments.clear();
    updateSendIcon();
  }

  setSendIcon() {
    _hideSendIcon.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      _recorderEnabled.value = false;
      _hideSendIcon.value = false;
    });
  }

  setMicIcon() {
    _hideSendIcon.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      _recorderEnabled.value = true;
      _hideSendIcon.value = false;
    });
  }

  void closeKeyboardAndPicker() {
    FocusManager.instance.primaryFocus?.unfocus();
    isEmojiPickerVisible.value = false;
  }

  void showGifPicker() {
    final ctx = Get.context!;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.75),
      builder: (_) => TenorGifPicker(
        service: tenorService,
        onSelected: (gif) async {
          Navigator.pop(ctx);

          sendGifMessage(gif);
        },
      ),
    );
  }

  Future<void> sendGifMessage(TenorGif gif) async {
    try {
      final uuid = DateTime.now().millisecondsSinceEpoch.toString();
      final url = gif.gifUrl ?? gif.tinyGifUrl ?? gif.mp4Url ?? '';

      final local = ConversationMessageModel(
        model: ConversationUserModel(id: int.parse(myId), image: myImageUrl),
        modelId: int.parse(myId),
        type: MessageTypes.gif,
        message: url,
        createdAt: DateTime.now(),
        tempId: uuid,
      )
        ..sendedNow = true
        ..replyOn = selectedMessageForReply.value;

      _messagesList.insert(0, local);
      if (_messagesList.length > 10) {
        scrollController.scrollTo(
            index: 0, duration: const Duration(milliseconds: 500));
      }

      // send to backend with gif_info
      final params = SendTextMessageParams(
        conversationId: conversationId.toString(),
        message: '',
        type: MessageTypes.gif,
        tempId: uuid,
        replyOnMessageId: selectedMessageForReply.value?.id,
        gifInfo: gif.raw,
      );
      selectedMessageForReply.value = null;

      final result = await sendTextMessageUseCase.call(params);
      result.fold((remote) async {
        if (remote.code == 200 && (remote.data?.isNotEmpty ?? false)) {
          for (var element in remote.data!) {
            for (int i = _messagesList.length - 1; i >= 0; i--) {
              if (_messagesList[i].sendedNow &&
                  _messagesList[i].tempId == uuid) {
                _messagesList[i].id = element.id;
                _messagesList[i].sentSuccessfully = true;

                Get.find<OtoConversationsController>().moveConversationOnTop(
                  conversationId,
                  ConversationLastMessageEntity(
                    id: _messagesList[i].id,
                    message: "[GIF]",
                    type: _messagesList[i].type,
                    modelId: _messagesList[i].modelId,
                    attachments: _messagesList[i].attachments,
                    createdAt: _messagesList[i].createdAt,
                  ),
                  incrementUnread: false,
                );

                _messagesList[i].model =
                    element.model ?? _messagesList[i].model;
                await messagesDatabase.insertMessage(_messagesList[i]);
                _messagesList.refresh();
                break;
              }
            }
          }
        }
      }, (r) {
        CommonWidgets.showSnackBar(title: 'Error'.tr, message: r.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    }
  }

  sendMessage() async {
    if (richTextController.text.trim().isEmpty && selectedAttachments.isEmpty) {
      updateSendIcon();
      return;
    }

    final mentionsList =
        getMentionsOfMessage(richTextController.text.toString().trim());

    final mentionsListLocal = getMentionsOfMessageForLocalList(
        richTextController.text.toString().trim());

    final cleanedMessageText =
        richTextController.text.toString().trim().replaceAllMapped(
              RegExp(r'([/$!])([^/$!]+)\1'),
              (match) => match.group(2) ?? '',
            );

    chatInfoTagController.clearAllSuggestions();

    final uuid = DateTime.now().millisecondsSinceEpoch.toString();

    if (selectedAttachments.isEmpty) {
      final message = ConversationMessageModel(
          model: ConversationUserModel(
              id: int.parse(myId),
              modelType: authController.user.value?.modelType),
          modelId: int.parse(myId),
          type: MessageTypes.text,
          message: replaceMentionOccurance(cleanedMessageText),
          createdAt: DateTime.now(),
          mentions: mentionsListLocal,
          tempId: uuid);
      message.sendedNow = true;
      message.replyOn = selectedMessageForReply.value;
      _messagesList.insert(0, message);
      if (_messagesList.length > 10) {
        scrollController.scrollTo(
            index: 0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut);
      }
      richTextController.clear();

      final params = SendTextMessageParams(
          conversationId: conversationId.toString(),
          message: message.message!,
          tempId: uuid,
          type: message.type,
          mentions: mentionsList,
          replyOnMessageId: selectedMessageForReply.value?.id);

      // clearing selected message
      selectedMessageForReply.value = null;

      // sending message to server
      try {
        final Either<MessageSentEntity, Failure> result =
            await sendTextMessageUseCase.call(params);
        result.fold((MessageSentEntity messageSentFromRemote) async {
          if (messageSentFromRemote.code == 200 &&
              (messageSentFromRemote.data?.isNotEmpty ?? false)) {
            // iterating messages list and compare its id with sent message

            for (var element in messageSentFromRemote.data!) {
              for (int i = (_messagesList.length - 1); i >= 0; i--) {
                if (_messagesList[i].sendedNow &&
                    _messagesList[i].tempId == uuid) {
                  _messagesList[i].id = element.id;
                  _messagesList[i].sentSuccessfully = true;
                  _messagesList[i].conversationId = conversationId;

                  _messagesList[i].model =
                      element.model ?? _messagesList[i].model;

                  _messagesList.refresh();
                  break;
                }
              }
            }
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
      }
    } else {
      //
      List<File> files = [];

      // collecting files and adding message to messages list
      for (var attachment in selectedAttachments) {
        //
        final file = File(attachment.file!.path);

        //
        files.add(file);

        // creating media object and configs the object
        final conversationMedia = AttachmentModel();
        conversationMedia.sendedNow = true;
        conversationMedia.sending = true;
        conversationMedia.file = file;
        conversationMedia.mimeType = attachment.mimeType;

        /// creating message object in order to add it to messages lis tto show on front end
        final message = ConversationMessageModel(
          model: ConversationUserModel(
              id: int.parse(myId),
              modelType: authController.user.value?.modelType),
          modelId: int.parse(myId),
          type: attachment.attachmentType,
          message: replaceMentionOccurance(cleanedMessageText),
          tempId: uuid,
          createdAt: DateTime.now(),
          mentions: mentionsListLocal,
          attachments: [conversationMedia],
        );
        message.sendedNow = true;
        message.replyOn = selectedMessageForReply.value;

        // adding message to list
        _messagesList.insert(0, message);
        if (_messagesList.length > 10) {
          scrollController.scrollTo(
              index: 0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut);
        }
      }

      /// creating params in order to send to api
      var messageParams = SendFilesMessageParams(
          conversationId: conversationId.toString(),
          message: replaceMentionOccurance(cleanedMessageText),
          tempId: uuid,
          files: files,
          type: selectedAttachments[0].attachmentType,
          mentions: mentionsList,
          progressListener: (progress) {
            // for (var element in messages) {
            //   if (element.tempId == uuid && element.sendedNow) {
            //     if (element.media?.isNotEmpty ?? false) {
            //       element.media![0].progress = progress;
            //     }
            //     break;
            //   }
            // }
          },
          replyOnMessageId: selectedMessageForReply.value?.id);

      removeSelectedAttachment();
      richTextController.clear();
      selectedMessageForReply.value = null;

      try {
        final response = await sendFileMessageUseCase.call(messageParams);

        response.fold((l) {
          // for (int i = (_messagesList.length - 1); i >= 0; i--) {
          //   if (_messagesList[i].sendedNow && _messagesList[i].tempId == uuid) {
          //     _messagesList[i].id = l.id;
          //     _messagesList[i].sentSuccessfully = true;
          //     _messagesList.refresh();
          //     break;
          //   }
          // }

          if (l.code == 200 && (l.data?.isNotEmpty ?? false)) {
            // remove message which are related to this request call
            _messagesList.removeWhere(
                (element) => (element.sendedNow && (element.tempId == uuid)));

            // iterating messages list and compare its id with sent message
            for (var element in l.data!) {
              final newMessage =
                  ConversationMessageEntity.fromJson(element.toJson());
              _messagesList.insert(0, newMessage);
            }

            // sorting messages
            _messagesList.sort((a, b) =>
                b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);
          }
        }, (r) {
          // for (var element in messages) {
          //   if (element.tempId == uuid && element.sendedNow) {
          //     if (element.media?.isNotEmpty ?? false) {
          //       element.media![0].sending = false;
          //       element.media![0].sendedSuccessfully = false;
          //       element.media![0].progress = 0;
          //     }
          //     break;
          //   }
          // }
        });
      } catch (error) {
        // for (var element in messages) {
        //   if (element.tempId == uuid && element.sendedNow) {
        //     if (element.media?.isNotEmpty ?? false) {
        //       element.media![0].sending = false;
        //       element.media![0].sendedSuccessfully = false;
        //       element.media![0].progress = 0;
        //     }
        //     break;
        //   }
        // }
      }
    }
  }

  editMessage(ConversationMessageEntity message, String newMessage) async {
    if (newMessage.isEmpty || message.id == null) {
      return;
    }

    final params = EditTextMessageParams(
      messageId: message.id!,
      message: newMessage,
    );

    // sending message to server
    try {
      _isEditingMessage(true);

      //
      final Either<EditMessageEntity, Failure> result =
          await editMessageUseCase.call(params);

      result.fold((EditMessageEntity messageFromRemote) {
        if (messageFromRemote.code == 200 &&
            (messageFromRemote.error == false)) {
          // iterating messages list and compare its id with sent message

          for (int i = (_messagesList.length - 1); i >= 0; i--) {
            if (_messagesList[i].id == message.id) {
              _messagesList[i].message = newMessage;
              _messagesList[i].updatedAt = DateTime.now();
              _messagesList.refresh();
              break;
            }
          }
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: messageFromRemote.message ??
                "Something went wrong while editing message.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });

      _isEditingMessage(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      _isEditingMessage(false);
      debugPrint(e.toString());
    }
  }

  deleteMessage(int? messageId) async {
    if (messageId == null || isDeletingMessage) {
      return;
    }

    // delete message api call
    try {
      _isDeletingMessage(true);

      //
      final Either<BaseResponse<bool>, Failure> result =
          await deleteMessageUsecase.call(messageId);

      result.fold((BaseResponse<bool> deletionResponse) async {
        if (deletionResponse.code == 200 && (deletionResponse.data == true)) {
          //
          //
          // notify the function to delete message from list and offline DB
          await _onMessageDeletion(messageId);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });

      _isDeletingMessage(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      _isDeletingMessage(false);
      debugPrint(e.toString());
    }
  }

  _sendVoiceMessage() async {
    if (_recorder.filePath.isEmpty) {
      return;
    }

    final file = File(_recorder.filePath);

    if (!await file.exists()) {
      return;
    }

    final uuid = DateTime.now().millisecondsSinceEpoch.toString();

    String? mimeType;
    if (file.path.endsWith('.mp3')) {
      mimeType = 'audio/mpeg';
    } else if (file.path.endsWith('.wav')) {
      mimeType = 'audio/wav';
    } else if (file.path.endsWith('.m4a')) {
      mimeType = 'audio/mp4';
    } else {
      mimeType = lookupMimeType(file.path);
    }

    // creating media object and configs the object
    final conversationMedia = AttachmentModel();
    conversationMedia.sendedNow = true;
    conversationMedia.sending = true;
    conversationMedia.file = file;
    conversationMedia.mimeType = mimeType;

    /// creating message object in order to add it to messages lis tto show on front end
    final message = ConversationMessageModel(
      model: ConversationUserModel(
          id: int.parse(myId), modelType: authController.user.value?.modelType),
      modelId: int.parse(myId),
      type: MessageTypes.recorded,
      message: richTextController.text.toString().trim(),
      tempId: uuid,
      createdAt: DateTime.now(),
      attachments: [conversationMedia],
    );
    message.sendedNow = true;
    message.duration = _recorder.duration.inSeconds;
    message.replyOn = selectedMessageForReply.value;

    _messagesList.insert(0, message);
    // adding message to list
    if (_messagesList.length > 10) {
      scrollController.scrollTo(
          index: 0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
    }

    /// creating params in order to send to api
    var messageParams = SendFilesMessageParams(
      conversationId: conversationId.toString(),
      message: "",
      tempId: uuid,
      files: [file],
      type: MessageTypes.recorded,
      duration: _recorder.duration.inSeconds,
      progressListener: (progress) {
        // for (var element in messages) {
        //   if (element.tempId == uuid && element.sendedNow) {
        //     if (element.media?.isNotEmpty ?? false) {
        //       element.media![0].progress = progress;
        //     }
        //     break;
        //   }
        // }
      },
      replyOnMessageId: selectedMessageForReply.value?.id,
    );

    selectedMessageForReply.value = null;

    try {
      final response = await sendFileMessageUseCase.call(messageParams);

      response.fold((l) {
        if (l.code == 200 && (l.data?.isNotEmpty ?? false)) {
          // iterating messages list and compare its id with sent message

          for (var element in l.data!) {
            for (int i = (_messagesList.length - 1); i >= 0; i--) {
              if (_messagesList[i].sendedNow &&
                  _messagesList[i].tempId == uuid) {
                _messagesList[i].id = element.id;
                _messagesList[i].sentSuccessfully = true;
                _messagesList.refresh();
                break;
              }
            }
          }
        }

        // for (var element in messages) {
        //   if (element.tempId == uuid && element.sendedNow) {
        //     if (element.media?.isNotEmpty ?? false) {
        //       element.media![0].sending = false;
        //       element.media![0].sendedSuccessfully = true;
        //     }
        //     break;
        //   }
        // }
      }, (r) {
        for (var element in messages) {
          if (element.tempId == uuid && element.sendedNow) {
            if (element.attachments?.isNotEmpty ?? false) {
              element.attachments![0].sending = false;
              element.attachments![0].sendedSuccessfully = false;
              element.attachments![0].downloadProgress = (0.0).obs;
            }
            break;
          }
        }
      });
    } catch (error) {
      for (var element in messages) {
        if (element.tempId == uuid && element.sendedNow) {
          if (element.attachments?.isNotEmpty ?? false) {
            element.attachments![0].sending = false;
            element.attachments![0].sendedSuccessfully = false;
            element.attachments![0].downloadProgress = (0.0).obs;
          }
          break;
        }
      }
    }
  }

  markMessageAsRead(ConversationMessageEntity message) async {
    if (message.id == null ||
        message.deletedAt != null ||
        message.createdAt == null) {
      return;
    }

    if (message.createdAt!.millisecondsSinceEpoch <
        nowDateTime.millisecondsSinceEpoch) {
      return;
    }

    // if i am sender no need to mark as read
    if (message.modelId?.toString() == myId) {
      return;
    }

    // check if api for this already called the no need to call again
    if (_messagesMarkedAsRead.contains(message.id)) {
      return;
    }

    // if active type is group then check if readby  users list contains my id
    // then return to function, no need to call mark as read api again for this user
    if (type == "group") {
      if (message.readBy?.isNotEmpty ?? false) {
        final readByMe = message.readBy!.firstWhereOrNull((element) {
          return element.modelId?.toString() == myId;
        });
        if (readByMe != null) {
          return;
        }
      }
    }
    // else it means its type is one to one then check for the readAt field so
    // if readAt is not null then return else pass it to api call
    else if ((message.readAt != null) && (message.readAt != "null")) {
      return;
    }

    //
    // add message it to list for record so we can check that
    // api for this message is already called
    _messagesMarkedAsRead.add(message.id ?? 0);
    //
    //
    // calling api for message mark as read
    try {
      final result = await messageMarkAsReadUseCase.call(message.id.toString());
      result.fold((readDetails) async {
        try {
          // update the read_at in the chat list
          for (int i = (_messagesList.length - 1); i >= 0; i--) {
            if (_messagesList[i].id == message.id) {
              _messagesList[i].readAt = DateTime.now().toString();
              break;
            }
          }
        } catch (_) {}

        // update the read_at in the offline db also
        try {
          final messageFromDb =
              await messagesDatabase.getMessage(message.id ?? 0);
          if (messageFromDb != null) {
            messageFromDb.readAt = DateTime.now().toString();
            await messagesDatabase.updateMessage(messageFromDb.conversationId!,
                messageFromDb.id!, messageFromDb);
          }
        } catch (_) {}
      }, (Failure r) {
        // print("/////////// faliure in updating message read status.");
      });
    } catch (_) {
      // print("/////////// faliure in updating message read status.");
    }
  }

  sendBuzz(int? messageId) async {
    _isSendingBuzz(true);

    try {
      if (await Vibration.hasVibrator()) {
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: 1000);
        } else {
          Vibration.vibrate();
          await Future.delayed(const Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      }
    } catch (_) {}
    try {
      //
      final Either<BaseResponse<bool>, Failure> result =
          await buzzMessageUseCase.call(
        BuzzMessageParams(
          converstionId: conversationId,
          messageId: messageId,
        ),
      );

      result.fold((BaseResponse<bool> buzzResponse) {
        if (buzzResponse.data ?? false) {
          CommonWidgets.showSnackBar(
            title: 'Buzz',
            message: buzzResponse.message ?? "Buzz sent successfully.",
            isError: false,
          );
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: buzzResponse.message ??
                "Something went wrong while sending buzz.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });

      _isSendingBuzz(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      _isSendingBuzz(false);
      debugPrint(e.toString());
    }
  }

  // bool isMessageEdited(ConversationMessageEntity message) {
  //   if (message.createdAt == null) {
  //     return false;
  //   }
  //   if (message.updatedAt == null) {
  //     return false;
  //   }

  //   final createdAt = message.createdAt!;
  //   final updatedAt = message.updatedAt!;
  //   DateTime? readAt;

  //   try {
  //     readAt = DateTime.parse(message.readAt ?? "");
  //   } catch (_) {}

  //   if (readAt != null) {
  //     Duration difference = readAt.difference(updatedAt);
  //     if (difference.inSeconds > 0) {
  //       return true;
  //     }
  //   } else {
  //     Duration difference = updatedAt.difference(createdAt);
  //     if (difference.inSeconds > 0) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  void toggleEmojiPicker() {
    if (isEmojiPickerVisible.value) {
      focusNode.value.requestFocus();
    } else {
      focusNode.value.unfocus();
    }
    isEmojiPickerVisible.value = !isEmojiPickerVisible.value;
  }

  void showAttachmentBottomSheet(ThemeData theme) {
    MediaPicker.showAttachmentBottomSheet(
      onGalleryPicked: (files) {
        _pickImagesVideos(files);
      },
      onDocumentPicked: (files) {
        _pickDocuments(files);
      },
      onCameraPicked: (file) {
        _openCameraAndCaptureImage(file);
      },
      onAudiosPicked: (files) {
        _pickAudios(files);
      },
      onLocationPicked: () {
        openLocationPickerBottomSheet();
      },
    );
  }

  void showRecodingBottomSheet() async {
    if (!(await PermissionHelper.haveMicPermission(
        "Allow microphone permission in settings to send voice messages."))) {
      return;
    }

    Get.bottomSheet(
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Get.isDarkMode
                    ? AppColorsDark.scaffoldBackroundColor
                    : AppColorsLight.scaffoldBackroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // close button
                GestureDetector(
                  onTap: () {
                    _stopRecording();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColorsLight.mainColor,
                    size: 24,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                AudioWaveforms(
                  size: Size(Get.width * .9, 50),
                  recorderController: _recorder.controller,
                  enableGesture: true,
                  waveStyle: const WaveStyle(
                    waveColor: AppColorsLight.mainColor,
                    showDurationLabel: true,
                    spacing: 8.0,
                    showBottom: true,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),

                SizedBox(
                  height: 50.h,
                ),

                ///  row of options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _stopRecording();
                        Get.back();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _stopRecording();
                        _sendVoiceMessage();
                        Get.back();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColorsLight.mainColor),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 30,
                          )),
                    )
                  ],
                ),
                if (Platform.isIOS)
                  const SizedBox(
                    height: 30,
                  ),
              ],
            ),
          ),
        ),
        isDismissible: false,
        enableDrag: false);

    _startRecording();
  }

  Future<void> _startRecording() async {
    _recorder.startRecording();
    _blink.value = true;
    startBlinking();
  }

  void startBlinking() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _blink.value = !blink;
      // if (_recorder.isRecording) {
      startBlinking();
      // }
    });
  }

  _stopRecording() async {
    await _recorder.stopRecording();
  }

  void _pickDocuments(List<File> files) async {
    if (files.isEmpty) {
      return;
    }

    selectedAttachments.clear();
    for (var file in files) {
      final attachment = AttachmentModel();
      attachment.sendedNow = true;
      attachment.sending = true;
      attachment.file = file;
      attachment.attachmentType = MessageTypes.attachment;
      selectedAttachments.add(attachment);

      updateSendIcon();
    }
  }

  void _pickImagesVideos(List<File> files) async {
    if (files.isEmpty) {
      return;
    }

    selectedAttachments.clear();
    for (var file in files) {
      final mimeType = lookupMimeType(file.path);
      final attachment = AttachmentModel();
      attachment.sendedNow = true;
      attachment.sending = true;
      attachment.file = File(file.path);
      attachment.attachmentType =
          fileExtensionHelper.isImageFile(mimeType ?? "")
              ? MessageTypes.image
              : MessageTypes.attachment;
      attachment.mimeType = mimeType;
      selectedAttachments.add(attachment);
    }
    updateSendIcon();
  }

  void _pickAudios(List<File> files) async {
    if (files.isEmpty) {
      return;
    }

    selectedAttachments.clear();

    for (var file in files) {
      final attachment = AttachmentModel();
      attachment.sendedNow = true;
      attachment.sending = true;
      attachment.file = file;
      attachment.attachmentType = MessageTypes.audio;
      selectedAttachments.add(attachment);
    }
    updateSendIcon();
  }

  Future<void> _openCameraAndCaptureImage(File? file) async {
    if (file == null) {
      return;
    }
    selectedAttachments.clear();
    selectedAttachments.clear();
    final attachment = AttachmentModel();
    attachment.sendedNow = true;
    attachment.sending = true;
    attachment.file = File(file.path);
    attachment.attachmentType = MessageTypes.image;
    selectedAttachments.add(attachment);
    updateSendIcon();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
    return null;
  }

  void openLocationPickerBottomSheet() async {
    await PermissionHelper.haveLocationPermission(
      "Grant location permission in settings to share your location.",
    );

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16,
    );

    showLocationBottomSheet(this);
  }

  String getStaticMapUrl(LocationModel? location) {
    if (location == null || location.lat == null || location.lng == null) {
      return '';
    }

    return "https://maps.googleapis.com/maps/api/staticmap?center=${location.lat},${location.lng}&zoom=16&size=600x300&markers=color:red%7C${location.lat},${location.lng}&key=REPLACE_WITH_GOOGLE_API_KEY";
  }

  sendLocationMessageNew() async {
    try {
      final uuid = DateTime.now().millisecondsSinceEpoch.toString();

      final coords =
          "${cameraPosition.target.latitude},${cameraPosition.target.longitude}";

      // Display message locally
      final message = ConversationMessageModel(
        model: ConversationUserModel(
          id: int.parse(myId),
          image: myImageUrl,
        ),
        modelId: int.parse(myId),
        type: MessageTypes.location,
        message: coords,
        location: LocationModel(
            lat: cameraPosition.target.latitude,
            lng: cameraPosition.target.longitude),
        createdAt: DateTime.now(),
        tempId: uuid,
      );
      message.sendedNow = true;

      _messagesList.insert(0, message);
      if (_messagesList.length > 10) {
        scrollController.scrollTo(
          index: 0,
          duration: const Duration(seconds: 1),
        );
      }

      // Prepare params
      final params = SendTextMessageParams(
        conversationId: conversationId.toString(),
        message: 'Shared Location',
        tempId: uuid,
        type: message.type,
        latitude: cameraPosition.target.latitude,
        longitude: cameraPosition.target.longitude,
      );

      final Either<MessageSentEntity, Failure> result =
          await sendTextMessageUseCase.call(params);

      result.fold((MessageSentEntity messageSentFromRemote) async {
        if (messageSentFromRemote.code == 200 &&
            (messageSentFromRemote.data?.isNotEmpty ?? false)) {
          for (var element in messageSentFromRemote.data!) {
            for (int i = (_messagesList.length - 1); i >= 0; i--) {
              if (_messagesList[i].sendedNow &&
                  _messagesList[i].tempId == uuid) {
                _messagesList[i].id = element.id;
                _messagesList[i].sentSuccessfully = true;
                Get.find<OtoConversationsController>().moveConversationOnTop(
                  conversationId,
                  ConversationLastMessageEntity(
                    id: _messagesList[i].id,
                    message: "📍 Shared Location",
                    type: _messagesList[i].type,
                    modelId: _messagesList[i].modelId,
                    attachments: _messagesList[i].attachments,
                    createdAt: _messagesList[i].createdAt,
                  ),
                  incrementUnread: false,
                );
                _messagesList[i].model =
                    element.model ?? _messagesList[i].model;

                await messagesDatabase.insertMessage(_messagesList[i]);

                _messagesList.refresh();

                break;
              }
            }
          }
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  _setChatListeners() async {
    var messageDataChannel =
        await pusher.subscribeToMessageDataChannel(conversationId.toString());

    //
    //
    // attaching message received event listener
    messageReceivedSubscription =
        messageDataChannel.bind("message-received").listen((event) async {
      if (event.data != null) {
        try {
          final newMessage = newMessageModelFromJson(event.data);
          final convertedMessage =
              newMessage.convertToConversationMessageEntity();

          // if message type is not call log then move conversation to top in converstoin list screen
          if (newMessage.messageData?.type != MessageTypes.callLog) {
            try {
              if (type == "group") {
                if (Get.isRegistered<GroupConversationsController>()) {
                  Get.find<GroupConversationsController>().onNewMessage(
                      conversationId,
                      newMessage.convertToGroupConversationLastMessageEntity());
                }
              } else {
                if (Get.isRegistered<OtoConversationsController>()) {
                  Get.find<OtoConversationsController>().moveConversationOnTop(
                      conversationId,
                      newMessage.convertToConversationLastMessageEntity());
                }
              }
            } catch (_) {}
          }

          // finding old message
          final oldMessage = _messagesList
              .firstWhereOrNull((element) => element.id == convertedMessage.id);

          // checking if message not exists in the array then add it in list and also insert in offline DB
          // else update status in list as well as offline DB
          if (oldMessage == null) {
            if (newMessage.messageData?.modelId != int.parse(myId)) {
              _messagesList.insert(0, convertedMessage);
            } else if (_messagesList.firstWhereOrNull((element) =>
                    (element.id == convertedMessage.id ||
                        (element.tempId ?? "1") ==
                            (convertedMessage.tempId ?? "0"))) ==
                null) {
              _messagesList.insert(0, convertedMessage);
            }
            messagesDatabase.insertMessage(convertedMessage);
          } else {
            oldMessage.message = convertedMessage.message;
            oldMessage.duration = convertedMessage.duration;
            oldMessage.updatedAt = convertedMessage.updatedAt;
            oldMessage.readAt = convertedMessage.readAt;
            oldMessage.isEdited = convertedMessage.isEdited;
            _messagesList.refresh();

            // refreshing in the offline db
            // update the message in the offline db also
            try {
              final messageFromDb =
                  await messagesDatabase.getMessage(convertedMessage.id ?? 0);
              if (messageFromDb != null) {
                messageFromDb.message = convertedMessage.message;
                messageFromDb.duration = convertedMessage.duration;
                messageFromDb.updatedAt = convertedMessage.updatedAt;
                messageFromDb.readAt = convertedMessage.readAt;
                messageFromDb.isEdited = convertedMessage.isEdited;
                await messagesDatabase.updateMessage(
                    messageFromDb.conversationId!,
                    messageFromDb.id!,
                    messageFromDb);
              }
            } catch (_) {}
          }

          //
          //
          //

          // messageDatabase.insertMessage(convertedMessage);
          // if (newMessage.messageData?.modelId != int.parse(myId)) {
          //   _messagesList.insert(0, convertedMessage);
          // } else if (_messagesList.firstWhereOrNull((element) =>
          //         (element.id == convertedMessage.id ||
          //             (element.tempId ?? "1") ==
          //                 (convertedMessage.tempId ?? "0"))) ==
          //     null) {
          //   _messagesList.insert(0, convertedMessage);
          // }
        } catch (_) {}
      }
    });

    //
    //
    // attaching message read event listener
    messageReadSubscription =
        messageDataChannel.bind("message-read").listen((event) async {
      if (event.data != null) {
        try {
          final jsonData = jsonDecode(event.data);
          // if type is single then update single message
          if (jsonData['type'] == "single") {
            final messageData = jsonData['message'];

            // update the read_at in the chat list
            for (int i = (_messagesList.length - 1); i >= 0; i--) {
              if (_messagesList[i].id == messageData['id'] ||
                  (_messagesList[i].tempId ?? "0") ==
                      (messageData['temp_id'] ?? "1")) {
                if (type == "group") {
                  if (_messagesList[i].readBy == null) {
                    _messagesList[i].readBy = [];
                  }
                  _messagesList[i].readBy?.add(ReadByModel(
                        readByUser:
                            ReadByUserModel.fromJson(jsonData['read_by']),
                        messageId: messageData['id'],
                        createdAt: DateTime.now(),
                      ));
                } else {
                  _messagesList[i].readAt =
                      messageData['read_at'] ?? DateTime.now().toString();
                }
                _messagesList.refresh();
                break;
              }
            }

            // update the read_at in the offline db also
            try {
              final messageFromDb =
                  await messagesDatabase.getMessage(messageData['id']);
              if (messageFromDb != null) {
                messageFromDb.readAt = messageData['read_at'];
                messageFromDb.readBy ??= [];
                messageFromDb.readBy?.add(ReadByModel(
                  readByUser: ReadByUserModel.fromJson(jsonData['read_by']),
                  messageId: messageData['id'],
                  createdAt: DateTime.now(),
                ));
                await messagesDatabase.updateMessage(
                    messageFromDb.conversationId!,
                    messageFromDb.id!,
                    messageFromDb);
              }
            } catch (_) {}
          } else if (jsonData['type'] == "bulk") {
            // update the read_at in the chat list
            for (int i = (_messagesList.length - 1); i >= 0; i--) {
              if (_messagesList[i].readAt == null ||
                  _messagesList[i].readAt == "null") {
                _messagesList[i].readAt = DateTime.now().toString();
              }
            }
            _messagesList.refresh();
          }
        } catch (_) {}
      }
    });

    //
    //
    // attaching a typing event listener
    typingSubscription =
        messageDataChannel.bind("client-typing").listen((event) {
      if (event.data != null) {
        if (type == "group") {
          try {
            final typingUser = ConversationTypingModel.fromJson(event.data);
            typingMessage = "${typingUser.user?.firstName} is typing...";
            _isTyping(true);
            Future.delayed(const Duration(seconds: 2), () {
              _isTyping(false);
            });
          } catch (_) {}
        } else {
          typingMessage = "typing...";
          _isTyping(true);
          Future.delayed(const Duration(seconds: 2), () {
            _isTyping(false);
          });
        }
      }
    });

    //
    //
    // attaching a message reaction event listener
    messageReactionSubscription =
        messageDataChannel.bind("message-reaction").listen((event) {
      if (event.data != null) {
        try {
          final jsonData = jsonDecode(event.data);
          final messageId = jsonData['message_id'];
          final reaction = MessageReactionModel.fromJson(jsonData);

          // if pid in reaction not null and reacted by current user then skip
          if ((reaction.pId == getMyPid()) && (reaction.pId != null)) {
            return;
          }

          // find message
          final message = _messagesList.firstWhereOrNull((element) =>
              (element.id?.toString() == messageId.toString()) &&
              (element.id != null));

          if (message != null) {
            _onMessageReaction(message, reaction);
          }
        } catch (_) {}
      }
    });

    //
    //
    // attaching a message deletion event listener
    messageDeletionSubscription =
        messageDataChannel.bind("message-deleted").listen((event) async {
      if (event.data != null) {
        try {
          final jsonData = jsonDecode(event.data);
          final messageId = jsonData['message_id'];
          final id = int.parse(messageId.toString());
          await _onMessageDeletion(id);
        } catch (_) {}
      }
    });
  }

  getChatDetails() async {
    try {
      _isLoadingChatDetails(true);
      final Either<ConversationDetailsEntity, Failure> result =
          await getConversationDetailsUseCase.call(conversationId.toString());
      _isLoadingChatDetails(false);
      result.fold((ConversationDetailsEntity conversationDetialsFromRemote) {
        conversationDetails.value = conversationDetialsFromRemote;

        try {
          if (conversationDetialsFromRemote.type == "group") {
            if ((conversationDetialsFromRemote.groupName ?? "").isNotEmpty) {
              groupName = conversationDetialsFromRemote.groupName ?? "";
            }
            if (conversationDetialsFromRemote.participants?.isNotEmpty ??
                false) {
              userPhone.value = conversationDetialsFromRemote.participants!
                  .map((e) =>
                      e.id.toString() == myId.toString() ? "You" : e.name)
                  .toString()
                  .replaceAll('(', "")
                  .replaceAll(')', "");
            }
          } else {
            if ((conversationDetialsFromRemote.receiver?.name ?? "")
                .isNotEmpty) {
              userName.value =
                  conversationDetialsFromRemote.receiver?.name ?? "";
            }
          }
        } catch (_) {}

        // filering new messages
        final newMessages = conversationDetialsFromRemote.messages ?? [];

        if (newMessages.isNotEmpty) {
          _messagesList.clear();
          _messagesList.addAll(newMessages);

          messageSyncer.syncMessages(messages: newMessages);
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
      _isLoadingChatDetails(false);
    }
  }

  loadPreviousMessagesFromDB(int lastMessageId) async {
    if (_isLoadingPreviousMessagesFromDB.value || noMoreMessages) {
      return;
    }

    try {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromDB(true);
      });

      await Future.delayed(const Duration(seconds: 5));
      final oldMessages = await messagesDatabase.getPreviousMessages(
        conversationId,
        lastMessageId,
      );

      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromDB(false);
      });

      if (oldMessages.isNotEmpty) {
        _messagesList.addAll(oldMessages);
        _passThroughSearchIfEnabled(oldMessages);
      } else {
        loadPreviousMessagesFromApi(lastMessageId);
      }
    } catch (_) {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromDB(false);
      });
      loadPreviousMessagesFromApi(lastMessageId);
    }
  }

  loadPreviousMessagesFromApi(int? lastMessageId) async {
    try {
      if (_isLoadingPreviousMessagesFromApi.value || noMoreMessages) {
        return;
      }

      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromApi(true);
      });

      // calling api and getting previous messages response
      final Either<List<ConversationMessageEntity>, Failure> result =
          await getPreviousMessagesUseCase.call(GetPreviousMessagesParams(
              conversationId: conversationId.toString(),
              lastMessageId: lastMessageId.toString()));

      // setting loading state to false
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromApi(false);
      });

      // folding response of the api
      result.fold((List<ConversationMessageEntity> previousMessages) {
        // filering new messages
        if (previousMessages.isNotEmpty) {
          _messagesList.addAll(previousMessages);
          messagesDatabase.insertMessages(previousMessages);
          _passThroughSearchIfEnabled(previousMessages);
        } else {
          noMoreMessages = true;
        }
        _messagesList.refresh();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        WidgetsFlutterBinding.ensureInitialized()
            .addPostFrameCallback((duration) {
          _isLoadingPreviousMessagesFromApi(false);
        });
        noMoreMessages = true;
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((duration) {
        _isLoadingPreviousMessagesFromApi(false);
      });
      noMoreMessages = true;
    }
  }

//
  /// make sure call this function after adding messages to _messagesList and pass
  ///  recently added messages to this function
  _passThroughSearchIfEnabled(List<ConversationMessageEntity> messagesList) {
    if (searchController.text.isNotEmpty && messagesList.isNotEmpty) {
      final searchedMessagesIds = _findSearchedMessagesIds(messagesList);
      if (searchedMessagesIds.isNotEmpty) {
        // checking that search was empty before this search
        final searchWasEmpty = indexesOfSearchedMessages.isEmpty;
        for (var id in searchedMessagesIds) {
          final index = messages.indexWhere((message) => message.id == id);
          if (index >= 0 && (!indexesOfSearchedMessages.contains(index))) {
            indexesOfSearchedMessages.add(index);
          }
        }
        indexesOfSearchedMessages.refresh();

        // check if now search is not empty but was empty before
        // then scroll to searched index
        if (indexesOfSearchedMessages.isNotEmpty && searchWasEmpty) {
          scrollController.scrollTo(
            index: indexesOfSearchedMessages.first,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
          _currentScrolledIndexOfSearchedMessage.value = 0;
          currentSearchedIndex.value = indexesOfSearchedMessages[0];
        }
      } else if (messagesList.last.id != null) {
        loadPreviousMessagesFromDB(messagesList.last.id!);
      }
    }
  }

  _removeParticipant(ConversationWithParticipentEntity participant) async {
    if (_isRemovingParticipant.value) {
      return;
    }

    // call add participant api
    try {
      _isRemovingParticipant(true);
      final Either<RemoveParticipantsEntity, Failure> result =
          await removeParticipantsUseCase.call(participant.pId!);

      _isRemovingParticipant(false);

      result.fold((RemoveParticipantsEntity addParticipantResponse) {
        if (addParticipantResponse.error == false &&
            addParticipantResponse.code == 200) {
          // closing add participants bottom sheet and clearing states

          CommonWidgets.showSnackBar(
              title: 'Successful',
              message: addParticipantResponse.message ??
                  "Participants added successfully.",
              isError: false);

          try {
            // getChatDetails();
            if (conversationDetails.value != null) {
              conversationDetails.value!.participants?.remove(participant);

              //
              userPhone.value =
                  conversationDetails.value!.participants?.map((e) {
                        return e.name;
                      }).toString() ??
                      "";

              conversationDetails.refresh();
            }
          } catch (_) {}

          //
          // notify converstions controller that particiant removed
          try {
            if (Get.isRegistered<GroupConversationsController>() &&
                (groupId.value != null)) {
              final converstionController =
                  Get.find<GroupConversationsController>();
              converstionController.onParticipantRemoved(
                groupId.value!,
                participant.id,
                modelTypeValues.map[participant.modelType],
              );
            }
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

  showParticipantsBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: AppColorsLight.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const ParticipantsBottomSheet();
      },
    );
  }

  showRemoveParticipantConfirmationDialog(
      ConversationWithParticipentEntity participantId,
      String name,
      int index,
      ThemeData theme) {
    //

    Get.defaultDialog(
      title: 'Remove Participnat',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColorsLight.mainColor,
      ),
      titlePadding: EdgeInsets.only(top: 10.h),
      content: ConfirmationDialog(
        message: 'Are you sure you want to remove $name?',
        confirmationText: "Remove",
        cancelText: "Dismiss",
        onConfirmation: () async {
          Get.back();
          removingAtIndex = index;
          await _removeParticipant(participantId);
          removingAtIndex = -1;
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );
  }

  onParticipantAdded(int groupId) {
    if (groupId == this.groupId.value) {
      getChatDetails();
    }
  }

  updateParticipant(
      ConversationWithParticipentEntity participant, int index) async {
    //
    if (isUpdatingParticipant) {
      return;
    }

    updatingParticipantAtIndex = index;

    // call update participant api
    try {
      _isUpdatingParticipant(true);
      final Either<BaseResponse<bool>, Failure> result =
          await updateParticipantsUseCase.call(UpdateParticipantParams(
              conversationId: conversationId,
              pid: participant.pId!,
              isGroupAdmin: participant.isGroupAdmin!));

      _isUpdatingParticipant(false);

      result.fold((BaseResponse<bool> updateResponse) {
        if (updateResponse.data ?? false) {
          conversationDetails.refresh();

          //
          // notify converstions controller that particiant updated
          try {
            if (Get.isRegistered<GroupConversationsController>() &&
                (groupId.value != null)) {
              final conversationController =
                  Get.find<GroupConversationsController>();
              conversationController.onParticipantPermissionsUpdated(
                groupId.value!,
                ParticipantEntity.createFrom(
                  conversationWithParticipentEntity: participant,
                ),
              );
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

  checkForImageInIosClipboard() async {
    if (!haveImageInClipBoard.value) {
      final result = await IosClipboardService().getImageFromClipboard();
      if (result != null) {
        haveImageInClipBoard(true);
      } else {
        haveImageInClipBoard(false);
      }
    }
  }

  attachFileFromClipboard() async {
    if (Platform.isIOS) {
      final result = await IosClipboardService().getImageFromClipboard();
      if (result != null) {
        haveImageInClipBoard(false);

        selectedAttachments.clear();
        final image = File.fromRawPath(result);

        final tempDir = await getTemporaryDirectory();
        File file =
            await File('${tempDir.path}/${DateTime.now().toString()}.png')
                .create();
        file.writeAsBytesSync(result);

        // ignore: unnecessary_null_comparison
        if (image != null) {
          final croppedImage = await ImageHelper.cropProcess(file, [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5
          ]);

          if (croppedImage == null) {
            return;
          }
          selectedAttachments.clear();
          final attachment = AttachmentModel();
          attachment.sendedNow = true;
          attachment.sending = true;
          attachment.file = File(croppedImage.path);
          attachment.attachmentType = MessageTypes.image;
          selectedAttachments.add(attachment);
          updateSendIcon();
        }
      }
    }
  }

  bool isMessageEditable() {
    if (selectedMessages.length != 1) {
      return false;
    }

    final message = _messagesList
        .firstWhereOrNull((element) => element.id == selectedMessages.first);

    if (message?.message?.isEmpty ?? true) {
      return false;
    }

    return ((message!.model?.id == authController.user.value?.id) &&
        (message.model?.modelType == authController.user.value?.modelType) &&
        (message.type != MessageTypes.callLog) &&
        durationIsLessThan5Mins(message.createdAt));
  }

  bool isMessageDeletable() {
    if (selectedMessages.length != 1) {
      return false;
    }

    final message = _messagesList
        .firstWhereOrNull((element) => element.id == selectedMessages.first);

    return ((message!.model?.id == authController.user.value?.id) &&
        (message.model?.modelType == authController.user.value?.modelType) &&
        (message.type != MessageTypes.callLog) &&
        durationIsLessThan5Mins(message.createdAt));
  }

  bool durationIsLessThan5Mins(DateTime? createdAt) {
    if (createdAt == null) {
      return false;
    }

    Duration difference = DateTime.now().difference(createdAt);
    return (difference.inSeconds < 300);
  }

  Future<bool> hasEnoughPermissions(AgoraCallType callType) async {
    // Microphone is required for every call type.
    bool micStatus = await PermissionHelper.haveMicPermission(
        "Grant microphone permission in settings to make a call.");

    if (!micStatus) {
      return false;
    }

    // Camera is only required for video calls.
    if (callType == AgoraCallType.video) {
      bool cameraStatus = await PermissionHelper.haveCameraPermission(
          "Grant camera permission in settings to make a video call.");

      return cameraStatus;
    }

    return true;
  }

  placeCall(AgoraCallType callType) async {
    if (isPlacingCaling) {
      return;
    }
    if (!(await hasEnoughPermissions(callType))) {
      Get.snackbar(
          'Permissions Required',
          callType == AgoraCallType.video
              ? 'In order to make a video call, please grant camera and microphone permissions.'
              : 'In order to make a call, please grant microphone permission.');
      return;
    }

    _isPlacingCaling.value = true;
    await _placeCallInNativeLayer(callType);
    _isPlacingCaling.value = false;
    return;
  }

  _placeCallInNativeLayer(AgoraCallType callType) async {
    //
    // check can we start call in native layer
    if (!(await NativeCallingMethodChannel.canStartCall())) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message:
            "You can't start a new call. When one call is already in process.",
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

    //
    //
    // emitting event for call
    try {
      final response = await callEventUsecase.call(
        CallEventParam(
          eventName: AgoraCallEvents.incommingCall,
          eventDetails: {
            'conversationId': conversationId,
            'callType': callType == AgoraCallType.video ? "video" : 'audio',
          },
        ),
      );

      //
      //
      // check if response successful then start call at native layer
      // else show errors
      response.fold((CallEventEntity data) async {
        if (data.callPayload != null && data.error == false) {
          //
          // adding receiver name in payload, as needed in native layer
          final notificationPayload = data.callPayload!.toJson();
          notificationPayload["receiverName"] =
              type == "group" ? groupName : userName.value;

          //
          // calling method channel function
          final result =
              await NativeCallingMethodChannel.placeCall(notificationPayload);

          debugPrint("result from placing native call is ===> $result");
          //
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error', message: data.message ?? 'Something went wrong.');
        }
      }, (r) {
        CommonWidgets.showSnackBar(title: 'Error', message: r.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error', message: 'Something went wrong.');
    }
  }

  openAddParticipantsBottomSheet(int groupId) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor:
          Get.isDarkMode ? AppColorsDark.bodyBackgroundColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return AddParticipantsBottomSheetView(
          groupId: groupId,
        );
      },
    );
  }

  selectMessage(ConversationMessageEntity message) {
    if (message.id == null || message.deletedAt != null) {
      return;
    }
    if (isMessageSelectionEnabled) {
      if (selectedMessages.contains(message.id)) {
        selectedMessages.remove(message.id);
        _isMessageSelectionEnabled(selectedMessages.isNotEmpty);
      } else if (selectedMessages.length < 5) {
        selectedMessages.add(message.id!);
      }
    } else {
      selectedMessages.clear();
      _isMessageSelectionEnabled(true);
      selectedMessages.add(message.id!);

      try {
        final index = messages.indexOf(message);
        if (index >= 0) {
          _showMessageReactionDialog(message, index);
        }
      } catch (_) {}
    }
  }

  _showMessageReactionDialog(ConversationMessageEntity message, index) {
    final context = Get.context;

    if (context == null) {
      return;
    }

    List<ReactionsMenuItem> menuItems = [
      ReactionsData.reply,
      ReactionsData.copy,
      ReactionsMenuItem(
        id: 5,
        label: 'Forward',
        icon: Icons.forward_rounded,
        customIcon: Transform.flip(
          flipX: true,
          child: Icon(
            Icons.reply_rounded,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            size: 24,
          ),
        ),
      ),
    ];

    if (isMessageEditable()) {
      menuItems.add(ReactionsData.edit);
    }

    if (isMessageDeletable()) {
      menuItems.add(ReactionsData.delete);
    }

    if ((message.model?.id == authController.user.value?.id) &&
        (message.model?.modelType == authController.user.value?.modelType)) {
      menuItems.add(ReactionsData.buzz);
    }

    if (((selectedMessages.length == 1) &&
        (messages.firstWhereOrNull((element) =>
                ((element.id == selectedMessages[0]) &&
                    (element.modelId.toString()) == myId)) !=
            null) &&
        (type == "group"))) {
      menuItems.add(ReactionsData.info);
    }

    Navigator.of(context).push(RaectionsDialogRoute(
      fullscreenDialog: true,
      builder: (context) {
        return ReactionsDialogWidget(
          menuItems: menuItems,
          menuItemsWidth: 0.65,
          menuItemsPadding: const EdgeInsets.all(10),
          widgetAlignment: message.modelId.toString() == myId
              ? Alignment.centerRight
              : Alignment.centerLeft,
          id: message.id!.toString(), // unique id for message
          messageWidget: message.modelId.toString() == myId
              ? Material(
                  color: Colors.transparent,
                  child: MessageSenderView(
                    message: message,
                    index: index,
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: MessageReciverView(
                    message: message,
                    index: index,
                  ).marginSymmetric(horizontal: 5),
                ), // message widget
          onReactionTap: (reaction) {
            // add reaction to message
            _reactOnMessage(message, reaction);
            _clearMessageSelection();
          },
          onContextMenuTap: (menuItem) {
            switch (menuItem.id) {
              case 1:
                //reply
                selectedMessageForReply.value = message;
                _clearMessageSelection();
                break;

              case 2:
                //copy
                copyMessage();
                break;

              case 3:
                // delete
                if (isMessageDeletable()) {
                  deleteMessageClicked();
                }
                break;

              case 4:

                //edit
                if (isMessageEditable()) {
                  editMessageClicked();
                }
                break;

              case 5:
                //forward
                forwardMessage();
                break;

              case 6:
                //info
                showMessageInfo();
                break;

              case 7:
                //info
                sendBuzz(message.id);
                _clearMessageSelection();
                break;
            }
          },
        );
      },
    ));
  }

  _clearMessageSelection() {
    selectedMessages.clear();
    _isMessageSelectionEnabled(false);
  }

  copyMessage() {
    if (!isMessageSelectionEnabled) {
      return;
    }
    if (selectedMessages.isEmpty) {
      return;
    }
    ClipboardHelper.copyPlainText(messages
            .firstWhereOrNull((element) => element.id == selectedMessages[0])
            ?.message ??
        "");
    //
    // reset themessage selection states
    _isMessageSelectionEnabled(false);
    selectedMessages.clear();
  }

  forwardMessage() async {
    if (!isMessageSelectionEnabled) {
      return;
    }
    if (selectedMessages.isEmpty) {
      return;
    }
    final messagesToForward = messages
        .where((element) =>
            selectedMessages.contains(element.id) && (element.id != null))
        .toList();

    try {
      messagesToForward.sort((a, b) {
        DateTime? aDate = a.createdAt;
        DateTime? bDate = b.createdAt;

        if (aDate == null && bDate != null) {
          return 1;
        } else if (bDate == null && aDate != null) {
          return -1;
        } else if (bDate == null && aDate == null) {
          return 0;
        } else {
          return aDate!.compareTo(bDate!);
        }
      });
    } catch (_) {}

    // navigate to forward message screen
    if (messagesToForward.isNotEmpty) {
      await Get.toNamed(Routes.FORWARD_MESSAGE, arguments: messagesToForward);
    }

    //
    // reset the message selection states
    _isMessageSelectionEnabled(false);
    selectedMessages.clear();
  }

  editMessageClicked() async {
    if (!isMessageSelectionEnabled) {
      return;
    }
    if (selectedMessages.isEmpty) {
      return;
    }
    final message = messages
        .firstWhereOrNull((element) => element.id == selectedMessages[0]);

    if (message == null) {
      return;
    }

    if (message.type == MessageTypes.callLog) {
      return;
    }

    if (message.message == null) {
      return;
    }

    Get.dialog(
      EditMessageDialog(message: message),
    );

    //
    // reset the message selection states
    _isMessageSelectionEnabled(false);
    selectedMessages.clear();
  }

  deleteMessageClicked() async {
    if (!isMessageSelectionEnabled) {
      return;
    }
    if (selectedMessages.isEmpty) {
      return;
    }
    final message = messages
        .firstWhereOrNull((element) => element.id == selectedMessages[0]);

    if (message == null) {
      return;
    }

    if (message.type == MessageTypes.callLog) {
      return;
    }

    //
    //
    // show delete emssage confirmation dialog
    await showDeleteMessageConfirmationDialog(message.id!);
  }

  showDeleteMessageConfirmationDialog(int messageId) async {
    //
    await Get.defaultDialog(
      title: 'Delete Message',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: DeleteMessageConfirmationDialog(
        onDeleteCalled: () async {
          //
          // hit api for delete
          await deleteMessage(messageId);
          Get.back();
        },
        onCancelCalled: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );

    //
    // reset the message selection states
    _isMessageSelectionEnabled(false);
    selectedMessages.clear();
  }

  //
  //
  /// This function will handle the buzz logic,
  onBuzzReceived(BuzzMessageParams buzzMessageParams) async {
    if (buzzMessageParams.converstionId == conversationId) {
      buzzOnMessageId.value = buzzMessageParams.messageId;

      if (buzzOnMessageId.value != null) {
        await scrollToRepliedMessage(buzzOnMessageId.value);
      }
      _receivedBuzz.value = true;

      Future.delayed(const Duration(seconds: 3), () {
        _receivedBuzz.value = false;
        buzzOnMessageId.value = null;
      });
    }
  }

  showMessageInfo() {
    if (!isMessageSelectionEnabled) {
      return;
    }
    if (selectedMessages.isEmpty) {
      return;
    }

    // find message and show message read by list
    final message = messages
        .firstWhereOrNull((element) => element.id == selectedMessages[0]);
    if (message != null) {
      _showMessageReadByBottomSheet(message);
    }
    //
    // reset themessage selection states
    _isMessageSelectionEnabled(false);
    selectedMessages.clear();
  }

  showMessageInfoOnSwipe(int messageId) {
    // find message and show message read by list
    final message =
        messages.firstWhereOrNull((element) => element.id == messageId);
    if (message != null) {
      _showMessageReadByBottomSheet(message);
    }
  }

  _showMessageReadByBottomSheet(ConversationMessageEntity message) {
    //
    ConversationsController? conversationsController;
    if (Get.isRegistered<ConversationsController>()) {
      conversationsController = Get.find<ConversationsController>();
    }

    if ((message.readBy?.isNotEmpty) ?? false) {
      for (var item in message.readBy!) {
        //
        if (item.readByUser == null) {
          //
          // finding participant profile
          final participant = conversationDetails.value?.participants
              ?.firstWhereOrNull((element) {
            final pidMatched =
                ((item.pid != null) && (element.pId == item.pid));
            final idMatched = ((item.id != null) && (element.id == item.id));
            final modelTypeMatched = ((item.modelType != null) &&
                (element.modelType == item.modelType));
            return (pidMatched || (idMatched && modelTypeMatched));
          });

          //
          // if participant profile found the add it to the list
          if (participant != null) {
            item.readByUser = ReadByUserModel(
              id: participant.id,
              phone: participant.phone,
              name: participant.name,
              image: participant.image,
              modelType: participant.modelType,
              userDesignation: participant.userDesignation,
            );
          }
        }
      }
    }

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: AppColorsLight.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        final ThemeData theme = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 50,
              decoration: const BoxDecoration(
                color: AppColorsLight.mainColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Row(children: [
                const Text(
                  "Read By",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ]),
            ),

            (message.readBy?.isNotEmpty ?? false)
                ? Container(
                    color: theme.scaffoldBackgroundColor,
                    constraints: BoxConstraints(maxHeight: Get.height * 0.80),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: message.readBy!.length,
                        itemBuilder: (context, index) {
                          final readBy = message.readBy![index];
                          return Container(
                            margin: index == 0
                                ? const EdgeInsets.only(
                                    left: 1, right: 1, top: 14)
                                : index == (message.readBy!.length - 1)
                                    ? const EdgeInsets.only(
                                        left: 1, right: 1, bottom: 14)
                                    : const EdgeInsets.symmetric(horizontal: 1),
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          readBy.readByUser?.image ??
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                                          width: 45,
                                          height: 45,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU"),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: (conversationsController
                                                    ?.isUserOnline(readBy.id,
                                                        readBy.modelType) ??
                                                false)
                                            ? AppColorsLight.onlineColor
                                            : AppColorsLight.offlineColor,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        readBy.readByUser?.name ?? "",
                                        style: theme.textTheme.bodyLarge,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        readBy.readByUser?.userDesignation ??
                                            ((readBy.readByUser?.modelType ??
                                                        "users") ==
                                                    "users"
                                                ? "Admin"
                                                : "Driver"),
                                        style: theme.textTheme.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('d-MMMM-yyyy').format(
                                          readBy.createdAt ?? DateTime.now()),
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      DateFormat('h:mm a').format(
                                          readBy.createdAt ?? DateTime.now()),
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Row(
                            children: [
                              SizedBox(
                                width: 62,
                              ),
                              Expanded(
                                child: Divider(
                                  height: 0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                : Container(
                    width: double.infinity,
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        const Text(
                          "No member read this message.",
                          style: TextStyle(
                              color: AppColorsLight.mainColor, fontSize: 16),
                        ).paddingOnly(top: 50),
                        const SizedBox(
                          height: 50,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }

  void onImageClicked(String? url, File? file) {
    final images = messages
        .where(
      (e) =>
          (e.type == MessageTypes.image) &&
          (e.attachments?.isNotEmpty ?? false) &&
          ((e.attachments?[0].url != null) || (e.attachments?[0].file != null)),
    )
        .map(
      (e) {
        return PreviewImage(
          url: e.attachments?.firstOrNull?.url,
          file: e.attachments?.firstOrNull?.file,
        );
      },
    ).toList();

    int initailIndex = 0;
    if (url != null || file != null) {
      final foundIndex = images.indexOf(PreviewImage(url: url, file: file));
      if (foundIndex >= 0 && foundIndex < images.length) {
        initailIndex = foundIndex;
      }
    }

    Get.to(
      ChatImagePreview(
        title: userName.value,
        previewImages: images,
        initialIndex: initailIndex,
      ),
    );
  }

  String getCallText(int? callPlacedBy, String event, int? duration) {
    //
    if (type == "group") {
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

  int? getMyPid() {
    return conversationDetails.value?.participants
        ?.firstWhereOrNull((element) =>
            element.id?.toString() == myId && element.modelType == "users")
        ?.pId;
  }

  _reactOnMessage(ConversationMessageEntity message, String reaction) async {
    try {
      //

      final myPid = getMyPid();

      if (myPid == null) {
        return;
      }

      final response = await reactMessageUseCase.call(ReactMessageParams(
          messageId: message.id!, participantId: myPid, reaction: reaction));

      response.fold((l) {
        if (l.data == true) {
          //
          //
          // on reaction success
          try {
            _onMessageReaction(
                message, MessageReactionModel(pId: myPid, reaction: reaction));
          } catch (_) {}
        } else {
          CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: l.message?.toString() ??
                  "Something went wrong with message reaction.",
              isError: false);
        }
      }, (r) {
        CommonWidgets.showSnackBar(
            title: 'Error'.tr, message: r.message.toString(), isError: false);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
          title: 'Error'.tr, message: e.toString(), isError: false);
    }
  }

  _onMessageReaction(
      ConversationMessageEntity message, MessageReactionEntity reaction) async {
    if (message.reactions?.isEmpty ?? true) {
      message.reactions = [reaction];
    } else {
      final oldReaction = message.reactions!
          .firstWhereOrNull((element) => element.pId == reaction.pId);

      if (oldReaction != null) {
        oldReaction.reaction = reaction.reaction;
      } else {
        message.reactions!.add(reaction);
      }
    }

    _messagesList.refresh();

    //
    //
    // update message reactions in db
    try {
      final messageFromDb = await messagesDatabase.getMessage(message.id ?? 0);
      if (messageFromDb != null) {
        messageFromDb.reactions = message.reactions;
        await messagesDatabase.updateMessage(
            messageFromDb.conversationId!, messageFromDb.id!, messageFromDb);
      }
    } catch (_) {}
  }

  _onMessageDeletion(int messageId) async {
    //
    //
    // remove message from list
    try {
      _messagesList
          .firstWhereOrNull((message) => message.id == messageId)
          ?.deletedAt = DateTime.now();
      _messagesList.refresh();
    } catch (_) {}

    //
    //
    // update message in offline DB
    try {
      try {
        final messageFromDb = await messagesDatabase.getMessage(messageId);
        if (messageFromDb != null) {
          messageFromDb.message = "";
          messageFromDb.attachments = [];
          messageFromDb.deletedAt = DateTime.now();
          messageFromDb.updatedAt = DateTime.now();
          await messagesDatabase.updateMessage(
            messageFromDb.conversationId!,
            messageFromDb.id!,
            messageFromDb,
          );
        }
      } catch (_) {}
    } catch (_) {}

    //
    //
    // if deleted message was last message of conversation then
    // notify coversations listing
    try {
      if (type == "group") {
        if (Get.isRegistered<GroupConversationsController>()) {
          Get.find<GroupConversationsController>()
              .onMessageDelete(conversationId, messageId);
        }
      } else {
        if (Get.isRegistered<OtoConversationsController>()) {
          Get.find<OtoConversationsController>()
              .onMessageDelete(conversationId, messageId);
        }
      }
    } catch (_) {}
  }

  /// Generate a random 6-digit number
  int generateUid() {
    Random random = Random();
    int min = 100000;
    int max = 999999;
    int randomSixDigitNumber = min + random.nextInt(max - min);
    return randomSixDigitNumber;
  }

  showMessageReactionBottomSheet(ConversationMessageEntity message) {
    if (message.reactions?.isEmpty ?? true) {
      return;
    }

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: AppColorsLight.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return MessageReactionsBottomSheet(message: message);
      },
    );
  }

  shareAndExportAudioMessage(
      ConversationMessageEntity message, String action) async {
    try {
      if (action != "share" && action != "download") {
        return;
      }
      if (message.attachments?.isNotEmpty ?? false) {
        final attachment = message.attachments!.first;
        String? filePath;

        // fetching file path from existing file from local storage
        // or downloading from url if exist
        if (attachment.file != null) {
          filePath = attachment.file!.path;
        } else {
          filePath = await Get.find<ChatAudiosManager>().getAudioFile(
            message.attachments![0].url ?? "",
            onReceiveProgress: (received, total) {
              attachment.isDownloading.value = true;
              attachment.downloadProgress.value = (received / total);
            },
          );
          attachment.isDownloading.value = false;
        }

        // if filepath not null then fetch file name and mimetype from it
        // and pass it to share class for sharing and exporting
        if (filePath != null) {
          final fileName = fileExtensionHelper.getFileName(
            filePath,
            withExtension: true,
          );

          if (action == "share") {
            await Share.shareXFiles(
              [
                XFile(
                  filePath,
                  mimeType: lookupMimeType(filePath),
                  name: fileName,
                )
              ],
              subject: fileName,
            );
          } else if (action == "download") {
            await FilePicker.platform.saveFile(
              dialogTitle: 'Exporting Audio Message',
              fileName: fileName,
              type: FileType.audio,
              bytes: await File(filePath).readAsBytes(),
            );
          }
        }
      }
    } catch (_) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong while exporting audio.",
      );
    }
  }

  clearControllerValue() {
    messageReceivedSubscription?.cancel();
    messageReadSubscription?.cancel();
    typingSubscription?.cancel();
    messageReactionSubscription?.cancel();
    messageDeletionSubscription?.cancel();
    pusher.unsubscribeActiveCountChannel();
    pusher.unsubscribeMessageDataChannel();
    _recorder.dispose();
    // textEditingController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void onClose() async {
    clearControllerValue();
    richTextController.dispose();
    lastMention.dispose();
    messageSyncer.dispose();

    // setting conversation and group conversations unread count to zero
    try {
      if (type == "group") {
        if (Get.isRegistered<GroupConversationsController>()) {
          Get.find<GroupConversationsController>()
              .resetUnreadCount(conversationId);
        }
      } else {
        if (Get.isRegistered<OtoConversationsController>()) {
          Get.find<OtoConversationsController>()
              .setConversationUnreadCountToZero(conversationId);
        }
      }
    } catch (_) {}
    super.onClose();
  }
}

/// Enums to indicate the call type
enum AgoraCallType { none, audio, video }

/// Defined event names for the notifying caller and reciver
/// Also used in a natice code for updating call status like ringing, canceled, busy.
class AgoraCallEvents {
  static const incommingCall = 'incomming-call';
  static const incommingCallDeclined = 'incomming-call-declined';
  static const callAccepted = 'call-accepted';
  static const callDeclined = 'call-declined';
  static const callEnded = 'call-ended';
  static const userBueasy = 'user-bueasy';
  static const callRinging = 'call-ringing';
  static const noAnswer = 'no-answer';
}

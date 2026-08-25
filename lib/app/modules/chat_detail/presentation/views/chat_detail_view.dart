import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ts_admin/app/core/helpers/image_matrixes.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/screens/base_screen.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/data/models/chat_theme_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/app_bar_components/call_action_icons.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/buzz_components/conversation_buzz_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_main_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/suggestions_components/chat_suggestions_view.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import '../controllers/chat_detail_controller.dart';
import 'components/body_components/chat_input_field.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

part './components/body_components/search_buttons_view.dart';
part './components/app_bar_components/message_action_icons.dart';
part './components/app_bar_components/search_action_icon.dart';
part './components/app_bar_components/chat_app_bar_title.dart';
part './components/body_components/mentions_selection_list_view.dart';
part './components/body_components/syncing_messages_indication.dart';
part 'components/body_components/chat_background_view..dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    // change status bar color manually for this page only
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Get.isDarkMode ? AppColorsDark.mainColor : AppColorsLight.mainColor,
      ),
    );

    // getting theme data
    final ThemeData theme = Theme.of(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: Container(
        color:
            Get.isDarkMode ? AppColorsDark.mainColor : AppColorsLight.mainColor,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: BaseScreen(
              child: Scaffold(
                // backgroundColor: AppColors.kMainColor,
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor:
                      Get.isDarkMode ? theme.primaryColor : Colors.white,
                  toolbarHeight: 55.h,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () {
                      Get.back(result: true);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  titleSpacing: 0,
                  title: const _ChatAppBarTitle(),
                  actions: [
                    //
                    //
                    //search option
                    const _SearchMessagesActionIcon().marginOnly(right: 15),

                    //
                    //
                    //calling options
                    const CallActionIcons(),
                    //
                    //
                    // copy and info options
                    const _MessageActionIcons(),
                  ],
                ),

                //
                //
                // body
                body: Container(
                  color: Colors.grey.applyOpacity(0.05),
                  child: Stack(
                    children: [
                      const _ChatBackgroundView(),

                      //
                      // messages list and message input body etc
                      Obx(
                        () => ((controller.isLoadingChatDetails &&
                                    controller.isDatabaseListEmpty) ||
                                controller.isLoadingFromDatabase)
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: AppColorsLight.mainColor),
                              )
                            : Column(
                                children: [
                                  //
                                  //
                                  // buttons to scroll next and previous searched messages
                                  const _SearchButtonsView(),

                                  //
                                  //
                                  //
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Obx(
                                          () => NotificationListener<
                                              OverscrollIndicatorNotification>(
                                            onNotification: (overscroll) {
                                              overscroll
                                                  .disallowIndicator(); // Remove overscroll effect
                                              return false;
                                            },
                                            child: ScrollablePositionedList
                                                .builder(
                                              reverse: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemScrollController:
                                                  controller.scrollController,
                                              itemCount:
                                                  controller.messages.length,
                                              itemPositionsListener: controller
                                                  .itemPositionsNotifier,
                                              itemBuilder: (context, index) {
                                                var message =
                                                    controller.messages[index];

                                                // this variable shows that list have a next index or not
                                                bool nextIndexExists = (index +
                                                        1) <
                                                    controller.messages.length;

                                                // this represents the current index message date
                                                final currentMessageDate =
                                                    DateFormat('MMMM d, y')
                                                        .format(
                                                            message.createdAt ??
                                                                DateTime.now());

                                                // this will represent the next index message date
                                                var nextMessageDate =
                                                    currentMessageDate;

                                                // checking if next index exists then update the nextMessageDate variable with next message date
                                                if (nextIndexExists) {
                                                  nextMessageDate =
                                                      DateFormat('MMMM d, y')
                                                          .format(controller
                                                                  .messages[
                                                                      index + 1]
                                                                  .createdAt ??
                                                              DateTime.now());
                                                }

                                                if ((index ==
                                                        (controller.messages
                                                                .length -
                                                            1)) &&
                                                    (!controller
                                                        .isLoadingPreviousMessagesFromApi) &&
                                                    (!controller
                                                        .isLoadingPreviousMessagesFromDB) &&
                                                    (!controller
                                                        .noMoreMessages) &&
                                                    (message.id != null)) {
                                                  controller
                                                      .loadPreviousMessagesFromDB(
                                                          message.id!);
                                                }

                                                final key = ValueKey(
                                                  'msg_${message.id ?? message.tempId ?? index}',
                                                );

                                                return Column(
                                                  children: [
                                                    //
                                                    //
                                                    // beginning of chat text
                                                    if (controller
                                                            .noMoreMessages &&
                                                        (index ==
                                                            (controller.messages
                                                                    .length -
                                                                1)))
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 20),
                                                        child: const Text(
                                                          "Beginning of chat",
                                                          style: TextStyle(
                                                              color:
                                                                  AppColorsLight
                                                                      .mainColor,
                                                              fontSize: 14),
                                                        ),
                                                      ),

                                                    //
                                                    //
                                                    // loading indicator

                                                    Obx(
                                                      () => Visibility(
                                                        visible: (controller
                                                                    .isLoadingPreviousMessagesFromApi ||
                                                                controller
                                                                    .isLoadingPreviousMessagesFromDB) &&
                                                            (index ==
                                                                (controller
                                                                        .messages
                                                                        .length -
                                                                    1)),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 20),
                                                          child: const SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  AppColorsLight
                                                                      .mainColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    //
                                                    //
                                                    // date lable view
                                                    if ((currentMessageDate !=
                                                            nextMessageDate) ||
                                                        (index ==
                                                            (controller.messages
                                                                    .length -
                                                                1)))
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 20,
                                                            bottom: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                      .chatThemeData
                                                                      .value !=
                                                                  null
                                                              ? Colors.black54
                                                              : Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          currentMessageDate,
                                                          style: theme.textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                            color: controller
                                                                        .chatThemeData
                                                                        .value !=
                                                                    null
                                                                ? Colors.white
                                                                : null,
                                                          ),
                                                        ),
                                                      ),

                                                    //
                                                    //
                                                    // actual message view
                                                    _MessageItemView(
                                                      key: key,
                                                      message: message,
                                                      index: index,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                        //
                                        //
                                        // scroll to bottom button
                                        Obx(
                                          () => Visibility(
                                            visible: controller
                                                .showScrollDownButton.value,
                                            child: Positioned(
                                              bottom: 14,
                                              right: 14,
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .scrollToMessageAtIndex(
                                                          0);
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .expand_circle_down_rounded,
                                                  size: 30,
                                                  color:
                                                      AppColorsLight.mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //
                                  //
                                  // indicates the message syncing from server
                                  const _SyncingMessagesIndication(),

                                  //
                                  //
                                  // suggestions view
                                  const ChatSuggestionsView(),

                                  //
                                  //
                                  // message input field
                                  Visibility(
                                    visible: controller.type == 'group'
                                        ? controller.iAmParticipant &&
                                            controller.chatable
                                        : controller.chatable,
                                    child: const ChatInputField(),
                                  ),
                                ],
                              ),
                      ),

                      //
                      //
                      // mentoined list
                      const Positioned(
                        bottom: 55,
                        child: _MentionsSelectionListView(),
                      ),

                      //
                      //
                      // buzz view
                      Obx(
                        () => Visibility(
                          visible: controller.receivedBuzz &&
                              (controller.buzzOnMessageId.value == null),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.applyOpacity(0.1),
                            ),
                            child: const ConversationBuzzView(
                              size: 450,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageItemView extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  final int index;
  const _MessageItemView(
      {super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: message.id != null
          ? message.id!.toString()
          : message.tempId != null
              ? message.tempId!
              : controller.generateUid().toString(),
      child: Obx(
        () => Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            color: controller.currentSearchedIndex.value == index ||
                    (controller.isMessageSelectionEnabled &&
                        controller.selectedMessages.contains(message.id)) ||
                    (controller.messageTempHighlightEnabled &&
                        (controller.tempHighlightMessageId.value ==
                            message.id)) ||
                    (controller.receivedBuzz &&
                        controller.buzzOnMessageId.value == message.id &&
                        message.id != null)
                ? AppColorsLight.mainColor.applyOpacity(0.1)
                : Colors.transparent,
            child: MessageMainView(
              message: message,
              index: index,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/message_input_formatter.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/emoji_picker.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';
import '../../../controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ChatInputField extends GetView<ChatDetailController> {
  const ChatInputField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: ((controller.selectedMessageForReply.value != null) ||
                  (controller.selectedAttachments.isNotEmpty))
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color.fromARGB(255, 78, 78, 78).applyOpacity(
                  controller.selectedAttachments.isNotEmpty ||
                          controller.selectedMessageForReply.value != null
                      ? 0.8
                      : 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  //
                  //
                  // selected message for reply view
                  Obx(
                    () => controller.selectedMessageForReply.value != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReplyMessageView(
                                message:
                                    controller.selectedMessageForReply.value!,
                                isSenderView: true,
                              ),

                              // close selected message button
                              GestureDetector(
                                onTap: () {
                                  controller.selectedMessageForReply.value =
                                      null;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? AppColorsDark.mainRedColor
                                          : AppColorsLight.mainColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: const Icon(
                                    Icons.close,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ).marginOnly(bottom: 10)
                        : const SizedBox.shrink(),
                  ),

                  //
                  // selected attchments view
                  Obx(
                    () => Visibility(
                      visible: controller.selectedAttachments.isNotEmpty,
                      child: SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.selectedAttachments.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: Stack(children: [
                                //
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                        controller.fileExtensionHelper
                                            .getFileIcon(
                                          controller.fileExtensionHelper
                                              .getFileType(
                                            controller
                                                    .selectedAttachments[index]
                                                    .file
                                                    ?.path ??
                                                "none",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.fileExtensionHelper
                                            .getFileName(controller
                                                    .selectedAttachments[index]
                                                    .file
                                                    ?.path ??
                                                ""),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    )
                                  ],
                                ).marginAll(5),

                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectedAttachments
                                          .removeAt(index);
                                      if (controller
                                          .selectedAttachments.isEmpty) {
                                        controller.updateSendIcon();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColorsDark.mainRedColor
                                              : AppColorsLight.mainColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100))),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ).marginOnly(left: 10);
                          },
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // children: [
                          //   Container(
                          //     padding: const EdgeInsets.all(5),
                          //     decoration: BoxDecoration(
                          //         color: AppColorsLight.chatReciverColor,
                          //         borderRadius: BorderRadius.circular(100)),
                          //     child: Image.asset(
                          //       controller.getFileIcon(controller.getFileType(
                          //           controller.getFileExtension(controller
                          //               .getFileNameWithExtenshion(controller
                          //                       .selectedAttachments?.file?.path ??
                          //                   "none")))),
                          //       width: 25,
                          //       height: 25,
                          //     ),
                          //   ),
                          //   const SizedBox(
                          //     width: 14,
                          //   ),
                          //   Expanded(
                          //       child: Text(controller.getFileNameNoExtenshion(
                          //           controller.selectedAttachments?.file?.path ??
                          //               ""))),
                          //   const SizedBox(
                          //     width: 14,
                          //   ),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.removeSelectedAttachment();
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.all(2),
                          //     decoration: BoxDecoration(
                          //         color: Get.isDarkMode
                          //             ? AppColorsDark.mainRedColor
                          //             : AppColorsLight.mainColor,
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(100))),
                          //     child: const Icon(
                          //       Icons.close,
                          //       size: 15,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          // ],
                        ).marginOnly(bottom: 10),
                      ),
                    ),
                  ),

                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////
                  //////////////////////// Test Area ///////////////////////////////
                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////

                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////

                  //
                  // message inpout field and buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: controller.chatThemeData.value != null
                                ? Get.isDarkMode
                                    ? Colors.grey
                                    : Colors.white
                                : Get.isDarkMode
                                    ? Colors.grey
                                    : AppColorsLight.mainColor
                                        .applyOpacity(0.05),
                            borderRadius: (controller.type == "group") &&
                                    controller.usersMentioned.isNotEmpty
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  )
                                : BorderRadius.circular(12),
                          ),
                          child: Obx(
                            () => Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //
                                //
                                // emoji button
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 12,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.toggleEmojiPicker();
                                    },
                                    child: Icon(
                                      controller.isEmojiPickerVisible.value
                                          ? Icons.keyboard
                                          : Icons
                                              .sentiment_satisfied_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.applyOpacity(0.64),
                                    ),
                                  ),
                                ),

                                //
                                //
                                // message input field
                                Expanded(
                                  child: Scrollbar(
                                    controller: controller.textScrollController,
                                    child: TextField(
                                      // controller: controller
                                      //     .textEditingController,
                                      controller: controller.richTextController,
                                      textInputAction: TextInputAction.newline,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      scrollController:
                                          controller.textScrollController,
                                      onSubmitted: (value) {
                                        controller.sendMessage();
                                      },
                                      inputFormatters: [
                                        MessageInputFormatter(),
                                      ],
                                      contextMenuBuilder:
                                          (context, editableTextState) {
                                        //
                                        //
                                        // text tool bar
                                        return AdaptiveTextSelectionToolbar(
                                          anchors: editableTextState
                                              .contextMenuAnchors,
                                          children: AdaptiveTextSelectionToolbar
                                              .getAdaptiveButtons(
                                            context,
                                            [
                                              //
                                              //
                                              // cut button
                                              if (editableTextState.cutEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () {
                                                    editableTextState
                                                        .cutSelection(
                                                            SelectionChangedCause
                                                                .toolbar);
                                                  },
                                                  type:
                                                      ContextMenuButtonType.cut,
                                                ),

                                              //
                                              //
                                              // copy button
                                              if (editableTextState.copyEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () {
                                                    editableTextState
                                                        .copySelection(
                                                            SelectionChangedCause
                                                                .toolbar);
                                                  },
                                                  type: ContextMenuButtonType
                                                      .copy,
                                                ),

                                              //
                                              //
                                              // past button
                                              if (editableTextState
                                                  .pasteEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () {
                                                    editableTextState.pasteText(
                                                        SelectionChangedCause
                                                            .toolbar);
                                                  },
                                                  type: ContextMenuButtonType
                                                      .paste,
                                                ),

                                              //
                                              //
                                              // share button
                                              if (editableTextState
                                                  .shareEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () {
                                                    editableTextState
                                                        .shareSelection(
                                                            SelectionChangedCause
                                                                .toolbar);
                                                  },
                                                  type: ContextMenuButtonType
                                                      .share,
                                                ),

                                              //
                                              //
                                              // select all button
                                              if (editableTextState
                                                  .selectAllEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () {
                                                    editableTextState.selectAll(
                                                        SelectionChangedCause
                                                            .toolbar);
                                                  },
                                                  type: ContextMenuButtonType
                                                      .selectAll,
                                                ),

                                              //
                                              //
                                              // Bold button
                                              if (editableTextState.copyEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () =>
                                                      _applyTextFormat(
                                                          controller
                                                              .richTextController,
                                                          '*'),
                                                  type: ContextMenuButtonType
                                                      .custom,
                                                  label: 'Bold',
                                                ),

                                              //
                                              //
                                              // Italic button
                                              if (editableTextState.copyEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () =>
                                                      _applyTextFormat(
                                                          controller
                                                              .richTextController,
                                                          '_'),
                                                  type: ContextMenuButtonType
                                                      .custom,
                                                  label: 'Italic',
                                                ),

                                              //
                                              //
                                              // Strikethrough button
                                              if (editableTextState.copyEnabled)
                                                ContextMenuButtonItem(
                                                  onPressed: () =>
                                                      _applyTextFormat(
                                                          controller
                                                              .richTextController,
                                                          '~'),
                                                  type: ContextMenuButtonType
                                                      .custom,
                                                  label: 'Strikethrough',
                                                ),
                                            ],
                                          ).toList(),
                                        );
                                      },
                                      focusNode: controller.focusNode.value,
                                      maxLines: 5,
                                      minLines: 1,
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type message . . .",
                                        hintStyle: TextStyle(
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black54,
                                        ),
                                        icon: Obx(
                                          () => controller
                                                  .haveImageInClipBoard.value
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    controller
                                                        .attachFileFromClipboard();
                                                  },
                                                  child: const Icon(Icons
                                                      .content_paste_rounded),
                                                ).paddingOnly(left: 10)
                                              : const SizedBox.shrink(),
                                        ),
                                        border: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      keyboardAppearance: Get.isDarkMode
                                          ? Brightness.dark
                                          : Brightness.light,
                                    ),
                                  ),
                                ),

                                //
                                //
                                // buzz button
                                Container(
                                  margin: const EdgeInsets.only(
                                    right: 15,
                                    bottom: 12,
                                  ),
                                  child: Obx(() => Visibility(
                                        visible: controller.count == 0,
                                        child: controller.isSendingBuzz
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeCap: StrokeCap.round,
                                                  strokeWidth: 4,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTapDown: (details) {
                                                  controller.buzzPressed.value =
                                                      true;
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    if (controller
                                                        .buzzPressed.value) {
                                                      controller.sendBuzz(null);
                                                      controller.buzzPressed
                                                          .value = false;
                                                    }
                                                  });
                                                },
                                                onTapUp: (details) {
                                                  controller.buzzPressed.value =
                                                      false;
                                                },
                                                // onLongPress: () {
                                                //   controller.sendBuzz(null);
                                                //   controller.buzzPressed
                                                //       .value = false;
                                                // },
                                                child: AnimatedContainer(
                                                  width: controller
                                                          .buzzPressed.value
                                                      ? 40
                                                      : 24,
                                                  height: controller
                                                          .buzzPressed.value
                                                      ? 40
                                                      : 24,
                                                  margin: EdgeInsets.only(
                                                    top: controller
                                                            .buzzPressed.value
                                                        ? 10
                                                        : 0,
                                                  ),
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .buzzPressed.value
                                                        ? AppColorsLight
                                                            .mainColor
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      100,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .electric_bolt_outlined,
                                                      color: controller
                                                              .buzzPressed.value
                                                          ? Colors.white
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color
                                                              ?.applyOpacity(
                                                                0.64,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      )),
                                ),

                                //
                                //
                                // attachments button
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, bottom: 12),
                                  child: Transform.rotate(
                                    angle: 2.5,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller
                                            .showAttachmentBottomSheet(theme);
                                      },
                                      child: Icon(
                                        Icons.attach_file,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.applyOpacity(0.64),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      // recording and send button
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () {
                            if (controller.recorderEnabled) {
                              controller.showRecodingBottomSheet();
                            } else {
                              controller.sendMessage();
                            }
                          },
                          child: Obx(
                            () => Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.isDarkMode
                                    ? AppColorsDark.mainRedColor
                                    : AppColorsLight.mainColor,
                              ),
                              child: AnimatedOpacity(
                                opacity: controller.hideSendIcon ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Icon(
                                  controller.recorderEnabled
                                      ? Icons.mic
                                      : Icons.send,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ).marginSymmetric(horizontal: 14, vertical: 5),

              //
              // emoji picker view
              Obx(
                () => Visibility(
                  visible: controller.isEmojiPickerVisible.value &&
                      !controller.focusNode.value.hasFocus,
                  child: Stack(
                    children: [
                      EmojiGifPicker(
                        textController: controller.richTextController,
                        onPickGif: (url) {
                          controller.showGifPicker();
                        },
                        isDark: Theme.of(context).brightness == Brightness.dark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyTextFormat(TextEditingController controller, String symbol) {
    final selection = controller.selection;

    if (selection.isCollapsed) {
      return; // No text selected
    }

    final text = controller.text;
    final selectedText = text.substring(selection.start, selection.end);

    // Apply the format
    final modifiedText = '$symbol$selectedText$symbol';
    final newText =
        text.replaceRange(selection.start, selection.end, modifiedText);

    // Update the text field with the formatted text
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.start + modifiedText.length),
    );
  }
}

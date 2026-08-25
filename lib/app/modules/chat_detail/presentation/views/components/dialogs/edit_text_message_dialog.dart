import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/text_message_sender.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class EditMessageDialog extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  EditMessageDialog({super.key, required this.message}) {
    newMessageController.text = message.message ?? "";
    newMessageText.value = message.message ?? "";

    newMessageController.addListener(() {
      newMessageText.value = newMessageController.text;
    });
  }

  final TextEditingController newMessageController = TextEditingController();
  final isEmojiPickerVisible = false.obs;
  final focusNode = FocusNode().obs;
  final RxString newMessageText = RxString("");

  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Obx(
      () => PopScope(
        canPop: (!controller.isEditingMessage),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,

            //
            //
            appBar: AppBar(
              backgroundColor:
                  Get.isDarkMode ? theme.primaryColor : Colors.white,
              toolbarHeight: 55.h,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  if (!controller.isEditingMessage) {
                    Get.back(canPop: true);
                  }
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              title: Text(
                "Edit message",
                maxLines: 1,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            //
            //
            body: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                //
                //
                //sender message view
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      TextMessageSender(message: message),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: ProfileImage.network(
                            url: message.model?.image,
                            width: 20,
                            height: 20,
                            showLetterOnError: (message.model?.name != null),
                            letter: message.model?.name,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //
                // message input view
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 32,
                        color: const Color.fromARGB(255, 78, 78, 78)
                            .applyOpacity(0.08),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        //
                        // message input field and buttons
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? Colors.grey.applyOpacity(0.2)
                                      : AppColorsLight.mainColor
                                          .applyOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Obx(
                                  () => Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 12),
                                        child: GestureDetector(
                                          onTap: () {
                                            toggleEmojiPicker();
                                          },
                                          child: Icon(
                                            isEmojiPickerVisible.value
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
                                      Obx(
                                        () => Expanded(
                                          child: Scrollbar(
                                            child: TextField(
                                              controller: newMessageController,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onSubmitted: (value) {
                                                // controller.sendMessage();
                                              },
                                              focusNode: focusNode.value,
                                              maxLines: 5,
                                              minLines: 1,
                                              decoration: const InputDecoration(
                                                hintText: "Type message . . .",
                                                border: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Obx(
                                () => controller.isEditingMessage
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColorsLight.mainColor,
                                        ),
                                      )
                                    : Visibility(
                                        visible:
                                            newMessageText.value.isNotEmpty,
                                        child: InkWell(
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            await controller.editMessage(
                                              message,
                                              newMessageText.value,
                                            );
                                            Get.back(canPop: true);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Get.isDarkMode
                                                  ? AppColorsDark.mainRedColor
                                                  : AppColorsLight.mainColor,
                                            ),
                                            child: const Icon(
                                              Icons.send,
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

                        //
                        // emoji picker view
                        Obx(
                          () => Visibility(
                            visible: isEmojiPickerVisible.value &&
                                !focusNode.value.hasFocus,
                            child: SizedBox(
                              height: 250,
                              child: EmojiPicker(
                                textEditingController: newMessageController,
                                onBackspacePressed: () {},
                                config: Config(
                                  emojiViewConfig: EmojiViewConfig(
                                    backgroundColor: Get.isDarkMode
                                        ? AppColorsDark.scaffoldBackroundColor
                                        : const Color(0xFFF2F2F2),
                                  ),
                                  categoryViewConfig: CategoryViewConfig(
                                    backgroundColor: Get.isDarkMode
                                        ? AppColorsDark.scaffoldBackroundColor
                                        : const Color(0xFFF2F2F2),
                                  ),
                                  checkPlatformCompatibility: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleEmojiPicker() {
    if (isEmojiPickerVisible.value) {
      focusNode.value.requestFocus();
    } else {
      focusNode.value.unfocus();
    }
    isEmojiPickerVisible.value = !isEmojiPickerVisible.value;
  }
}

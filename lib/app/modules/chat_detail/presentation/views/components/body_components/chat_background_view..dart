part of '../../chat_detail_view.dart';

class _ChatBackgroundView extends GetView<ChatDetailController> {
  const _ChatBackgroundView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //
        //
        // chat background
        Obx(
          () {
            //
            //
            // check if have theme then load chat theme data
            if (controller.chatThemeData.value != null) {
              //
              //
              // theme type is image and also image not null
              // then present a image background from file
              if (controller.chatThemeData.value!.type == ChatThemeType.image &&
                  controller.chatBackgroundFile.value != null) {
                //
                //
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    ImageEditingMatrixes.brightnessAdjustMatrix(
                      controller.chatThemeData.value!.brightness ?? -0.3,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          controller.chatBackgroundFile.value!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }

              //
              //
              // else if theme data type is color then show color
              else if (controller.chatThemeData.value!.type ==
                      ChatThemeType.color &&
                  controller.chatThemeData.value!.color != null) {
                Color? chatBackgroundColor;

                try {
                  chatBackgroundColor =
                      Color(controller.chatThemeData.value!.color!);
                } catch (_) {}

                return Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      ImageEditingMatrixes.brightnessAdjustMatrix(
                        controller.chatThemeData.value!.brightness ?? 0.5,
                      ),
                    ),
                    child: Container(
                      color: chatBackgroundColor,
                    ),
                  ),
                );
              }
            }

            return Positioned.fill(
              child: Image.asset(
                Assets.chatIcons.chatBackgroundCover.path,
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(
                  Get.isDarkMode ? 0.2 : 0.5,
                ),
              ),
            );
          },
        ),

        //
        //
        // chat patteren view with custom theme
        Obx(
          () => Positioned.fill(
            child: Visibility(
              visible: controller.chatThemeData.value?.patternEnabled ?? false,
              child: Image.asset(
                Assets.chatIcons.chatBackgroundCover.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

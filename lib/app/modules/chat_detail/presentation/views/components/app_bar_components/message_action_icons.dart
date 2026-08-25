part of '../../chat_detail_view.dart';

class _MessageActionIcons extends GetView<ChatDetailController> {
  const _MessageActionIcons();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: (controller.isMessageSelectionEnabled),
        child: const Row(
          children: [
            //
            // copy message button
            _CopyMessageActionIcon(),

            //
            // forward message button
            _ForwardMessageActionIcon(),

            //
            // edit message button
            _EditMessageActionIcon(),

            //
            // delete message button
            _DeleteMessageActionIcon(),

            //
            // message info button
            _MessageInfoActionIcon(),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class _CopyMessageActionIcon extends GetView<ChatDetailController> {
  const _CopyMessageActionIcon();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.selectedMessages.length == 1,
        child: GestureDetector(
          onTap: () {
            controller.copyMessage();
          },
          child: const Icon(
            Icons.content_copy_rounded,
            color: AppColorsLight.mainColor,
            size: 25,
          ),
        ).marginOnly(right: 15),
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class _ForwardMessageActionIcon extends GetView<ChatDetailController> {
  const _ForwardMessageActionIcon();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.selectedMessages.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            controller.forwardMessage();
          },
          child: Transform.flip(
            flipX: true,
            child: const Icon(
              Icons.reply_rounded,
              color: AppColorsLight.mainColor,
              size: 25,
            ),
          ),
        ).marginOnly(right: 15),
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class _EditMessageActionIcon extends GetView<ChatDetailController> {
  const _EditMessageActionIcon();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isMessageEditable(),
        child: GestureDetector(
          onTap: () {
            controller.editMessageClicked();
          },
          child: const Icon(
            Icons.edit,
            color: AppColorsLight.mainColor,
            size: 25,
          ),
        ).marginOnly(right: 15),
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class _DeleteMessageActionIcon extends GetView<ChatDetailController> {
  const _DeleteMessageActionIcon();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isMessageDeletable(),
        child: GestureDetector(
          onTap: () {
            controller.deleteMessageClicked();
          },
          child: const Icon(
            Icons.delete_forever_rounded,
            color: AppColorsLight.mainColor,
            size: 25,
          ),
        ).marginOnly(right: 15),
      ),
    );
  }
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class _MessageInfoActionIcon extends GetView<ChatDetailController> {
  const _MessageInfoActionIcon();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: ((controller.selectedMessages.length == 1) &&
            (controller.messages.firstWhereOrNull((element) =>
                    ((element.id == controller.selectedMessages[0]) &&
                        (element.modelId.toString()) == controller.myId)) !=
                null) &&
            (controller.type == "group")),
        child: GestureDetector(
          onTap: () {
            controller.showMessageInfo();
          },
          child: const Icon(
            Icons.info_rounded,
            color: AppColorsLight.mainColor,
            size: 25,
          ),
        ).marginOnly(right: 10),
      ),
    );
  }
}

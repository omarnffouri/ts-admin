part of '../../chat_detail_view.dart';

class _SyncingMessagesIndication extends GetView<ChatDetailController> {
  const _SyncingMessagesIndication();

  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Obx(
      () => Visibility(
        visible: controller.isLoadingChatDetails,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: AppColorsLight.mainColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              "Syncing messages...",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColorsLight.mainColor,
              ),
            ).marginOnly(left: 10),
          ],
        ).marginSymmetric(vertical: 10),
      ),
    );
  }
}

part of '../../chat_detail_view.dart';

class _SearchButtonsView extends GetView<ChatDetailController> {
  const _SearchButtonsView();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.indexesOfSearchedMessages.isNotEmpty,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              //
              //
              // scroll upward button
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.scrollToSearchedMessageIndex(false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      const Text(
                        "Previous",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(left: 5),
                      Text(
                        controller.getPreviousSearchCount().toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(left: 5),
                    ],
                  ).paddingAll(5),
                ),
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                  color: Colors.white,
                ),
              ),

              //
              //
              // scroll downward button
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.scrollToSearchedMessageIndex(true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(left: 5),
                      Text(
                        controller.getNextSearchCount().toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(left: 5),
                    ],
                  ).paddingAll(5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

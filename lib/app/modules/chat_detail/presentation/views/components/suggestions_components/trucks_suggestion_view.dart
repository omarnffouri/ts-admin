part of './chat_suggestions_view.dart';

class _TrucksSuggestionView extends GetView<ChatInfoTagsController> {
  const _TrucksSuggestionView();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("truck-suggestions-key"),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.selectedTruck.value = null;
        controller.suggestedTrucks.clear();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.25,
        ),
        decoration: BoxDecoration(
          color: controller.chatDetailController?.chatThemeData.value != null
              ? Get.isDarkMode
                  ? Colors.black.applyOpacity(0.9)
                  : Colors.white.applyOpacity(0.9)
              : Colors.grey.applyOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //
            //
            // heading and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                //
                // heading
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.truckSuggestionsHeading.value,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Get.isDarkMode
                            ? Colors.white
                            : AppColorsLight.mainColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                //
                //
                // close button
                GestureDetector(
                  onTap: () {
                    controller.selectedTruck.value = null;
                    controller.suggestedTrucks.clear();
                  },
                  child: Icon(
                    Icons.close,
                    color: Get.isDarkMode
                        ? Colors.white
                        : AppColorsLight.mainColor,
                  ),
                ),
              ],
            ),

            //
            //
            // suggestions
            Obx(
              () => Flexible(
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  controller: controller.trucksScrollControl,
                  child: SingleChildScrollView(
                    primary: false,
                    controller: controller.trucksScrollControl,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: controller.selectedTruck.value != null
                          ? _TruckSuggestionDetailView(
                              truck: controller.selectedTruck.value!,
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                controller.suggestedTrucks.length,
                                (index) {
                                  final truck = controller.suggestedTrucks
                                      .elementAt(index);

                                  return TagItemView(
                                    tag: truck.name ?? "Unkown",
                                    onClick: () {
                                      controller.insertTruckSuggestion(truck);
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TruckSuggestionDetailView extends GetView<ChatInfoTagsController> {
  final TruckInfoTagEntity truck;
  const _TruckSuggestionDetailView({
    required this.truck,
  });

  @override
  Widget build(BuildContext context) {
    //
    // details view
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: [
          //
          // id tag
          TagItemView(
            tag: "ID: ${truck.identifier ?? "N/A"}",
            onClick: () {
              controller.insertText(
                  "ID: ${(truck.identifier?.toString() ?? "N/A").trim()}");
            },
          ),

          //
          // maker tag
          TagItemView(
            tag: "Maker: ${truck.maker ?? "N/A"}",
            onClick: () {
              controller.insertText("Maker: ${(truck.maker ?? "N/A").trim()}");
            },
          ),

          //
          // licence plate number tag
          TagItemView(
            tag: "PNO: ${truck.licencePlateNumber ?? "N/A"}",
            onClick: () {
              controller.insertText(
                  "PNO: ${(truck.licencePlateNumber ?? "N/A").trim()}");
            },
          ),

          //
          // truck type tag
          TagItemView(
            tag: "Type: ${truck.type ?? "N/A"}",
            onClick: () {
              controller.insertText("Type: ${(truck.type ?? "N/A").trim()}");
            },
          ),

          //
          // drivers tag
          TagItemView(
            tag: "Drivers",
            onClick: () {
              controller.filterTruckLinkedSuggestions(
                truck.id ?? 0,
                TruckLinkedTags.drivers,
              );
            },
          ),

          //
          // shipments tag
          TagItemView(
            tag: "Shipments",
            onClick: () {
              controller.filterTruckLinkedSuggestions(
                truck.id ?? 0,
                TruckLinkedTags.shipments,
              );
            },
          ),
        ],
      ),
    );
  }
}

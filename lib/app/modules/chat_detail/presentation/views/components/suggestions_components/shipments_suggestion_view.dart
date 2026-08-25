part of './chat_suggestions_view.dart';

class _ShipmentsSuggestionView extends GetView<ChatInfoTagsController> {
  const _ShipmentsSuggestionView();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("shipment-suggestions-key"),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.selectedShipment.value = null;
        controller.suggestedShipments.clear();
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
                Obx(
                  () => Text(
                    controller.shipmentSuggestionsHeading.value,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                //
                //
                // close button
                GestureDetector(
                  onTap: () {
                    controller.selectedShipment.value = null;
                    controller.suggestedShipments.clear();
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
                  controller: controller.shipmentsScrollControl,
                  child: SingleChildScrollView(
                    primary: false,
                    controller: controller.shipmentsScrollControl,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: controller.selectedShipment.value != null
                          ? _ShipmentSuggestionDetailView(
                              shipment: controller.selectedShipment.value!,
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                controller.suggestedShipments.length,
                                (index) {
                                  final shipment = controller.suggestedShipments
                                      .elementAt(index);

                                  return TagItemView(
                                    tag: shipment.shipmentNumber ?? "Unkown",
                                    onClick: () {
                                      controller
                                          .insertShipmentSuggestion(shipment);
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

class _ShipmentSuggestionDetailView extends GetView<ChatInfoTagsController> {
  final ShipmentInfoTagEntity shipment;

  final RxBool showLocations = false.obs;

  _ShipmentSuggestionDetailView({
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    //
    // details view
    return Align(
      alignment: Alignment.topLeft,
      child: Obx(
        () => Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            //
            // trailer id tag
            TagItemView(
              tag: "TID: ${shipment.trailerId ?? "N/A"}",
              onClick: () {
                controller
                    .insertText("TID: ${(shipment.trailerId ?? "N/A").trim()}");
              },
            ),

            //
            // drivers tag
            TagItemView(
              tag: "Drivers",
              onClick: () {
                controller.filterShipmentLinkedSuggestions(
                  shipment.id ?? 0,
                  ShipmentLinkedTags.drivers,
                );
              },
            ),

            //
            // trucks tag
            TagItemView(
              tag: "Trucks",
              onClick: () {
                controller.filterShipmentLinkedSuggestions(
                  shipment.id ?? 0,
                  ShipmentLinkedTags.trucks,
                );
              },
            ),

            //
            // locations tag
            TagItemView(
              tag: "Locations",
              onClick: () {
                showLocations.toggle();
              },
              backgroundColor: showLocations.value
                  ? Get.isDarkMode
                      ? Colors.green.applyOpacity(0.05)
                      : AppColorsLight.mainColor
                  : null,
              borderColor: showLocations.value
                  ? Get.isDarkMode
                      ? Colors.green
                      : AppColorsLight.mainColor
                  : null,
              textColor: showLocations.value
                  ? Get.isDarkMode
                      ? Colors.green
                      : Colors.white
                  : null,
            ),

            //
            // locations tags list
            if (showLocations.value &&
                (shipment.locations?.isNotEmpty ?? false))
              for (LocationInfoTagEntity location in shipment.locations!)
                TagItemView(
                  tag:
                      "${location.type?.capitalizeFirst}: ${location.address ?? "Unkown"}",
                  onClick: () {
                    controller.insertText(
                        "${location.type?.capitalizeFirst}: ${(location.address ?? "Unkown").trim()}");
                  },
                  backgroundColor: Get.isDarkMode
                      ? Colors.green.applyOpacity(0.05)
                      : AppColorsLight.mainColor,
                  borderColor:
                      Get.isDarkMode ? Colors.green : AppColorsLight.mainColor,
                  textColor: Get.isDarkMode ? Colors.green : Colors.white,
                ),
          ],
        ),
      ),
    );
  }
}

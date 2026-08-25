part of './chat_suggestions_view.dart';

class _DriversSuggestionView extends GetView<ChatInfoTagsController> {
  const _DriversSuggestionView();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("driver-suggestions-key"),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.selectedDriver.value = null;
        controller.suggestedDrivers.clear();
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
                    controller.driverSuggestionsHeading.value,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor,
                    ),
                  ),
                ),

                //
                //
                // close button
                GestureDetector(
                  onTap: () {
                    controller.selectedDriver.value = null;
                    controller.suggestedDrivers.clear();
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
                  controller: controller.driversScrollControl,
                  child: SingleChildScrollView(
                    primary: false,
                    controller: controller.driversScrollControl,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: controller.selectedDriver.value != null
                          ? _DriverSuggestionDetailView(
                              driver: controller.selectedDriver.value!,
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                controller.suggestedDrivers.length,
                                (index) {
                                  final driver = controller.suggestedDrivers
                                      .elementAt(index);

                                  return TagItemView(
                                    tag: driver.name ?? "Unkown",
                                    onClick: () {
                                      controller.insertDriveSuggestion(driver);
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

class _DriverSuggestionDetailView extends GetView<ChatInfoTagsController> {
  final DriverInfoTagEntity driver;
  const _DriverSuggestionDetailView({
    required this.driver,
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
          // phone number tag
          TagItemView(
            tag: "PH: ${driver.phone ?? "N/A"}",
            onClick: () {
              controller.insertText("PH: ${(driver.phone ?? "N/A").trim()}");
            },
          ),

          //
          // ssn tag
          TagItemView(
            tag: "SSN: ${driver.ssn ?? "N/A"}",
            onClick: () {
              controller.insertText("SSN: ${(driver.ssn ?? "N/A").trim()}");
            },
          ),

          //
          // trucks tag
          TagItemView(
            tag: "Trucks",
            onClick: () {
              controller.filterDriverLinkedSuggestions(
                driver.id ?? 0,
                DriverLinkedTags.trucks,
              );
            },
          ),

          //
          // shipments tag
          TagItemView(
            tag: "Shipments",
            onClick: () {
              controller.filterDriverLinkedSuggestions(
                driver.id ?? 0,
                DriverLinkedTags.shipments,
              );
            },
          ),
        ],
      ),
    );
  }
}

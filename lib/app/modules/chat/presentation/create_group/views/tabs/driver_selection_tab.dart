import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/create_group/controllers/create_group_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DriverSelectionTab extends GetView<CreateGroupController> {
  const DriverSelectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    // theme
    ThemeData theme = Theme.of(context);
    return Obx(
      () => AnimatedContainer(
        width: controller.groupCreationState.value ==
                GroupCreationStates.selectDrivers
            ? Get.width
            : 0,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: Get.width,
            child: controller.isLoadingGroupContacts
                ? _buildLoadingView(theme)
                : (controller.groupContacts.value?.applicants?.isEmpty ?? true)
                    ? const Text("No driver found in contacts.")
                    : Column(
                        children: [
                          //
                          // search field
                          RoundedInputField(
                            hintText: "Search drivers by name, phone...",
                            controller: controller.driverSearchTextController,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.clearDriversSearch();
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ).paddingAll(10),

                          // select drivers heading etc
                          Obx(
                            () => Row(
                              children: [
                                const Text(
                                  "Select Drivers",
                                  style: TextStyle(
                                    color: AppColorsLight.mainColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),

                                //
                                // show number of selected drivers
                                Obx(
                                  () => Visibility(
                                    visible:
                                        controller.selectedDrivers.isNotEmpty,
                                    child: Text(
                                      "${controller.selectedDrivers.length}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColorsLight.mainColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).marginOnly(right: 10),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    if (controller.selectedDrivers.length !=
                                        controller.groupContacts.value!
                                            .applicants!.length) {
                                      controller.selectedDrivers.clear();
                                      controller.selectedDrivers.addAll(
                                          controller.groupContacts.value
                                                  ?.applicants ??
                                              []);
                                    } else {
                                      controller.selectedDrivers.clear();
                                    }
                                    controller.isDriverSearchEnabled.refresh();
                                  },
                                  child: Icon(
                                    (controller.selectedDrivers.length ==
                                            controller.groupContacts.value!
                                                .applicants!.length)
                                        ? Icons.indeterminate_check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    color: (controller.selectedDrivers.length !=
                                            controller.groupContacts.value!
                                                .applicants!.length)
                                        ? Colors.grey
                                        : AppColorsLight.mainColor,
                                  ),
                                ),
                              ],
                            ).paddingOnly(left: 14, right: 14),
                          ),

                          // drivers list
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              constraints:
                                  BoxConstraints(maxHeight: Get.height * 0.60),
                              child: Obx(
                                () => ListView.separated(
                                  itemCount:
                                      controller.isDriverSearchEnabled.value
                                          ? controller.filtertedDrivers.length
                                          : controller.groupContacts.value!
                                              .applicants!.length,
                                  itemBuilder: (context, index) {
                                    //
                                    //
                                    final ContactEntity applicant =
                                        controller.isDriverSearchEnabled.value
                                            ? controller.filtertedDrivers[index]
                                            : controller.groupContacts.value!
                                                .applicants![index];

                                    var isSelected = controller.selectedDrivers
                                        .contains((controller
                                                    .isDriverSearchEnabled.value
                                                ? controller.filtertedDrivers
                                                : controller.groupContacts
                                                    .value!.applicants!)
                                            .firstWhere((element) =>
                                                element.id == applicant.id));

                                    return InkWell(
                                      onTap: () {
                                        if (isSelected) {
                                          controller.selectedDrivers
                                              .remove(applicant);
                                        } else {
                                          controller.selectedDrivers
                                              .add(applicant);
                                        }
                                        controller.isDriverSearchEnabled
                                            .refresh();
                                      },
                                      child: Container(
                                        margin: index == 0
                                            ? const EdgeInsets.only(
                                                left: 1, right: 1, top: 14)
                                            : index ==
                                                    (controller
                                                            .groupContacts
                                                            .value!
                                                            .applicants!
                                                            .length -
                                                        1)
                                                ? const EdgeInsets.only(
                                                    left: 1,
                                                    right: 1,
                                                    bottom: 14)
                                                : const EdgeInsets.symmetric(
                                                    horizontal: 1),
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  applicant.image ??
                                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                                                  width: 45,
                                                  height: 45,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        color: AppColorsLight
                                                            .mainColor
                                                            .applyOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: Center(
                                                      child: Text(
                                                        applicant.name?[0]
                                                                .toUpperCase() ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                AppColorsLight
                                                                    .mainColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    applicant.name ?? "",
                                                    style: theme
                                                        .textTheme.titleMedium,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    applicant.phone ?? "",
                                                    style: theme
                                                        .textTheme.labelMedium,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ).paddingOnly(top: 5)
                                                ],
                                              ),
                                            ),

                                            //
                                            //
                                            //
                                            Icon(
                                              isSelected
                                                  ? Icons.check_box_rounded
                                                  : Icons
                                                      .check_box_outline_blank_rounded,
                                              color: isSelected
                                                  ? AppColorsLight.mainColor
                                                  : Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Row(
                                      children: [
                                        SizedBox(
                                          width: 62,
                                        ),
                                        Expanded(
                                          child: Divider(
                                            height: 0,
                                            thickness: 0.2,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: RoundedBorderButton(
                                  label: "Back",
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    controller.groupCreationState(
                                        GroupCreationStates.selectAdmins);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: RoundedFillButton(
                                  label: "Next",
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    controller.groupCreationState(
                                        GroupCreationStates.nameInput);
                                  },
                                ),
                              )
                            ],
                          ).paddingAll(10)
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  _buildLoadingView(ThemeData theme) {
    TextEditingController controller = TextEditingController();
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Get.isDarkMode ? Colors.white30 : Colors.white60,
      child: Column(
        children: [
          //
          // shimmer input field
          RoundedInputField(hintText: "Search", controller: controller)
              .marginSymmetric(
            horizontal: 14,
            vertical: 10,
          ),

          //
          // body
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: AppColorsLight.mainColor.applyOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(
                              child: Text(
                                "D",
                                style: TextStyle(
                                  color: AppColorsLight.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Driver",
                              style: theme.textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "012346789",
                              style: theme.textTheme.labelMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).paddingOnly(top: 5)
                          ],
                        ),
                      ),

                      //
                      //
                      //
                      const Icon(
                        Icons.check_box_outline_blank_rounded,
                        color: Colors.grey,
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Row(
                  children: [
                    SizedBox(
                      width: 62,
                    ),
                    Expanded(
                      child: Divider(
                        height: 0,
                        thickness: 0.2,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/add_participants_params.dart';

import '../controllers/add_driver_participants_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class AddDriverParticipantsView
    extends GetView<AddDriverParticipantsController> {
  const AddDriverParticipantsView({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              //
              //
              // header
              const _Header(),

              //
              //
              // select all option
              Obx(
                () => Visibility(
                  visible: (!controller.isSearchEnabled) &&
                      (!controller.isLoadingGroupContacts) &&
                      (controller.drivers.isNotEmpty),
                  child: Row(
                    children: [
                      //
                      // select drivers label
                      const Text(
                        "Select Drivers",
                        style: TextStyle(
                          color: AppColorsLight.mainColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),

                      //
                      //
                      // select all check box
                      GestureDetector(
                        onTap: () {
                          if (controller.selectedDrivers.length !=
                              controller.drivers.length) {
                            controller.selectedDrivers.clear();
                            controller.selectedDrivers
                                .addAll(controller.drivers);
                          } else {
                            controller.selectedDrivers.clear();
                          }
                        },
                        child: Icon(
                          (controller.selectedDrivers.length ==
                                  controller.drivers.length)
                              ? Icons.indeterminate_check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: (controller.selectedDrivers.length !=
                                  controller.drivers.length)
                              ? Colors.grey
                              : AppColorsLight.mainColor,
                        ),
                      ),
                    ],
                  ).marginOnly(left: 8, right: 8, top: 20, bottom: 10),
                ),
              ),

              //
              //
              // contacts list
              Expanded(
                child: Obx(
                  () =>

                      //
                      //
                      // if loading contacts from the api
                      controller.isLoadingGroupContacts
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                color: AppColors.mainColor,
                                strokeWidth: 5,
                              ),
                            )

                          //
                          // if all drivers are already added then show this message
                          : controller.drivers.isEmpty
                              ? Center(
                                  child: Text(
                                    "No driver to add.",
                                    style: theme.textTheme.labelLarge,
                                  ),
                                )
                              //
                              // showing message for no result in search
                              : (controller.isSearchEnabled &&
                                      controller.filteredDrivers.isEmpty)
                                  ? Center(
                                      child: Text(
                                        "No Result",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    )

                                  //
                                  //
                                  // showing contacts
                                  : ListView.separated(
                                      itemCount: (controller.isSearchEnabled
                                              ? controller.filteredDrivers
                                              : controller.drivers)
                                          .length,
                                      itemBuilder: (context, index) {
                                        final contact =
                                            (controller.isSearchEnabled
                                                ? controller.filteredDrivers
                                                : controller.drivers)[index];
                                        return _ContactItemView(
                                          contact: contact,
                                          index: index,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            Expanded(
                                              child: Divider(
                                                height: 10,
                                                color: Colors.grey
                                                    .applyOpacity(0.2),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                ),
              ),

              //
              //
              // add participants buttons
              Obx(
                () => Visibility(
                  visible: controller.selectedDrivers.isNotEmpty ||
                      controller.isAddingParticipant,
                  child: BounceInUp(
                    animate: true,
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 600),
                    child: MainAppButton(
                      label: "Add Participants",
                      isLoading: controller.isAddingParticipant,
                      trailingIcon: Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Obx(
                          () => Text(
                            controller.selectedDrivers.length.toString(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (controller.selectedDrivers.isEmpty) {
                          CommonWidgets.showSnackBar(
                              title: "Field Required",
                              message: "Please select at least one admin.",
                              isError: false);
                        } else {
                          if (controller.groupId.value == null) {
                            return;
                          }
                          final params = AddParticipantsParams(
                            groupId: controller.groupId.value!,
                            participantType: "applicant",
                            participants: controller.selectedDrivers
                                .map(
                                  (admin) => AddParticipantsPartcipantParams(
                                      id: admin.id!,
                                      modelType: modelTypeValues
                                              .reverse[admin.modelType] ??
                                          "users"),
                                )
                                .toList(),
                          );
                          controller.addParticpant(params);
                        }
                      },
                    ).marginOnly(left: 14, right: 14, bottom: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<AddDriverParticipantsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          //
          // back button group icon and name
          Column(
            children: [
              Row(
                children: [
                  //
                  // back button
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ).marginOnly(right: 10),

                  //
                  //
                  // group logo
                  Obx(
                    () => ProfileImage.network(
                        url: controller.groupLogo.value,
                        width: 45,
                        height: 45,
                        showLetterOnError: true,
                        letter: controller.groupName.value.isNotEmpty
                            ? controller.groupName.value[0].toUpperCase()
                            : ''),
                  ).marginOnly(right: 10),

                  //
                  //
                  // group name and label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        //
                        // group name and search icon
                        Row(
                          children: [
                            //
                            // group name
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.groupName.value,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            //
                            // search icon
                            GestureDetector(
                              onTap: () {
                                if (controller.isSearchEnabled) {
                                  controller.searchController.clear();
                                }
                                controller.toggleSearch();
                              },
                              child: Obx(
                                () => Icon(
                                  controller.isSearchEnabled
                                      ? Icons.search_off_rounded
                                      : Icons.search_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ).marginSymmetric(horizontal: 5),
                          ],
                        ),

                        //
                        //
                        // label
                        Text(
                          'Add Drivers',
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //
              //
              // search field
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: controller.isSearchEnabled ? 50 : 0,
                  margin: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSearchField(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white, // Background color
      ),
      child: TextField(
          controller: controller.searchController,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(0),
            hintText: "Search by name",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none, // Remove the default border
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.clearSearch();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
              ),
            ),
          ) // Optional icon
          ),
    );
  }
}

class _ContactItemView extends GetView<AddDriverParticipantsController> {
  final ContactEntity contact;
  final int index;

  const _ContactItemView({
    required this.contact,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    //
    //

    return InkWell(
      onTap: () {
        if (controller.selectedDrivers.contains(contact)) {
          controller.selectedDrivers.remove(contact);
        } else {
          controller.selectedDrivers.add(contact);
        }
      },
      child: Container(
        margin: index == 0
            ? const EdgeInsets.only(top: 14, left: 8, right: 8)
            : const EdgeInsets.symmetric(
                horizontal: 8,
              ),
        child: Row(
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  contact.image ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                  width: 45,
                  height: 45,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor.applyOpacity(0.1),
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: Text(
                        contact.name?[0].toUpperCase() ?? "",
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            //
            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name ?? "",
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    contact.phone ?? "",
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
            Obx(
              () => Icon(
                controller.selectedDrivers.contains(contact)
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: controller.selectedDrivers.contains(contact)
                    ? AppColorsLight.mainColor
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

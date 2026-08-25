import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class AddParticipantsBottomSheetView extends GetView<ChatDetailController> {
  final int groupId;
  const AddParticipantsBottomSheetView({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // top header

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          decoration: const BoxDecoration(
            color: AppColorsLight.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // showing group name
              Text(
                controller.groupName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),

        Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.offNamed(
                  Routes.ADD_ADMIN_PARTICIPANTS,
                  arguments: controller.groupId.value,
                );
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColorsLight.mainColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Add Admins",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ).marginOnly(left: 14, right: 14, top: 50, bottom: 14),
            GestureDetector(
              onTap: () {
                Get.offNamed(
                  Routes.ADD_DRIVER_PARTICIPANTS,
                  arguments: controller.groupId.value,
                );
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColorsLight.mainColor)),
                child: const Center(
                  child: Text(
                    "Add Drivers",
                    style: TextStyle(
                      color: AppColorsLight.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ).marginOnly(left: 14, right: 14, bottom: 50),
          ],
        )
      ],
    );
  }
}

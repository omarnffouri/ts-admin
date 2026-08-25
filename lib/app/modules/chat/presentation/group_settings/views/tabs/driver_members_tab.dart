import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DriverMembersTab extends GetView<GroupSettingsController> {
  const DriverMembersTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomScrollView(
        key: const PageStorageKey<String>('driver_members'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          Obx(
            () =>
                controller.isSearchEnabled && controller.filteredDrivers.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            "No data",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColors.mainColor,
                            ),
                          ),
                        ),
                      )
                    : SliverList.separated(
                        itemCount: (controller.isSearchEnabled
                                ? controller.filteredDrivers
                                : controller.drivers)
                            .length,
                        itemBuilder: (context, index) {
                          final driver = (controller.isSearchEnabled
                              ? controller.filteredDrivers
                              : controller.drivers)[index];

                          return _DriverTile(
                            participant: driver,
                            index: index,
                          ).marginOnly(
                            bottom: index == controller.drivers.length - 1
                                ? 100
                                : 0,
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
                                  height: 5,
                                  color: Colors.grey.applyOpacity(0.2),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          )
        ],
      );
    });
  }
}

class _DriverTile extends GetView<GroupSettingsController> {
  final int index;

  final ParticipantEntity participant;
  const _DriverTile({
    required this.index,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showImageDialog(
                context,
                participant.image ?? "",
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ProfileImage.network(
                url: participant.image,
                width: 45,
                height: 45,
                showLetterOnError: true,
                letter: participant.name?[0].toUpperCase() ?? "",
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name ?? "",
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  participant.userDesignation ?? 'Admin',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (controller.authController.userPermissionHelper
              .canRemoveParticipantsInGroup())
            Obx(
              () => Container(
                child: controller.isRemovingParticipant &&
                        (controller.removingAtIndex == index) &&
                        (participant.modelType == ModelType.APPLICANTS)
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.showRemoveParticipantConfirmationDialog(
                            participant,
                            index,
                          );
                        },
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          color: AppColorsLight.mainColor,
                          size: 22,
                        ),
                      ),
              ).paddingSymmetric(horizontal: 10),
            )
        ],
      ),
    );
  }
}

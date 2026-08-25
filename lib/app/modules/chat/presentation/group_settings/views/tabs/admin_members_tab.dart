import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class AdminMembersTab extends GetView<GroupSettingsController> {
  const AdminMembersTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomScrollView(
        key: const PageStorageKey<String>('admin_members'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          Obx(
            () =>
                controller.isSearchEnabled && controller.filteredAdmins.isEmpty
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
                    : SlidableAutoCloseBehavior(
                        child: SliverList.separated(
                          itemCount: (controller.isSearchEnabled
                                  ? controller.filteredAdmins
                                  : controller.admins)
                              .length,
                          itemBuilder: (context, index) {
                            final admin = (controller.isSearchEnabled
                                ? controller.filteredAdmins
                                : controller.admins)[index];
                            return _AdminTile(
                              participant: admin,
                              index: index,
                            ).marginOnly(
                              bottom: index == controller.admins.length - 1
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
                      ),
          )
        ],
      );
    });
  }
}

class _AdminTile extends GetView<GroupSettingsController> {
  final int index;

  final ParticipantEntity participant;
  const _AdminTile({
    required this.index,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    final isGroupSuperAdmin =
        ((controller.groupCreatorId.value == participant.id) &&
            (participant.modelType == ModelType.USERS));

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "group_settings_participants_slide_group",
      endActionPane: controller.iAmAdmin() &&
              (!isGroupSuperAdmin) &&
              (!controller.isRemovingParticipant) &&
              (!controller.isUpdatingParticipant)
          ? ActionPane(
              openThreshold: 0.1,
              extentRatio: 0.6,
              motion: const BehindMotion(),
              children: [
                //
                //
                // group admin
                SlidableAction(
                  onPressed: (context) {
                    participant.isGroupAdmin =
                        !(participant.isGroupAdmin ?? false);
                    controller.updateParticipant(
                      participant,
                      index,
                    );
                  },
                  flex: 3,
                  backgroundColor:
                      Get.isDarkMode ? Colors.white30 : Colors.black54,
                  foregroundColor: Colors.white,
                  icon: (participant.isGroupAdmin ?? false)
                      ? Icons.person_remove_alt_1_rounded
                      : Icons.person_add_alt_1_rounded,
                  label: (participant.isGroupAdmin ?? false)
                      ? 'Remove Admin'
                      : 'Make Admin',
                ),

                //
                //
                // remove action
                SlidableAction(
                  onPressed: (context) {
                    controller.showRemoveParticipantConfirmationDialog(
                      participant,
                      index,
                    );
                  },
                  flex: 2,
                  backgroundColor: AppColorsLight.mainColor,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_forever_rounded,
                  label: 'Remove',
                ),
              ],
            )
          : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          children: [
            //
            //
            // user image
            InkWell(
              onTap: () {
                showImageDialog(
                  context,
                  participant.image ?? "",
                );
              },
              child: ProfileImage.network(
                url: participant.image,
                width: 45,
                height: 45,
                showLetterOnError: true,
                letter: participant.name?[0].capitalizeFirst ?? '',
              ),
            ),
            const SizedBox(width: 12),

            //
            //
            // name and desigination
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

            //
            //
            // admin label
            if (participant.isGroupAdmin ?? false)
              Text(
                isGroupSuperAdmin ? "Creator" : "Group Admin",
                style: const TextStyle(
                  color: AppColorsLight.mainColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

            //
            //
            // delete/update progess
            Obx(
              () => Visibility(
                visible: (controller.isRemovingParticipant &&
                        controller.removingAtIndex == index) ||
                    (controller.isUpdatingParticipant &&
                        controller.updatingParticipantAtIndex == index),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColorsLight.mainColor,
                  ),
                ).paddingSymmetric(horizontal: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/user_entity.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../controllers/all_user_controller.dart';

class UserCardWidget extends GetView<AllUserController> {
  const UserCardWidget({super.key, required this.user, required this.index});
  final UserEntity user;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color mutedColor =
        isDark ? Colors.white.applyOpacity(0.6) : AppColorsLight.textColor;

    // semantic status colors (kept consistent across light/dark)
    final Color statusColor =
        user.isSuspended ? const Color(0xFFE08600) : const Color(0xFF2E9E5B);

    // name, phone, email, address rows pairing
    final infoRows = <MapEntry<IconData, String?>>[
      MapEntry(Icons.phone_rounded, user.phone),
      MapEntry(Icons.email_rounded, user.email),
      MapEntry(Icons.location_on_rounded, user.address),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          enabled: user.id != null,
          key: ValueKey(user.id),
          closeOnScroll: true,
          groupTag: "admin_users_slide_group",
          endActionPane: ActionPane(
            extentRatio: 0.75,
            motion: const BehindMotion(),
            children: [
              if (controller.authController.userPermissionHelper.isSuperAdmin())
                SlidableAction(
                  onPressed: (context) async {
                    if (user.isSuspended) {
                      controller.activateUser(user, index);
                    } else {
                      controller.suspendUser(user, index);
                    }
                  },
                  backgroundColor:
                      user.isSuspended ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                  icon: user.isSuspended
                      ? Icons.person_add_alt_rounded
                      : Icons.person_off_rounded,
                  label: user.isSuspended ? 'Active' : 'Suspend',
                ),
              SlidableAction(
                onPressed: (context) async {
                  Get.toNamed(Routes.RESET_USER_PASSWORD, arguments: user);
                },
                backgroundColor: AppColorsLight.mainColor,
                foregroundColor: Colors.white,
                icon: FontAwesomeIcons.userLock,
                label: 'Reset',
              ),
              if (controller.authController.userPermissionHelper
                  .canUpdateUsers())
                SlidableAction(
                  onPressed: (context) async {
                    Get.toNamed(Routes.UPDATE_USER_DETAILS, arguments: user);
                  },
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_sharp,
                  label: 'Edit',
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.applyOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.applyOpacity(0.06)
                      : Colors.black.applyOpacity(0.04),
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.applyOpacity(0.09),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await Get.toNamed(
                    Routes.USER_DETAIL_VIEW,
                    arguments: user,
                  );
                  controller.users.refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // avatar with subtle ring
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColorsLight.mainColor.applyOpacity(0.18),
                            width: 1.5,
                          ),
                        ),
                        child: ProfileImage.network(
                          url: user.image,
                          width: 46,
                          height: 46,
                          showLetterOnError: true,
                          letter: (user.name?.isNotEmpty ?? false)
                              ? user.name![0].toUpperCase()
                              : "?",
                          letterBackgroundColor: AppColorsLight.mainColor,
                          letterColor: AppColorsLight.mainColor,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    user.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // status badge (or updating spinner)
                                Obx(
                                  () => (controller
                                              .isUpdatingUserStatus.value &&
                                          (controller.updatingStatusAtIndex
                                                  .value ==
                                              index))
                                      ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeCap: StrokeCap.round,
                                            strokeWidth: 3,
                                            color: statusColor,
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                statusColor.applyOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: statusColor
                                                  .applyOpacity(0.35),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: statusColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                "${user.status?.capitalizeFirst}",
                                                style: theme
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // phone, email, address
                            for (final row in infoRows)
                              if (row.value != null &&
                                  row.value!.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(row.key,
                                          size: 14, color: mutedColor),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          row.value!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: mutedColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

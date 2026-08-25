import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

/// Explains why the app needs location and microphone access before
/// triggering the actual system permission requests.
///
/// Shown when the main screen opens after login and one of the permissions
/// hasn't been granted yet (see [MainScreenController.onReady]). Closes with
/// `true` when the user agrees to continue, `false` when dismissed.
class StartupPermissionsDialog extends StatelessWidget {
  const StartupPermissionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff242424) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.applyOpacity(0.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            //
            // gradient badge
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColorsLight.mainColorLight,
                    AppColorsLight.mainColorDark,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsLight.mainColor.applyOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            //
            //
            // title + short intro
            Text(
              "Before you start",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ).marginOnly(top: 18),

            Text(
              "Allow these so you never miss a call or a shipment.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ).marginOnly(top: 6),

            //
            //
            // permission tiles
            const _PermissionTile(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Shipment tracking & clock-in",
            ).marginOnly(top: 22),

            const _PermissionTile(
              icon: Icons.mic_rounded,
              title: "Microphone",
              subtitle: "Incoming & outgoing calls",
            ).marginOnly(top: 10),

            //
            //
            // gradient continue button
            MainAppButton(
              label: "Allow Access",
              borderRadius: 16,
              trailingIcon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Get.back(result: true);
              },
            ).marginOnly(top: 24),

            //
            //
            // dismiss option
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text(
                "Maybe later",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ).marginOnly(top: 4),
          ],
        ),
      ),
    );
  }
}

/// One permission entry inside [StartupPermissionsDialog]: tinted icon,
/// name and a short reason.
class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.applyOpacity(0.05)
            : Colors.black.applyOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColorsLight.mainColor.applyOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColorsLight.mainColor,
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ).marginOnly(left: 12),
          ),
        ],
      ),
    );
  }
}

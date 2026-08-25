import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/controllers/settings_controller.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/views/components/settings_switch_tile.dart';

class OtpWidget extends StatelessWidget {
  final SettingsController controller;
  const OtpWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isConfigrationLoading.value) {
          return const _OtpTilePlaceholder();
        }

        final bool isUpdating = controller.isOtpUpdating.value;

        return SettingsSwitchTile(
          icon: Icons.security_update_good_rounded,
          title: 'Enable OTP',
          value: controller.otpEnabled.value,
          isBusy: isUpdating,
          onChanged: isUpdating
              ? null
              : (value) {
                  controller.updateOtpValue(value);
                },
        );
      },
    );
  }
}

class _OtpTilePlaceholder extends StatelessWidget {
  const _OtpTilePlaceholder();

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.white10 : Colors.black12,
        highlightColor: isDark ? Colors.white24 : Colors.black26,
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: context.surfaceVariantColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

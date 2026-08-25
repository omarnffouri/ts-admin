import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/views/widgets/otp_widget.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/settings_controller.dart';
import 'components/delete_account_dialog.dart';
import 'components/destructive_settings_tile.dart';
import 'components/settings_section.dart';
import 'components/settings_switch_tile.dart';
import 'components/settings_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            Get.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          //
          // header
          AppReadHeader(
            title: 'Settings',
            subtitle: 'Account, privacy and session',
            subtitleSemanticsLabel: 'Account, chat and session',
            onBack: Get.back,
          ),

          //
          // body
          const Expanded(
            child: SafeArea(
              top: false,
              child: _Body(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends GetView<SettingsController> {
  const _Body();

  static const EdgeInsets _padding = EdgeInsets.fromLTRB(16, 20, 16, 28);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double minHeight = (constraints.maxHeight - _padding.vertical)
            .clamp(0, double.infinity);

        return SingleChildScrollView(
          padding: _padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  // account and security
                  Obx(
                    () => SettingsSection(
                      icon: Icons.shield_outlined,
                      title: 'Account and Security',
                      children: [
                        //
                        // biometric lock
                        if (controller.biometricAvailable.value)
                          SettingsSwitchTile(
                            icon: Icons.fingerprint_rounded,
                            title: 'Biometric',
                            value: controller.biometricEnabled.value,
                            onChanged: (value) {
                              controller.biometricClicked();
                            },
                            onTap: () {
                              controller.biometricClicked();
                            },
                          ),

                        //
                        // enable otp
                        if (controller.canUpdateOtp)
                          OtpWidget(controller: controller),

                        //
                        // edit profile
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profile',
                          semanticsLabel: 'Edit Profile',
                          onTap: () {
                            Get.toNamed(Routes.UPDATE_PROFILE);
                          },
                        ),

                        //
                        // change password
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          semanticsLabel: 'Change Password',
                          onTap: () {
                            Get.toNamed(Routes.CHANGE_PASSWORD);
                          },
                        ),

                        SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policies',
                          semanticsLabel: 'Privacy Policies',
                          onTap: () async {
                            Uri url = Uri.parse(
                                'https://transport-system.com/privacy-policy/');

                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $url');
                            }
                          },
                        ),

                        //
                        // delete account
                        DestructiveSettingsTile(
                          icon: Icons.delete,
                          title: 'Delete Account',
                          semanticsLabel: 'Delete Account',
                          onTap: () =>
                              showDeleteAccountDialog(context, controller),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //
                  // chat
                  SettingsSection(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Chat',
                    children: [
                      SettingsTile(
                        icon: Icons.wallpaper_rounded,
                        title: 'Wallpaper',
                        semanticsLabel: 'Wallpaper',
                        onTap: () {
                          Get.toNamed(Routes.CHAT_THEME_SETTINGS);
                        },
                      ),
                    ],
                  ),
                  const Spacer(),

                  //
                  // logout — the app's shared primary action
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: MainAppButton(
                        label: 'Logout',
                        height: 52,
                        borderRadius: 14,
                        isLoading: controller.isLoggoingOut,
                        trailingIcon: const Icon(
                          Icons.exit_to_app_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (!controller.isLoggoingOut) controller.logout();
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  //
                  // application version
                  Center(child: Obx(
                    () {
                      final String version = controller.version.value;
                      if (version.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Semantics(
                        label: 'Application version $version',
                        excludeSemantics: true,
                        child: Text(
                          "v$version",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.tertiaryTextColor,
                          ),
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

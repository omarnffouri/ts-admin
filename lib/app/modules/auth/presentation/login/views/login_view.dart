import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/auth/presentation/login/views/widgets/login_animated_content.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? const Color(0xFF030304) : const Color(0xFFF5F6FA),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: _AnimatedTruckBackground(
                imagePath: Get.isDarkMode
                    ? Assets.images.darkLoginBg.path
                    : Assets.images.loginBgLight.path,
              ),
            ),
            SafeArea(
              child: LoginAnimatedContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTruckBackground extends StatelessWidget {
  const _AnimatedTruckBackground({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final bool isLight = !Get.isDarkMode;
    return Stack(
      fit: StackFit.expand,
      children: [
        // cover fills the screen; both images fade to the scaffold color at
        // the bottom, so the photo blends in with no white/black seam.
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isLight
                  ? [
                      Colors.white.applyOpacity(0),
                      Colors.white.applyOpacity(0.08),
                      Colors.white.applyOpacity(0.3),
                    ]
                  : [
                      Colors.black.applyOpacity(0.18),
                      Colors.black.applyOpacity(0.42),
                      Colors.black.applyOpacity(0.86),
                    ],
              stops: const [0, 0.48, 1],
            ),
          ),
        ),
      ],
    );
  }
}

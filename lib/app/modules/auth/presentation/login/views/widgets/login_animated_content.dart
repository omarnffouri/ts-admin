import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_dialog.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../controllers/login_controller.dart';
import 'glass_text_field.dart';

class LoginAnimatedContent extends StatefulWidget {
  const LoginAnimatedContent({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  State<LoginAnimatedContent> createState() => _LoginAnimatedContentState();
}

class _LoginAnimatedContentState extends State<LoginAnimatedContent>
    with SingleTickerProviderStateMixin {
  static const _whiteLogo = 'assets/images/app_logo_white.png';

  late final AnimationController _entryController;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardBlur;
  late final Animation<double> _emailFade;
  late final Animation<Offset> _emailSlide;
  late final Animation<double> _passwordFade;
  late final Animation<Offset> _passwordSlide;
  late final Animation<double> _actionsFade;
  late final Animation<Offset> _actionsSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _logoFade = _curved(0.05, 0.45);
    _logoSlide = _slide(
      begin: const Offset(0, -0.34),
      start: 0.05,
      end: 0.45,
    );
    _cardFade = _curved(0.22, 0.72);
    _cardSlide = _slide(
      begin: const Offset(0, 0.16),
      start: 0.22,
      end: 0.72,
    );
    _cardBlur = Tween<double>(begin: 18, end: 0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.22, 0.72, curve: Curves.easeOutCubic),
      ),
    );
    _emailFade = _curved(0.48, 0.72);
    _emailSlide = _slide(begin: const Offset(0, 0.18), start: 0.48, end: 0.72);
    _passwordFade = _curved(0.58, 0.82);
    _passwordSlide =
        _slide(begin: const Offset(0, 0.18), start: 0.58, end: 0.82);
    _actionsFade = _curved(0.66, 0.9);
    _actionsSlide = _slide(begin: const Offset(0, 0.18), start: 0.66, end: 0.9);
    _buttonFade = _curved(0.76, 1);
    _buttonSlide = _slide(begin: const Offset(0, 0.2), start: 0.76, end: 1);
  }

  Animation<double> _curved(double start, double end) {
    return CurvedAnimation(
      parent: _entryController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Animation<Offset> _slide({
    required Offset begin,
    required double start,
    required double end,
  }) {
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              FadeTransition(
                opacity: _logoFade,
                child: SlideTransition(
                  position: _logoSlide,
                  child: Image.asset(
                    Get.isDarkMode ? _whiteLogo : Assets.images.tsflogo.path,
                    width: 220.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 190.h),
              FadeTransition(
                opacity: _cardFade,
                child: SlideTransition(
                  position: _cardSlide,
                  child: AnimatedBuilder(
                    animation: _cardBlur,
                    builder: (context, child) {
                      return ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: _cardBlur.value,
                          sigmaY: _cardBlur.value,
                        ),
                        child: child,
                      );
                    },
                    child: _GlassLoginCard(
                      controller: widget.controller,
                      emailFade: _emailFade,
                      emailSlide: _emailSlide,
                      passwordFade: _passwordFade,
                      passwordSlide: _passwordSlide,
                      actionsFade: _actionsFade,
                      actionsSlide: _actionsSlide,
                      buttonFade: _buttonFade,
                      buttonSlide: _buttonSlide,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}

class _GlassLoginCard extends StatelessWidget {
  const _GlassLoginCard({
    required this.controller,
    required this.emailFade,
    required this.emailSlide,
    required this.passwordFade,
    required this.passwordSlide,
    required this.actionsFade,
    required this.actionsSlide,
    required this.buttonFade,
    required this.buttonSlide,
  });

  final LoginController controller;
  final Animation<double> emailFade;
  final Animation<Offset> emailSlide;
  final Animation<double> passwordFade;
  final Animation<Offset> passwordSlide;
  final Animation<double> actionsFade;
  final Animation<Offset> actionsSlide;
  final Animation<double> buttonFade;
  final Animation<Offset> buttonSlide;

  @override
  Widget build(BuildContext context) {
    final maxWidth = math.min(Get.width - 44.w, 420.w);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            width: maxWidth,
            padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 22.h),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? const Color(0xFF100D10).applyOpacity(0.72)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.white.applyOpacity(0.16)
                    : Colors.black.applyOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.applyOpacity(Get.isDarkMode ? 0.48 : 0.12),
                  blurRadius: 26.r,
                  offset: Offset(0, 16.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Sign in to manage shipments, drivers, and fleet activity.',
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white.applyOpacity(0.58)
                        : Colors.black.applyOpacity(0.58),
                    fontSize: 12.5.sp,
                    height: 1.35,
                    letterSpacing: 0,
                  ),
                ),
                Obx(
                  () => controller.isBiometricAvaibale.value
                      ? Padding(
                          padding: EdgeInsets.only(top: 18.h),
                          child: _BiometricShortcut(controller: controller),
                        )
                      : const SizedBox.shrink(),
                ),
                SizedBox(height: 10.h),
                _Reveal(
                  fade: emailFade,
                  slide: emailSlide,
                  child: GlassTextField(
                    controller: controller.emailController,
                    hintText: 'Email address',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 14.h),
                _Reveal(
                  fade: passwordFade,
                  slide: passwordSlide,
                  child: GlassTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline_rounded,
                    passwordView: true,
                  ),
                ),
                SizedBox(height: 16.h),
                _Reveal(
                  fade: actionsFade,
                  slide: actionsSlide,
                  child: _RememberForgotRow(controller: controller),
                ),
                SizedBox(height: 22.h),
                _Reveal(
                  fade: buttonFade,
                  slide: buttonSlide,
                  child: Obx(
                    () => MainAppButton(
                      label: 'Login',
                      isLoading: controller.isLoading,
                      onPressed: controller.login,
                      height: 40.h,
                      borderRadius: 12.r,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                      trailingIcon: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // create account or signup button
                if (Platform.isIOS)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Get.theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(
                            context: Get.context!,
                            title: Text(
                              "Select Category",
                              style: Get.theme.textTheme.titleLarge,
                            ),
                          );
                        },
                        child: Text(
                          "Signup",
                          style: Get.theme.textTheme.bodyLarge?.copyWith(
                              color: AppColorsLight.mainColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ).paddingOnly(left: 10)
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BiometricShortcut extends StatelessWidget {
  const _BiometricShortcut({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: (Get.isDarkMode ? Colors.white : Colors.black)
            .applyOpacity(Get.isDarkMode ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColorsLight.mainColor.applyOpacity(0.24)),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: controller.onBiometricLoginClicked,
            child: Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3947), Color(0xFF8B0007)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsLight.mainColor.applyOpacity(0.35),
                    blurRadius: 18.r,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometric login available',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Tap the fingerprint for quick access.',
                  style: TextStyle(
                    color: (Get.isDarkMode ? Colors.white : Colors.black)
                        .applyOpacity(0.52),
                    fontSize: 11.sp,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberForgotRow extends StatelessWidget {
  const _RememberForgotRow({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: controller.rememberMe.value,
              onChanged: (value) =>
                  controller.rememberMe.value = value ?? false,
              activeColor: const Color(0xFFE50914),
              checkColor: Colors.white,
              side: BorderSide(
                color: (Get.isDarkMode ? Colors.white : Colors.black)
                    .applyOpacity(0.35),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            'Remember me',
            style: TextStyle(
              color: (Get.isDarkMode ? Colors.white : Colors.black)
                  .applyOpacity(0.68),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF3B48),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Get.snackbar(
              'Password reset',
              'Please contact your administrator to reset your password.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black.applyOpacity(0.86),
              colorText: Colors.white,
            );
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.fade,
    required this.slide,
    required this.child,
  });

  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}

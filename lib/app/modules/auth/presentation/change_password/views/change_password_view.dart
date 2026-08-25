import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import '../controllers/change_password_controller.dart';
import 'components/password_section.dart';
import 'components/security_intro_card.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            //
            // header
            AppReadHeader(
              title: 'Update Password',
              subtitle: 'Keep your account protected',
              subtitleSemanticsLabel: 'Keep your account protected',
              onBack: Get.back,
            ),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _Body(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final ChangePasswordController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // security introduction
            const SecurityIntroCard(),

            const SizedBox(height: 20),

            //
            // password fields
            const PasswordSection(),

            const SizedBox(height: 24),

            //
            // update button — the app's shared primary action
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: MainAppButton(
                  label: 'Update Password',
                  height: 52,
                  borderRadius: 14,
                  isLoading: controller.isUpdatingPassword,
                  leadingIcon: const Icon(
                    Icons.check_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: _onSubmit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Submission is unchanged — `updateProfile()` still runs the same checks,
  /// sends the same payload and owns the outcome. The validate() call is
  /// display-only: it surfaces each existing message beneath its field.
  void _onSubmit() {
    if (controller.isUpdatingPassword) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool isValid = controller.formKey.currentState?.validate() ?? false;
    if (!isValid) {
      _revealFirstInvalidField();
    }

    controller.updateProfile();
  }

  /// Scrolls to — and focuses — the first field that reported an error, so a
  /// failure below the fold is never silent.
  void _revealFirstInvalidField() {
    for (final field in controller.orderedFields) {
      final FormFieldState<String>? state = field.key.currentState;
      if (state == null || !state.hasError) {
        continue;
      }

      final BuildContext? fieldContext = field.key.currentContext;
      if (fieldContext != null) {
        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      }
      field.value.requestFocus();
      return;
    }
  }
}

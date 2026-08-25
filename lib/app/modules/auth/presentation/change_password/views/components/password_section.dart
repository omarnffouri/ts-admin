import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/shop_form/shop_form_section.dart';

import '../../controllers/change_password_controller.dart';
import 'password_field.dart';

class PasswordSection extends GetView<ChangePasswordController> {
  const PasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ShopFormSection(
      icon: Icons.lock_outline_rounded,
      title: 'Change Password',
      children: [
        //
        // current password
        PasswordField(
          fieldKey: controller.currentPasswordKey,
          controller: controller.currentPasswordController,
          focusNode: controller.currentPasswordFocusNode,
          label: 'Current Password',
          hintText: 'Enter current password',
          semanticsLabel: 'Current password, required',
          showToggleLabel: 'Show current password',
          hideToggleLabel: 'Hide current password',
          autofillHints: const [AutofillHints.password],
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(controller.newPasswordFocusNode),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a current password.";
            }
            return null;
          },
        ),

        //
        // new password
        PasswordField(
          fieldKey: controller.newPasswordKey,
          controller: controller.newPasswordController,
          focusNode: controller.newPasswordFocusNode,
          label: 'New Password',
          hintText: 'Enter new password',
          semanticsLabel: 'New password, required',
          showToggleLabel: 'Show new password',
          hideToggleLabel: 'Hide new password',
          autofillHints: const [AutofillHints.newPassword],
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(controller.confirmPasswordFocusNode),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a new password.";
            }
            if (value.length < 8) {
              return "New Password length must be greater or equal to 8.";
            }
            return null;
          },
        ),

        //
        // confirm password
        PasswordField(
          fieldKey: controller.confirmPasswordKey,
          controller: controller.confirmPasswordController,
          focusNode: controller.confirmPasswordFocusNode,
          label: 'Confirm Password',
          hintText: 'Re-enter new password',
          semanticsLabel: 'Confirmed password, required',
          showToggleLabel: 'Show confirmed password',
          hideToggleLabel: 'Hide confirmed password',
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a confirm password.";
            }
            if (value.length < 8) {
              return "Confirm Password length must be greater or equal to 8.";
            }
            if (controller.newPasswordController.text != value) {
              return "Confirm Password not matched.";
            }
            return null;
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/shop_form/shop_form_section.dart';

import '../controllers/update_profile_controller.dart';
import 'components/editable_profile_avatar.dart';
import 'components/profile_form_fields.dart';
import 'components/profile_information_section.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: const Column(
          children: [
            //
            // header
            _Header(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _Body(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final ProfileFormFields _fields = ProfileFormFields();
  final UpdateProfileController _controller =
      Get.find<UpdateProfileController>();

  @override
  void dispose() {
    _fields.dispose();
    super.dispose();
  }

  /// Submission is unchanged — `updateProfile()` still runs the same checks,
  /// builds the same payload and owns the outcome. This only guards against a
  /// second tap while a request is in flight and reveals the field the
  /// controller is about to reject.
  void _onSubmit() {
    if (_controller.isUpdatingProfile) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    _revealFirstInvalidField();

    _controller.updateProfile();
  }

  /// Mirrors the checks inside `UpdateProfileController.updateProfile` purely to
  /// decide which field to scroll to and focus. The controller still runs those
  /// checks itself and owns the resulting message.
  void _revealFirstInvalidField() {
    if (_controller.firstNameController.text.isEmpty) {
      _reveal(_fields.firstNameKey, _fields.firstNameFocusNode);
    } else if (_controller.lastNameController.text.isEmpty) {
      _reveal(_fields.lastNameKey, _fields.lastNameFocusNode);
    } else if (_controller.phoneController.text.length < 11) {
      _reveal(_fields.phoneKey, _fields.phoneFocusNode);
    }
  }

  void _reveal(GlobalKey fieldKey, FocusNode focusNode) {
    final BuildContext? fieldContext = fieldKey.currentContext;
    if (fieldContext != null) {
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.1,
      );
    }
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // profile photo
          const ShopFormSection(
            icon: Icons.photo_camera_outlined,
            title: 'Profile Photo',
            children: [EditableProfileAvatar()],
          ),

          const SizedBox(height: 20),

          //
          // personal information
          ProfileInformationSection(fields: _fields),

          const SizedBox(height: 24),

          //
          // update button — the app's shared primary action
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: MainAppButton(
                label: 'Update Profile',
                height: 52,
                borderRadius: 14,
                isLoading: _controller.isUpdatingProfile,
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
    );
  }
}

/// Shared brand-gradient header used by the redesigned pages.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return AppReadHeader(
      title: 'Update Basic Profile',
      subtitle: 'Photo and personal details',
      subtitleSemanticsLabel: 'Photo and personal details',
      onBack: Get.back,
    );
  }
}

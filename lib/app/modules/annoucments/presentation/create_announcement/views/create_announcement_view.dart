import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../controllers/create_announcement_controller.dart';
import 'components/announcement_file_view.dart';
import 'components/audience_mode_toggle.dart';
import 'components/category_dropdown_widget.dart';
import 'components/description_widget.dart';
import 'components/multiple_search_dropdown.dart';
import 'components/topic_dropdown_widget.dart';

class CreateAnnouncementView extends GetView<CreateAnnouncementController> {
  const CreateAnnouncementView({super.key});

  static const Duration _sectionDuration = Duration(milliseconds: 260);
  static const Curve _sectionCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            //
            // header
            const _Header(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _BodyReveal(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          // title
                          const _SectionLabel(
                            icon: Icons.title_rounded,
                            label: 'Title',
                            isRequired: true,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => LoadingWrapperWidget(
                              isLoading: controller.isLoading.value,
                              child: const _TitleField(),
                            ),
                          ),
                          const SizedBox(height: 22),

                          //
                          // description
                          const DescriptionWidget(),
                          const SizedBox(height: 22),

                          //
                          // audience (user type dropdown)
                          const _SectionLabel(
                            icon: Icons.groups_rounded,
                            label: 'Audience',
                            isRequired: true,
                          ),
                          const SizedBox(height: 8),
                          const CategoryDropdownWidget(),
                          const SizedBox(height: 18),

                          //
                          // drivers-only: pick audience mode (specific / topic)
                          Obx(
                            () => AnimatedSize(
                              duration: _sectionDuration,
                              curve: _sectionCurve,
                              alignment: Alignment.topCenter,
                              child: controller.isDriversType
                                  ? const AudienceModeToggle()
                                  : const SizedBox(width: double.infinity),
                            ),
                          ),

                          //
                          // topic dropdown (drivers + topic mode)
                          Obx(
                            () => AnimatedSize(
                              duration: _sectionDuration,
                              curve: _sectionCurve,
                              alignment: Alignment.topCenter,
                              child: controller.isDriversType &&
                                      controller.isTopicMode
                                  ? const TopicDropdownWidget()
                                  : const SizedBox(width: double.infinity),
                            ),
                          ),

                          //
                          // multiple search dropdown
                          Obx(
                            () => AnimatedSize(
                              duration: _sectionDuration,
                              curve: _sectionCurve,
                              alignment: Alignment.topCenter,
                              child: controller.showUserMultiSelect
                                  ? const Padding(
                                      padding: EdgeInsets.only(bottom: 18),
                                      child: MultipleSearchDropdown(),
                                    )
                                  : const SizedBox(width: double.infinity),
                            ),
                          ),

                          //
                          // file view
                          const AnnouncementFileView(),
                          const SizedBox(height: 28),

                          //
                          // create button

                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: MainAppButton(
                                label: 'Create Announcement',
                                height: 52,
                                borderRadius: 14,
                                isLoading: controller.isSubmitting.value,
                                leadingIcon: const Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (controller.isSubmitting.value) {
                                    return;
                                  }
                                  controller.createAnnouncement();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Brand-gradient header matching the rest of the app (AppRedHeader with a
/// frosted back button and a bold white title).
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          //
          // back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          //
          // heading
          Expanded(
            child: Text(
              "Create Announcement",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Muted icon + label heading shared by every section on the page.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    this.isRequired = false,
  });

  final IconData icon;
  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: context.secondaryTextColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: context.brandColor),
          ),
      ],
    );
  }
}

/// Title input styled like the app's card-surface fields: filled background,
/// hairline idle border, and a brand-colored focus ring.
class _TitleField extends GetView<CreateAnnouncementController> {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: context.focusedBorderColor,
        width: 1.4,
      ),
    );

    return TextFormField(
      controller: controller.titleController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: 50,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: context.fieldFillColor,
        isDense: true,
        hintText: "Announcement title",
        hintStyle: TextStyle(color: context.hintTextColor, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: idleBorder,
        enabledBorder: idleBorder,
        focusedBorder: focusedBorder,
      ),
    );
  }
}

class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

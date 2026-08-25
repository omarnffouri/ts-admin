import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../controllers/create_inspection_request_controller.dart';
import 'components/category_dropdown_widget.dart';
import 'components/unit_dropdown_widget.dart';

class CreateInspectionRequestView
    extends GetView<CreateInspectionRequestController> {
  const CreateInspectionRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    header: const WaterDropMaterialHeader(),
                    onRefresh: controller.handleRefresh,
                    child: const _FormBody(),
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
              "New Inspection Request",
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

/// Scrollable request form: category + unit dropdowns and the create action.
class _FormBody extends GetView<CreateInspectionRequestController> {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // intro line
            Text(
              'Select a category and unit to create a request.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 20),

            //
            // category dropdown
            const CategoryDropdownWidget(),
            const SizedBox(height: 20),

            //
            // unit / driver dropdown
            const UnitDropdownWidet(),
            const SizedBox(height: 28),

            //
            // create button
            Obx(
              () => MainAppButton(
                label: "Create",
                isLoading: controller.isSubmitting.value,
                leadingIcon: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.playlist_add_check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  if (controller.isSubmitting.value) {
                    return;
                  }
                  controller.createInspectionRequest();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
/// Skipped entirely when the platform requests reduced motion.
class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

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

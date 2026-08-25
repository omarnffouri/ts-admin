import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/helpers/clipboard_helper.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/applications_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ApplicationsView extends GetView<ApplicationsController> {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            //
            // header (title + collapsible search)
            const _Header(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _BodyReveal(
                  child: Column(
                    children: [
                      const SizedBox(height: 14),

                      //
                      // statuses list
                      const _StatusesListView(),

                      const SizedBox(
                        height: 12,
                      ),

                      //
                      // applications list
                      Expanded(
                        child: Obx(
                          () => SmartRefresher(
                            controller: controller.refreshController,
                            header: const WaterDropMaterialHeader(),
                            onRefresh: controller.handleRefesh,
                            child: controller.isLoadingApplications
                                ? _buildLoadingView(context)
                                : controller.applications.isEmpty
                                    ? _buildEmptyState()
                                    : ListView.builder(
                                        itemCount:
                                            controller.applications.length,
                                        itemBuilder: (context, index) {
                                          final application = controller
                                              .applications
                                              .elementAt(index);

                                          if (index ==
                                              (controller.applications.length -
                                                  1)) {
                                            controller.loadMoreApplications();
                                          }
                                          return _ApplicationItemView(
                                            application: application,
                                            index: index,
                                          );
                                        },
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool isFiltering = controller.searchController.text.isNotEmpty ||
        controller.selectedStatus.value != ApplicationStatuses.all;

    return EmptyStateView(
      icon:
          isFiltering ? Icons.search_off_rounded : Icons.person_search_rounded,
      title: "No applications found",
      message: isFiltering
          ? "Nothing matches your search or status filter. Try adjusting them."
          : "New job applications will appear here as they come in.",
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    final bool isDark = context.isDark;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.white10 : Colors.black12,
          highlightColor: isDark ? Colors.white24 : Colors.white30,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends GetView<ApplicationsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              //
              // back button
              _HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Get.back(),
              ),

              SizedBox(width: 12.w),

              //
              // heading
              Expanded(
                child: Text(
                  'Human Resources',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              //
              // search toggle
              Obx(
                () => _HeaderIconButton(
                  icon: controller.isSearchEnabled
                      ? Icons.search_off_rounded
                      : Icons.search_rounded,
                  onTap: () {
                    if (controller.isSearchEnabled) {
                      if (controller.searchController.text.isNotEmpty) {
                        controller.onSearch();
                      }
                      controller.searchController.clear();
                    }
                    controller.toggleSearch();
                  },
                ),
              ),
            ],
          ),

          //
          // collapsible search field
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: controller.isSearchEnabled ? 48 : 0,
              margin: EdgeInsets.only(top: controller.isSearchEnabled ? 12 : 0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: controller.isSearchEnabled ? 1 : 0,
                child: SingleChildScrollView(
                  child: _buildSearchField(theme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Frosted search field integrated with the header gradient, matching the
  /// segmented-control track styling used across the app's headers.
  Widget _buildSearchField(ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.applyOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.applyOpacity(0.20),
        ),
      ),
      child: TextField(
        controller: controller.searchController,
        maxLines: 1,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (value) {
          controller.onSearch();
        },
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search by name, email, ssn, phone",
          hintStyle: TextStyle(
            color: Colors.white.applyOpacity(0.7),
            fontSize: 14,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.white.applyOpacity(0.8),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchController,
            builder: (context, value, _) {
              return value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.white.applyOpacity(0.8),
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.onSearch();
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class _StatusesListView extends GetView<ApplicationsController> {
  const _StatusesListView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.statuses.length,
        itemBuilder: (context, index) {
          //
          // current item
          final ApplicationStatuses item = controller.statuses.elementAt(index);

          //
          // chip view
          return Padding(
            padding: EdgeInsets.only(
              right: index == (controller.statuses.length - 1) ? 0 : 10,
            ),
            child: Obx(
              () {
                final bool selected = controller.selectedStatus.value == item;

                return GestureDetector(
                  onTap: () {
                    controller.selectedStatus.value = item;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color:
                          selected ? context.brandColor : context.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : isDark
                                ? Colors.white.applyOpacity(0.12)
                                : Colors.black.applyOpacity(0.06),
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.applyOpacity(0.30)
                                    : context.brandColor.applyOpacity(0.30),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      style: (theme.textTheme.labelLarge ?? const TextStyle())
                          .copyWith(
                        color: selected
                            ? Colors.white
                            : isDark
                                ? Colors.white.applyOpacity(0.9)
                                : context.brandColor,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                      child: Text(item.getName()),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ApplicationItemView extends GetView<ApplicationsController> {
  final ApplicationEntity application;
  final int index;
  const _ApplicationItemView({
    required this.application,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;

    return Container(
      margin: EdgeInsets.only(
        bottom: index == (controller.applications.length - 1) ? 50 : 0,
      ),
      child: Column(
        children: [
          //
          // application card
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: index == 0 ? 10 : 5,
              left: 16,
              right: 16,
              bottom: index == (controller.applications.length - 1) ? 20 : 5,
            ),
            decoration: BoxDecoration(
              color: context.fieldFillColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.hairlineBorderColor),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.applyOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.toNamed(
                    Routes.APPLICATION_DETAIL_VIEW,
                    arguments: application.id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // name , job category
                      Row(
                        children: [
                          //
                          // name
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: application.name ?? "",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    try {
                                      ClipboardHelper.copyPlainText(
                                        application.name ?? "",
                                        showSnackBar: true,
                                        message: "Name copied successfully.",
                                      );
                                    } catch (_) {}
                                  },
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          //
                          // job category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: application.jobCategory ==
                                      JobCategories.driver
                                  ? isDark
                                      ? Colors.transparent
                                      : Colors.white.applyOpacity(0.3)
                                  : context.brandColor,
                              border: Border.all(
                                  color: context.brandColor, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  application.jobCategory?.getName() ?? "",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: application.jobCategory ==
                                            JobCategories.driver
                                        ? isDark
                                            ? Colors.white
                                            : context.brandColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (application.isOwnerPartner ?? false)
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "P",
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      //
                      // email
                      _buildDetailRow(
                        context,
                        Icons.email_rounded,
                        application.email ?? "N/A",
                        "Email",
                      ),

                      const SizedBox(height: 5),

                      //
                      // phone
                      _buildDetailRow(
                        context,
                        Icons.phone,
                        application.mobileNumber ?? "N/A",
                        "Phone Number",
                      ),

                      const SizedBox(height: 5),

                      //
                      // SSN and status date time
                      Row(
                        children: [
                          //
                          // ssno
                          Expanded(
                            child: _buildDetailRow(
                              context,
                              Icons.credit_card_rounded,
                              application.ssNo ?? "N/A",
                              "SSN",
                            ),
                          ),

                          //
                          // status date time
                          Text(
                            "${application.applicationDate ?? ""} at ${application.applicationTime ?? ""}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.hintTextColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //
          // loading more progress view
          Obx(
            () => Visibility(
              visible: controller.isLoadingMore &&
                  index == (controller.applications.length - 1),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: context.brandColor,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String details, String type) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: context.hintTextColor,
        ).marginOnly(right: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: details,
              style: theme.textTheme.bodyMedium,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  try {
                    ClipboardHelper.copyPlainText(
                      details,
                      showSnackBar: true,
                      message: "$type copied successfully.",
                    );
                  } catch (_) {}
                },
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
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

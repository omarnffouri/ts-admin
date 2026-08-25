import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';

import '../../components/inspection_page_header.dart';
import '../controllers/inspection_details_controller.dart';
import 'components/inspection_checks_widget.dart';
import 'components/inspection_info_widget.dart';
import 'components/inspection_signature_widget.dart';

/// Read-only details of a submitted inspection — one shared page for driver,
/// truck and trailer inspections.
class InspectionDetailsView extends GetView<InspectionDetailsController> {
  const InspectionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          //
          // header
          const InspectionPageHeader(title: 'Inspection Details'),

          //
          // body
          Expanded(
            child: SafeArea(
              top: false,
              child: SmartRefresher(
                controller: controller.refreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRefresh,
                child: CustomScrollView(
                  slivers: [
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const LoadingView();
                      }
                      if (controller.inspectionDetails.inspection == null) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: _NotFoundView(),
                        );
                      }
                      return const InspectionDetailsBody();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionDetailsBody extends StatelessWidget {
  const InspectionDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 18, 16, 28),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // result, subject and recorded information
            InspectionOverviewSection(),
            SizedBox(height: 20),

            //
            // recorded results
            InspectionChecksWidget(),
            SizedBox(height: 20),

            //
            // signature
            InspectionSignatureWidget(),
          ],
        ),
      ),
    );
  }
}

/// Empty / failed-load state. Retries through the controller's existing
/// fetch, and stays scrollable so pull-to-refresh keeps working.
class _NotFoundView extends GetView<InspectionDetailsController> {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Rendered inside SliverFillRemaining — no scroll view of its own, the
    // page's CustomScrollView owns the gesture.
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.brandColor.applyOpacity(0.08),
                  border: Border.all(
                    color: context.brandColor.applyOpacity(0.12),
                  ),
                ),
                child: Icon(
                  Icons.assignment_late_outlined,
                  size: 38,
                  color: context.brandColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Inspection not available',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We could not load this inspection. Pull down to refresh or '
                'try again.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.secondaryTextColor,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: 'Try loading the inspection again',
                child: TextButton.icon(
                  onPressed: controller.getInspectionDetails,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(64, 48),
                    foregroundColor: context.brandColor,
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    'Try again',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: context.brandColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton of the loaded layout, using the app's shimmer wrapper.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonBlock(height: 92),
            const SizedBox(height: 20),
            const _SkeletonBlock(height: 150),
            const SizedBox(height: 20),
            const _SkeletonBlock(height: 180),
            const SizedBox(height: 20),
            ...List<Widget>.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: _SkeletonBlock(height: 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return LoadingWrapperWidget(
      isLoading: true,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: context.surfaceColor.applyOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

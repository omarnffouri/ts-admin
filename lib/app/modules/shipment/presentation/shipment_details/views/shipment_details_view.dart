import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/modules/shipment/presentation/shipment_details/views/components/shipment_details_loading_view.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';

import '../controllers/shipment_details_controller.dart';
import 'components/additional_charges_section.dart';
import 'components/billing_charges_section.dart';
import 'components/shipment_documents_section.dart';
import 'components/shipment_information_section.dart';
import 'components/shipment_overview_card.dart';
import 'components/shipment_stops_timeline.dart';

class ShipmentDetailsView extends GetView<ShipmentDetailsController> {
  const ShipmentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SafeArea(
                top: false,
                child: Obx(() => _buildBody(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return const ShipmentDetailsLoadingView();
    }

    if (controller.errorMessage.value != null) {
      return _ErrorView(
        message: controller.errorMessage.value!,
        onRetry: controller.getShipmentDetails,
      );
    }

    if (controller.shipmentDetails == null) {
      return const _NotFoundView();
    }

    return SmartRefresher(
      controller: controller.refreshController,
      header: const WaterDropMaterialHeader(),
      onRefresh: controller.handleShipmentRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: const [
          ShipmentOverviewCard(),
          SizedBox(height: 12),
          ShipmentInformationSection(),
          SizedBox(height: 12),
          BillingChargesSection(),
          SizedBox(height: 12),
          AdditionalChargesSection(),
          SizedBox(height: 12),
          ShipmentStopsTimeline(),
          SizedBox(height: 12),
          ShipmentDocumentsSection(),
        ],
      ),
    );
  }
}

class _Header extends GetView<ShipmentDetailsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
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
          Expanded(
            child: Obx(
              () => Text(
                controller.title.value.isEmpty
                    ? 'Shipment'
                    : controller.title.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyStateView(
                icon: Icons.cloud_off_rounded,
                title: 'Unable to load shipment',
                message: message,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.brandColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('Try again'.tr),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyStateView(
            icon: Icons.local_shipping_outlined,
            title: 'Shipment not found',
            message:
                "This shipment couldn't be found. It may have been removed.",
          ),
        ),
      ],
    );
  }
}

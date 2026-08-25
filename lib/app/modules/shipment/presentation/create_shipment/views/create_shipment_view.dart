import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/tabs/sc_delivery_tab.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/tabs/sc_general_tab.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/tabs/sc_pickup_tab.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/tabs/sc_preview_tab.dart';

import '../controllers/create_shipment_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

class CreateShipmentView extends GetView<CreateShipmentController> {
  const CreateShipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.canPopWithoutConfirmation,
        onPopInvokedWithResult: (didPop, result) {
          controller.onBackPressed(didPop);
        },
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          body: Column(
            children: [
              //
              // header
              const _Header(),

              //
              // body
              Expanded(
                child: SafeArea(
                  top: false,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        //
                        // general tab
                        SCGeneralTab(),

                        //
                        // pickup tab
                        SCPickupTab(),

                        //
                        // delivery tab
                        SCDeliveryTab(),

                        //
                        // preview tab
                        SCPreviewTab(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Brand-gradient header shared with the rest of the app (AppRedHeader with a
/// frosted back button). Below the title, a compact progress row is shown
/// only while the general sub-stepper is active — the outer pickup/delivery/
/// preview tabs are a separate flow and keep their own in-page navigation.
class _Header extends GetView<CreateShipmentController> {
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
              Semantics(
                button: true,
                label: 'Go back',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.onBackPressed(false),
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
              ),

              SizedBox(width: 12.w),

              //
              // heading
              Expanded(
                child: Text(
                  "Create Quick Shipment",
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

          //
          // general sub-stepper progress (hidden on the other outer tabs)
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: controller.shipmentCreationState.value ==
                      ShipmentCreationStates.general
                  ? Padding(
                      padding: EdgeInsets.only(top: 14.h),
                      child: const _GeneralStepProgress(),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact "Step X of N · Name" indicator for the general sub-stepper,
/// derived from the actual step configuration rather than a fixed count.
class _GeneralStepProgress extends GetView<CreateShipmentController> {
  const _GeneralStepProgress();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Obx(() {
      final int current = controller.shipmentCreationGeneralState.value;
      final int total = ShipmentCreationGeneralStates.values.length;
      final String stepName = controller.getGeneralStepName(current);

      return Semantics(
        label: 'Step ${current + 1} of $total, $stepName',
        child: Row(
          children: [
            Text(
              '${current + 1}/$total',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0.0,
                    end: (current + 1) / total,
                  ),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 5,
                    color: Colors.white,
                    backgroundColor: Colors.white30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                stepName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.applyOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

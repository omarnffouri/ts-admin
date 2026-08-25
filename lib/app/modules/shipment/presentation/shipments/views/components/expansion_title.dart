import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';

import '../../controllers/shipments_controller.dart';

class ExpansionTitle extends GetView<ShipmentsController> {
  const ExpansionTitle({
    super.key,
    required this.shipment,
    required this.showArrow,
  });
  final ShipmentEntity shipment;
  final RxDouble showArrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(shipment.shipmentNumber ?? 'N/A', shipment.status ?? ''),
        SizedBox(height: 12.h),
        _buildDrivers(),
        SizedBox(height: 2.h),
        // Center(
        //   child: GestureDetector(
        //       onTap: () {
        //         controller.handleExpantionClicks(shipment);
        //       },
        //       child: Icon(
        //         Icons.keyboard_arrow_down_rounded,
        //         color: Colors.white.applyOpacity(0.58),
        //       )),
        // ),
        // Container(
        //   height: 1,
        //   color: Get.isDarkMode
        //       ? Colors.white.applyOpacity(0.08)
        //       : Colors.black.applyOpacity(0.05),
        // ),
        _ExpandButton(
          progress: showArrow,
          onTap: () {
            controller.handleExpantionClicks(shipment);
          },
        ),
      ],
    );
  }

  Widget _buildHeader(String number, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColorsLight.mainColor.applyOpacity(
              Get.isDarkMode ? 0.18 : 0.08,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SvgPicture.asset(
            'assets/icons/shipments.svg',
            width: 18.r,
            height: 18.r,
            colorFilter: ColorFilter.mode(
              Get.isDarkMode
                  ? AppColorsDark.bnIconsSelectedColor
                  : AppColorsLight.mainColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            number,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Get.theme.textTheme.titleMedium?.copyWith(
              color: Get.isDarkMode ? Colors.white : const Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        _StatusBadge(status: status),
      ],
    );
  }

  Widget _buildDrivers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < (shipment.drivers ?? []).length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.white.applyOpacity(0.10)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  getDriverType(shipment.drivers![i].type),
                  style: Get.theme.textTheme.labelSmall?.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white.applyOpacity(0.78)
                        : const Color(0xFF4B5563),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  shipment.drivers![i].name ?? 'N/A',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    color:
                        Get.isDarkMode ? Colors.white : const Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              if (shipment.drivers![i].settlementStatus != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: getSettlementStatusColor(
                      shipment.drivers![i].settlementStatus,
                    ).applyOpacity(0.40),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    formatSettlementStatus(
                      shipment.drivers![i].settlementStatus,
                    ),
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
              Text(
                'T:${shipment.drivers![i].truck}',
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: Get.isDarkMode
                      ? Colors.white.applyOpacity(0.54)
                      : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (i != shipment.drivers!.length - 1) SizedBox(height: 8.h),
        ]
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = getShipmentStatusColor(status);

    return Container(
      constraints: BoxConstraints(maxWidth: 138.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: statusColor.applyOpacity(Get.isDarkMode ? 0.20 : 0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: statusColor.applyOpacity(Get.isDarkMode ? 0.28 : 0.20),
        ),
      ),
      child: Text(
        status.formatStatus(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Get.theme.textTheme.labelSmall?.copyWith(
          color: Get.isDarkMode ? Colors.white : statusColor,
          fontWeight: FontWeight.w800,
          height: 1.15,
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({
    required this.progress,
    required this.onTap,
  });

  final RxDouble progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Align(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: 1 - progress.value,
          duration: const Duration(milliseconds: 160),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: progress.value == 1 ? null : onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22.r,
                  color: Get.isDarkMode
                      ? Colors.white.applyOpacity(0.58)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

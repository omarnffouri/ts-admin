import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/customer_info_widget.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/vehicle_info_widget.dart';

import '../../controllers/service_order_details_controller.dart';
import '../buttom_sheets/completion_buttom_sheet.dart';
import 'files_after_service_widget.dart';
import 'files_befor_service_widget.dart';
import 'service_info_widget.dart';
import 'vehicle_parts_widget.dart';

class ServiceDetailsBody extends GetView<ServiceOrderDetailsController> {
  const ServiceDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.serviceOrder.value;
    final services = order?.serviceDetails ?? [];

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionEntrance(
                child: _DetailsSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (order?.serviceOrderNumber != null) ...[
                        _OrderNumberCard(
                          number:
                              order?.serviceOrderNumber?.capitalizeFirst ?? '',
                        ),
                        Divider(
                          height: 34,
                          color: context.hairlineBorderColor,
                        ),
                      ],
                      CustomerInfoWidget(
                        customerDetails: order?.customer,
                        embedded: true,
                      ),
                      Divider(
                        height: 34,
                        color: context.hairlineBorderColor,
                      ),
                      VehicleInfoWidget(
                        customerDetails: order?.customer,
                        embedded: true,
                      ),
                      Divider(
                        height: 34,
                        color: context.hairlineBorderColor,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: context.brandColor.applyOpacity(0.08),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              Icons.home_repair_service_outlined,
                              size: 19,
                              color: context.brandColor,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              'Service${services.length == 1 ? '' : 's'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: context.primaryTextColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: services.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final details = services[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: context.surfaceVariantColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: context.hairlineBorderColor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Service ${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: context.brandColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                ServiceInfoWidget(
                                  serviceOrder: order!,
                                  orderDetails: details,
                                ),
                                VehiclePartsWidget(orderDetails: details),
                                FilesBeforServiceWidget(orderDetails: details),
                                FilesAfterServcieWidget(orderDetails: details),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: controller.showUpdateButton.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: MainAppButton(
                            label: _getNextStatus(order?.status),
                            height: 52,
                            borderRadius: 14,
                            isLoading: controller.isUpdating.value,
                            trailingIcon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (controller.isUpdating.value) return;

                              switch (order?.status) {
                                case 'pending_confirmation' || 'shop_pending':
                                  controller.changeServiceStatus();
                                  break;
                                case 'shop_in_process':
                                  _showCompletionDetails(context);
                                  break;
                                default:
                                  break;
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show a modal bottom sheet
  void _showCompletionDetails(BuildContext context) {
    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      Container(
        width: Get.width,
        constraints: BoxConstraints(
          minHeight: Get.height * 0.3,
        ),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.scaffoldBackroundColor
              : AppColorsLight.scaffoldBackroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          border: Border.all(
            color: Colors.grey,
            width: .5,
          ),
        ),
        child: const CompletionButtomSheet(),
      ),
    );
  }

  String _getNextStatus(String? status) {
    if (status == null) return '';
    return switch (status) {
      'pending_confirmation' => 'Shop Pending',
      'shop_pending' => 'Shop In Process',
      'shop_in_process' => 'Complete Service',
      _ => '',
    };
  }
}

class _OrderNumberCard extends StatelessWidget {
  const _OrderNumberCard({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.brandColor.applyOpacity(0.08),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            size: 22,
            color: context.brandColor,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Order',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                number,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsSectionCard extends StatelessWidget {
  const _DetailsSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _SectionEntrance extends StatelessWidget {
  const _SectionEntrance({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

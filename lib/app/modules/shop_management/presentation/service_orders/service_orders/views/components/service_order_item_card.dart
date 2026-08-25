import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../../domain/entities/service_order_entity.dart';
import '../../controllers/service_orders_controller.dart';

class ServiceOrderCard extends GetView<ServiceOrdersController> {
  const ServiceOrderCard({super.key, required this.serviceOrder});

  final ServiceOrderEntity serviceOrder;

  static const double _radius = 18;
  static const double _contentPadding = 16;
  static const double _detailGap = 10;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ServiceDetailEntity? details =
        serviceOrder.serviceDetails?.firstOrNull;
    final bool enableActions = serviceOrder.status != 'shop_done' &&
        serviceOrder.status != 'cancelled';

    final String orderNumber = _displayValue(serviceOrder.serviceOrderNumber);
    final String title = _titleValue(
      details?.maintenanceTypeTitle ?? details?.maintenanceType,
    );
    final String category = _titleValue(serviceOrder.category);
    final String serviceType = _titleValue(
      details?.serviceTypeTitle ?? details?.serviceType,
    );
    final String chargingType = _titleValue(details?.serviceChargesType);
    final String status = _titleValue(serviceOrder.status);
    final String rate = _formatCurrency(details?.rate);
    final _PartsState partsState = _partsState(details?.partsRequired);

    return Semantics(
      button: true,
      label: 'Service order $orderNumber. $title. Status $status. '
          'Category $category. Service type $serviceType. '
          'Charging type $chargingType. Parts ${partsState.label}. '
          'Rate $rate.',
      hint: 'Opens service order details. Swipe left for available actions.',
      child: Slidable(
        key: ValueKey(serviceOrder.id ?? serviceOrder.serviceOrderNumber),
        closeOnScroll: true,
        enabled: enableActions,
        groupTag: 'orders_listing_slide_group',
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: _buildSlideActions(context),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: BorderRadius.circular(_radius),
            // border: Border.all(color: context.hairlineBorderColor),
            boxShadow: context.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.045),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(_radius),
              splashColor: context.brandColor.applyOpacity(0.08),
              highlightColor: context.brandColor.applyOpacity(0.035),
              onTap: () => Get.toNamed(
                Routes.SERVICE_ORDER_DETAILS,
                arguments: serviceOrder,
              ),
              child: ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(_contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _OrderNumberBadge(number: orderNumber),
                          ),
                          const SizedBox(width: 10),
                          const Spacer(),
                          Flexible(
                            child: ServiceOrderStatusBadge(
                              status: serviceOrder.status,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.primaryTextColor,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        spacing: _detailGap,
                        children: [
                          _DetailTile(
                            icon: Icons.category_outlined,
                            label: 'Category',
                            value: category,
                          ),
                          _DetailTile(
                            icon: Icons.home_repair_service_outlined,
                            label: 'Service type',
                            value: serviceType,
                          ),
                          _DetailTile(
                            icon: Icons.payments_outlined,
                            label: 'Charging type',
                            value: chargingType,
                          ),
                        ],
                      ),
                      // LayoutBuilder(
                      //   builder: (context, constraints) {
                      //     final bool useSingleColumn = constraints.maxWidth <
                      //             290 ||
                      //         MediaQuery.textScalerOf(context).scale(1) > 1.35;
                      //     final double itemWidth = useSingleColumn
                      //         ? constraints.maxWidth
                      //         : (constraints.maxWidth - _detailGap) / 2;

                      //     return ;
                      //   },
                      // ),
                      const SizedBox(height: 14),
                      Divider(
                        height: 1,
                        color: context.hairlineBorderColor,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 18,
                        children: [
                          _PartsRequiredIndicator(state: partsState),
                          _RateView(rate: rate),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlideActions(BuildContext context) {
    final List<Widget> actions = [];
    final String? status = serviceOrder.status;

    if (status == 'rejected') {
      actions.add(
        _buildSlidableAction(
          onPressed: () => controller.onResubmitServiceClicked(serviceOrder),
          label: 'Resubmit',
          icon: Icons.restart_alt_rounded,
          backgroundColor: _SemanticPalette.of(context).warning,
          foregroundColor: _SemanticPalette.of(context).onWarning,
          isFirst: true,
          isLast: true,
        ),
      );
      return actions;
    }

    actions.add(
      _buildSlidableAction(
        onPressed: () => controller.onCancelServiceClicked(serviceOrder),
        label: 'Cancel',
        icon: Icons.highlight_remove_outlined,
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        isFirst: true,
      ),
    );
    actions.add(
      _buildSlidableAction(
        onPressed: () => Get.toNamed(
          Routes.CREATE_EDIT_SERVICE_ORDER,
          arguments: serviceOrder,
        ),
        label: 'Edit',
        icon: Icons.edit_outlined,
        backgroundColor: context.primaryTextColor,
        foregroundColor: context.backgroundColor,
        isLast: true,
      ),
    );

    return actions;
  }

  Widget _buildSlidableAction({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return SlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: icon,
      label: label.tr,
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(_radius) : Radius.zero,
        bottomLeft: isFirst ? const Radius.circular(_radius) : Radius.zero,
        topRight: isLast ? const Radius.circular(_radius) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(_radius) : Radius.zero,
      ),
      padding: const EdgeInsets.all(2),
    );
  }

  static String _displayValue(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? 'N/A' : normalized;
  }

  static String _titleValue(String? value) {
    final String displayValue = _displayValue(value);
    return displayValue == 'N/A' ? displayValue : displayValue.toTitleCase();
  }

  static String _formatCurrency(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) return 'N/A';

    final double? amount = double.tryParse(
      normalized.replaceAll(RegExp(r'[^0-9.\-]'), ''),
    );
    if (amount == null) return normalized;

    return NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 2,
    ).format(amount);
  }

  static _PartsState _partsState(String? value) {
    final String normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) return _PartsState.unknown;
    return const {'yes', 'true', '1'}.contains(normalized)
        ? _PartsState.isRequired
        : _PartsState.notRequired;
  }
}

class ServiceOrderStatusBadge extends StatelessWidget {
  const ServiceOrderStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final String normalized = status?.trim().toLowerCase() ?? '';
    final _SemanticPalette palette = _SemanticPalette.of(context);
    final Color foreground;

    switch (normalized) {
      case 'pending_confirmation':
      case 'shop_pending':
        foreground = palette.warning;
      case 'shop_in_process':
      case 'approved':
        foreground = palette.info;
      case 'shop_done':
      case 'completed':
        foreground = palette.success;
      case 'rejected':
      case 'cancelled':
        foreground = palette.error;
      default:
        foreground = context.secondaryTextColor;
    }

    final String label = normalized.isEmpty ? 'N/A' : normalized.toTitleCase();
    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: foreground.applyOpacity(context.isDark ? 0.18 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: foreground.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderNumberBadge extends StatelessWidget {
  const _OrderNumberBadge({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color:
                context.brandColor.applyOpacity(context.isDark ? 0.18 : 0.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            size: 16,
            color: context.isDark
                ? Colors.white.applyOpacity(0.85)
                : context.brandColor,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            number == 'N/A' ? number : '#$number',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: context.secondaryTextColor),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.tr,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.tertiaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PartsRequiredIndicator extends StatelessWidget {
  const _PartsRequiredIndicator({required this.state});

  final _PartsState state;

  @override
  Widget build(BuildContext context) {
    final _SemanticPalette palette = _SemanticPalette.of(context);
    final Color color = switch (state) {
      _PartsState.isRequired => palette.success,
      _PartsState.notRequired => palette.error,
      _PartsState.unknown => context.secondaryTextColor,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.applyOpacity(context.isDark ? 0.18 : 0.10),
          ),
          child: Icon(state.icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parts required',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.tertiaryTextColor,
                  ),
            ),
            Text(
              state.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RateView extends StatelessWidget {
  const _RateView({required this.rate});

  final String rate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Rate'.tr,
          style: theme.textTheme.labelSmall?.copyWith(
            color: context.tertiaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          rate,
          style: theme.textTheme.titleMedium?.copyWith(
            color: context.brandColor,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

enum _PartsState {
  isRequired('Yes', Icons.check_rounded),
  notRequired('No', Icons.close_rounded),
  unknown('N/A', Icons.remove_rounded);

  const _PartsState(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _SemanticPalette {
  const _SemanticPalette({
    required this.success,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.error,
  });

  factory _SemanticPalette.of(BuildContext context) {
    final bool isDark = context.isDark;
    return _SemanticPalette(
      success: isDark ? Colors.green.shade300 : Colors.green.shade700,
      warning: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
      onWarning: isDark ? Colors.black87 : Colors.white,
      info: isDark ? Colors.lightBlue.shade300 : Colors.blue.shade700,
      error: Theme.of(context).colorScheme.error,
    );
  }

  final Color success;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color error;
}

/// Kept for the service-order details view, which shares the listing's status
/// color mapping.
Color getOrderStatusColor(String status) {
  switch (status.trim().toLowerCase()) {
    case 'shop_pending':
      return Colors.orange;
    case 'completed':
      return Colors.green;
    case 'shop_done':
      return Colors.blue;
    case 'rejected':
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

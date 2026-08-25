import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/service_order_entity.dart';

class VehiclePartsWidget extends StatelessWidget {
  const VehiclePartsWidget({super.key, this.orderDetails});

  final ServiceDetailEntity? orderDetails;

  @override
  Widget build(BuildContext context) {
    final vehicleParts = orderDetails?.vehicleParts;
    if (vehicleParts == null || vehicleParts.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Divider(height: 1, color: context.hairlineBorderColor),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(
              Icons.build_outlined,
              size: 18,
              color: context.secondaryTextColor,
            ),
            const SizedBox(width: 7),
            Text(
              'Vehicle Parts',
              style: theme.textTheme.titleSmall?.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool compact = constraints.maxWidth < 520;

            return ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehicleParts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final part = vehicleParts[index];

                if (compact) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.fieldFillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.hairlineBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _displayValue(part.itemName?.toString()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.primaryTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _Metric(
                                label: 'Required',
                                value: part.numberOfPartsRequired.toString(),
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Available',
                                value: part.numberOfPartsAvailable.toString(),
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Purchased',
                                value: part.partsToBePurchased.toString(),
                                alignEnd: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(height: 1, color: context.hairlineBorderColor),
                        const SizedBox(height: 9),
                        _PriceRow(
                          label: 'Price',
                          value: '\$${part.partPrice}',
                        ),
                        const SizedBox(height: 6),
                        _PriceRow(
                          label: 'Total Price',
                          value: '\$${part.totalPrice}',
                          emphasize: true,
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.fieldFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.hairlineBorderColor),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        color: context.surfaceVariantColor,
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: _TableLabel('Name')),
                            Expanded(child: _TableLabel('Required')),
                            Expanded(child: _TableLabel('Available')),
                            Expanded(
                              child: _TableLabel('Purchased', alignEnd: true),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                _displayValue(part.itemName?.toString()),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                part.numberOfPartsRequired.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.primaryTextColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                part.numberOfPartsAvailable.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.primaryTextColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                part.partsToBePurchased.toString(),
                                textAlign: TextAlign.end,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: context.hairlineBorderColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PriceRow(
                                label: 'Price',
                                value: '\$${part.partPrice}',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _PriceRow(
                                label: 'Total',
                                value: '\$${part.totalPrice}',
                                emphasize: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  static String _displayValue(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty || normalized == 'null' ? 'N/A' : normalized;
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment =
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.primaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodySmall?.copyWith(
              color: emphasize ? context.brandColor : context.primaryTextColor,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TableLabel extends StatelessWidget {
  const _TableLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.secondaryTextColor,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

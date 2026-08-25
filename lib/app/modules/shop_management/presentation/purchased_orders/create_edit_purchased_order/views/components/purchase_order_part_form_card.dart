import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../../controllers/create_edit_purchased_order_controller.dart';
import 'purchase_order_part_metrics.dart';
import 'vehicle_part_items_dropdown_widget.dart';

class PurchaseOrderPartFormCard extends StatefulWidget {
  const PurchaseOrderPartFormCard({
    super.key,
    required this.index,
    required this.vehiclePart,
  });

  final int index;
  final VehiclePart vehiclePart;

  @override
  State<PurchaseOrderPartFormCard> createState() =>
      _PurchaseOrderPartFormCardState();
}

class _PurchaseOrderPartFormCardState extends State<PurchaseOrderPartFormCard> {
  final controller = Get.find<CreateEditPurchasedOrderController>();
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.vehiclePart.numPartsRequired.value.toString(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _deleteItem() {
    final purchasedPart = widget.vehiclePart;
    controller.purchasedPartKey.currentState?.removeItem(
      widget.index,
      (context, animation) => SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: PurchaseOrderPartFormCard(
          index: widget.index,
          vehiclePart: purchasedPart,
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      controller.removeVehiclePartsField(widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Obx(
      () {
        final bool isEditEnabled = controller.isEditEnabled.value;
        final bool canRemove =
            isEditEnabled && controller.purchasedParts.length > 1;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          decoration: BoxDecoration(
            color: context.surfaceVariantColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.hairlineBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //
              //
              // entry heading + remove action
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.brandColor.applyOpacity(0.09),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '${widget.index + 1}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: context.brandColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Part ${widget.index + 1}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (canRemove) _RemovePartButton(onPressed: _deleteItem),
                ],
              ),
              const SizedBox(height: 14),

              //
              //
              // item name
              VehiclePartItemsDropdownWidget(
                part: widget.vehiclePart,
                isEnabled: isEditEnabled,
              ),
              const SizedBox(height: 14),

              //
              //
              // number of parts required
              Opacity(
                opacity: isEditEnabled ? 1 : .5,
                child: Semantics(
                  textField: true,
                  label: 'Number of parts required for part '
                      '${widget.index + 1}, required',
                  child: RoundedInputField(
                    hintText: "Number of parts required",
                    label: "Number of parts required",
                    isRequired: true,
                    readOnly: isEditEnabled == false,
                    keyboardType: TextInputType.number,
                    borderColor: context.hairlineBorderColor,
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value.isEmpty ? '0' : value);
                      if (parsed != null && parsed > 0) {
                        widget.vehiclePart.numPartsRequired.value = parsed;
                        widget.vehiclePart.updatePartsToBePurchased();
                      }
                    },
                    controller: _textController,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Number of parts is required";
                      }
                      final parsed = int.tryParse(p0);
                      if (parsed == null) {
                        return "Invalid number";
                      }
                      if (parsed <= 0) {
                        return "Number of parts should be greater than 0";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              //
              //
              // calculated values
              PurchaseOrderPartMetrics(part: widget.vehiclePart),
            ],
          ),
        );
      },
    );
  }
}

/// Icon-only remove action with a tooltip, a screen-reader label and a
/// 40×40 touch target.
class _RemovePartButton extends StatelessWidget {
  const _RemovePartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color danger = context.dangerColor;

    return Semantics(
      button: true,
      label: 'Remove part',
      excludeSemantics: true,
      child: Tooltip(
        message: 'Remove part',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: danger.applyOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: danger.applyOpacity(0.22)),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: danger,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

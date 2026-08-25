import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../../../../../domain/entities/service_details.dart';
import '../../controllers/create_edit_service_order_controller.dart';
import '../components/vehicle_part_items_dropdown_widget.dart';

class AnimatedVehiclePartsWidget extends StatelessWidget {
  const AnimatedVehiclePartsWidget({
    super.key,
    required this.animatedListKey,
    required this.serviceDetails,
  });

  final GlobalKey<AnimatedListState> animatedListKey;
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: animatedListKey,
      primary: false,
      shrinkWrap: true,
      initialItemCount: serviceDetails.vehiclePartFields.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: VehiclePartItem(
              key: ValueKey(serviceDetails.vehiclePartFields[index]),
              index: index,
              vehiclePart: serviceDetails.vehiclePartFields[index],
              serviceDetails: serviceDetails,
            ),
          ),
        );
      },
    );
  }
}

class VehiclePartItem extends StatefulWidget {
  final int index;
  final VehiclePart vehiclePart;
  final ServiceDetails serviceDetails;

  const VehiclePartItem({
    super.key,
    required this.index,
    required this.vehiclePart,
    required this.serviceDetails,
  });

  @override
  State<VehiclePartItem> createState() => _VehiclePartItemState();
}

class _VehiclePartItemState extends State<VehiclePartItem> {
  final controller = Get.find<CreateEditServiceOrderController>();
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
    final serviceDetails = widget.serviceDetails;
    if (serviceDetails.vehiclePartFields.isEmpty) return;
    serviceDetails.vehiclePartsKey.currentState?.removeItem(
      widget.index,
      (context, animation) => SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: VehiclePartItem(
          key: ValueKey(serviceDetails.vehiclePartFields[widget.index]),
          index: widget.index,
          vehiclePart: widget.vehiclePart,
          serviceDetails: serviceDetails,
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );
    // Delay removal from the list until the animation completes.
    Future.delayed(const Duration(milliseconds: 300), () {
      serviceDetails.removeVehiclePartsField(widget.index);
      if (serviceDetails.vehiclePartFields.isEmpty) {
        serviceDetails.isPartRequired.value = "no";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.tileColor.applyOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VehiclePartItemsDropdownWidget(
            part: widget.vehiclePart,
            isEnabled: widget.serviceDetails.isEnabled.value,
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: widget.serviceDetails.isEnabled.value ? 1 : .5,
            child: RoundedInputField(
              hintText: "Number of parts required",
              label: "Number of parts required",
              isRequired: true,
              readOnly: widget.serviceDetails.isEnabled.value == false,
              keyboardType: TextInputType.number,
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
          const SizedBox(height: 6),
          Obx(() => InfoRow(
              label: 'Number of parts available',
              value: '${widget.vehiclePart.quantity.value}')),
          Obx(() => InfoRow(
              label: 'Parts to be purchased',
              value: '${widget.vehiclePart.partsToBePurchased.value}')),
          Obx(() => InfoRow(
              label: 'Parts price', value: '${widget.vehiclePart.price}')),
          Obx(() => InfoRow(
              label: 'Total Price',
              value: widget.vehiclePart.totalPrice.value)),
          if (widget.serviceDetails.isEnabled.value)
            Column(
              children: [
                Divider(
                  color: Get.isDarkMode ? Colors.white24 : Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DeleteButton(onPressed: _deleteItem),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Get.theme.textTheme.bodySmall?.copyWith(
            color: Get.isDarkMode ? Colors.grey : Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Get.theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black12 : Colors.white12,
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.delete_forever_outlined, color: Colors.amber),
        ),
      ),
    );
  }
}

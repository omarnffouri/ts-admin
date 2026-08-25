import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/vehicle_choice_field.dart';
import '../../controllers/create_truck_controller.dart';

class TruckGliderField extends GetView<CreateTruckController> {
  const TruckGliderField({super.key});

  static const List<String> options = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VehicleChoiceField<String>(
        label: 'Glider',
        hintText: 'Select glider',
        items: options,
        selectedItem: controller.selectedGlider.value.isEmpty
            ? null
            : controller.selectedGlider.value,
        itemAsString: (item) => item,
        onChanged: (value) {
          if (value != null) {
            controller.selectedGlider.value = value;
          }
        },
      ),
    );
  }
}

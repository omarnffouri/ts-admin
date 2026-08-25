import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/reusable_date_picker.dart';

import '../../controllers/truck_details_controller.dart';
import '../../../components/devices_dropdown_widget.dart';
import '../../../components/selected_device_dropdown_widget.dart';

class InstallDeviceBottomSheet extends GetView<TruckDetailsController> {
  const InstallDeviceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        //
        // top header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          decoration: const BoxDecoration(
            color: AppColorsLight.mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Row(
            children: [
              const Text(
                "Install New Device",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              //
              //
              // close button
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              DevicesDropdownWidet(
                isDeviceTypesLoading: controller.isDeviceTypesLoading,
                deviceTypes: controller.deviceTypes,
                selectedDeviceType: controller.selectedDeviceType,
                onDeviecSelected: (item) {
                  if (item != null) {
                    controller.selectedDeviceType.value = item;
                    controller.selectedSerialNumber.value = null;
                    // Fetch serial numbers based on selected device type
                    controller.getSelectedDevice(item);
                  }
                },
              ),
              const SizedBox(height: 16),
              SelectedDeviceDropdownWidet(
                isSerialNumbersLoading: controller.isSerialNumbersLoading,
                serialNumbers: controller.serialNumbers,
                selectedSerialNumber: controller.selectedSerialNumber,
                onSerialSelected: (item) {
                  if (item != null) {
                    controller.selectedSerialNumber.value = item;
                  }
                },
              ),
              const SizedBox(height: 16),
              ReusableDatePicker(
                controller: controller.installedDateController,
                label: 'Installed On',
                hint: 'Select a date',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ),
              const SizedBox(height: 16),
              RoundedInputField(
                label: "Note",
                hintText: "Note",
                maxLength: 500,
                maxLines: 5,
                minLines: 5,
                showCounting: true,
                controller: controller.noteController,
                contentPadding: const EdgeInsets.all(10),
              ),
              const SizedBox(height: 16),
              Obx(
                () => MainAppButton(
                  label: "Install Device",
                  isLoading: controller.isAddingDevice.value,
                  onPressed: () {
                    if (controller.isAddingDevice.value) {
                      return;
                    }
                    controller.insallDevice();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

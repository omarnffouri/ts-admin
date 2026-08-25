import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';

import '../../../../components/reusable_date_picker.dart';
import '../../controllers/service_order_details_controller.dart';
import '../components/category_dropdown_widget.dart';
import '../components/files_after_service_view.dart';
import '../components/service_info_widget.dart';

class CompletionButtomSheet extends GetView<ServiceOrderDetailsController> {
  const CompletionButtomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final enablePayroll = controller.serviceOrder.value?.category == 'company';

    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceDetailsList(),
              const SizedBox(height: 10),
              _buildCompletionDatePicker(),
              const SizedBox(height: 20),
              CategoryDropdownWidget(isEnabled: enablePayroll),
              _buildPayrollSection(),
              const SizedBox(height: 10),
              _buildActionButtons(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the service details list
  Widget _buildServiceDetailsList() {
    final serviceDetails = controller.serviceOrder.value?.serviceDetails ?? [];

    return ListView.separated(
      itemCount: serviceDetails.length,
      shrinkWrap: true,
      primary: false,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final details = serviceDetails[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.white10 : Colors.black12,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade300,
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ServiceInfoWidget(
                serviceOrder: controller.serviceOrder.value!,
                orderDetails: details,
              ),
              FilesAfterServiceView(
                serviceDetails: controller.completionParams[index],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the completion date picker
  Widget _buildCompletionDatePicker() {
    return ReusableDatePicker(
      controller: controller.completionDateController,
      label: 'Completion Date',
      hint: 'Select a date',
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
  }

  /// Builds the payroll section (conditionally visible)
  Widget _buildPayrollSection() {
    return Obx(
      () => Visibility(
        visible: controller.selectedCategory.value == 'Payroll',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDescriptionField(),
            const SizedBox(height: 15),
            _buildFrequencyDropdown(),
            _buildFrequencyDetails(),
          ],
        ),
      ),
    );
  }

  /// Builds the description text field
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: controller.descController,
      maxLines: 2,
      textInputAction: TextInputAction.next,
      onTapOutside: (_) => FocusScope.of(Get.context!).unfocus(),
      validator: (value) =>
          value!.isEmpty ? "Please provide a Description" : null,
      decoration: _buildInputDecoration("Description (Required)"),
    );
  }

  /// Builds the frequency dropdown
  Widget _buildFrequencyDropdown() {
    return CustomStringDropdownWidget(
      hintText: 'Frequency',
      items: const ['One Time', 'Weekly', 'Monthly', 'Every Set'],
      selectedItem: controller.selectedFrequency.value,
      itemAsString: (String item) => item,
      onChanged: (value) => controller.selectedFrequency.value = value,
      isDarkMode: Get.isDarkMode,
    );
  }

  /// Builds the frequency details section (start date, end date, amounts)
  Widget _buildFrequencyDetails() {
    return Obx(
      () => Visibility(
        visible: controller.selectedFrequency.value != null,
        child: Column(
          children: [
            _buildDateRange(),
            const SizedBox(height: 10),
            _buildDeductionFields(),
          ],
        ),
      ),
    );
  }

  /// Builds the date range selectors (Start & End Date)
  Widget _buildDateRange() {
    return Row(
      children: [
        Expanded(
          child: ReusableDatePicker(
            controller: controller.freqStartDateController,
            label: 'Start Date',
            hint: 'Select a date',
            firstDate: DateTime.now(),
            lastDate: DateTime(2040),
          ),
        ),
        if (controller.selectedFrequency.value != 'One Time') ...[
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => IgnorePointer(
                ignoring: !controller.enableEndDate.value,
                child: Opacity(
                  opacity: controller.enableEndDate.value ? 1 : 0.5,
                  child: ReusableDatePicker(
                    controller: controller.freqEndDateController,
                    label: 'End Date',
                    hint: 'Select a date',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2040),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Builds deduction amount fields
  Widget _buildDeductionFields() {
    return Column(
      children: [
        // Deduction Amount Field
        TextFormField(
          controller: controller.deductionAmountController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onTapOutside: (_) => FocusScope.of(Get.context!).unfocus(),
          validator: (value) =>
              value!.isEmpty ? "Please provide a deduction amount" : null,
          decoration: _buildInputDecoration("Deduction Amount"),
        ),
        const SizedBox(height: 10),

        // Max One Time Amount (if frequency is Weekly or Monthly)
        Obx(
          () => Visibility(
            visible: controller.selectedFrequency.value == 'Weekly' ||
                controller.selectedFrequency.value == 'Monthly',
            child: TextFormField(
              controller: controller.maxOneTimeAmountController,
              keyboardType: TextInputType.number,
              textInputAction: controller.enableTotalAmountToDeduct.value
                  ? TextInputAction.next
                  : null,
              onTapOutside: (_) => FocusScope.of(Get.context!).unfocus(),
              validator: (value) =>
                  value!.isEmpty ? "Please provide max one-time amount" : null,
              decoration: _buildInputDecoration("Max One Time Amount"),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Total Amount to Deduct (if frequency is NOT 'One Time')
        Obx(
          () => Visibility(
            visible: controller.selectedFrequency.value != 'One Time',
            child: IgnorePointer(
              ignoring: !controller.enableTotalAmountToDeduct.value,
              child: Opacity(
                opacity: controller.enableTotalAmountToDeduct.value ? 1 : 0.5,
                child: TextFormField(
                  controller: controller.totalAmountController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration("Total Amount to Deduct"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the action buttons (Complete & Clear)
  Widget _buildActionButtons() {
    return Obx(
      () => Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: RoundedFillButton(
                label: "Complete",
                isLoading: controller.isUpdating.value,
                onPressed: () async {
                  if (controller.isUpdating.value) return;
                  controller.completeServiceOrder();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RoundedBorderButton(
                label: "Clear",
                onPressed: () => controller.clearTextControllers(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a common InputDecoration for text fields
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColorsLight.mainColor),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../../domain/entities/service_details.dart';
import '../../../../../domain/entities/service_dropdown_entity.dart';
import '../../controllers/create_edit_service_order_controller.dart';
import '../components/files_after_service_view.dart';
import '../components/files_befor_service_view.dart';
import 'animated_vehicle_parts_widget.dart';

class AnimatedServiceDetailsWidget extends StatelessWidget {
  const AnimatedServiceDetailsWidget({
    super.key,
    required this.animatedListKey,
    required this.serviceDetails,
  });

  final GlobalKey<AnimatedListState> animatedListKey;
  final List<ServiceDetails> serviceDetails;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedList(
        key: animatedListKey,
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        initialItemCount: serviceDetails.length,
        itemBuilder: (context, index, animation) {
          return _buildPartItem(index, animation);
        },
      ),
    );
  }

  Widget _buildPartItem(int index, Animation<double> animation) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: curvedAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ServiceDetailsItem(
            key: ValueKey(serviceDetails[index]),
            index: index,
            serviceDetail: serviceDetails[index],
            animatedListKey: animatedListKey,
          ),
        ),
      ),
    );
  }
}

class ServiceDetailsItem extends StatelessWidget {
  const ServiceDetailsItem({
    super.key,
    required this.index,
    required this.serviceDetail,
    required this.animatedListKey,
  });
  final int index;
  final ServiceDetails serviceDetail;
  final GlobalKey<AnimatedListState> animatedListKey;

  Future<void> _handleDeleteItem() {
    final controller = Get.find<CreateEditServiceOrderController>();
    if (controller.serviceDetails.length <= 1) return Future.value();

    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => Builder(
        builder: (context) => SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: ServiceDetailsItem(
            key: ValueKey(serviceDetail),
            index: index,
            serviceDetail: serviceDetail,
            animatedListKey: animatedListKey,
          ),
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      controller.removeServiceDetailsField(index);
      serviceDetail.clearTextControllers();
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();
    final theme = Theme.of(context);

    return Obx(
      () {
        final String serviceName =
            serviceDetail.selectedServiceType?.value?.title ??
                serviceDetail.selectedMaintenanceType?.value?.name ??
                'Choose service information';

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.surfaceVariantColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.hairlineBorderColor),
          ),
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: ValueKey(serviceDetail),
              initiallyExpanded: true,
              maintainState: true,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              leading: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.brandColor.applyOpacity(0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: context.brandColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              iconColor: context.brandColor,
              collapsedIconColor: context.secondaryTextColor,
              title: Text(
                'Service ${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                serviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.tertiaryTextColor,
                ),
              ),
              children: [
                Divider(height: 1, color: context.hairlineBorderColor),
                const SizedBox(height: 16),
                BuildMaintenanceTypeDropdown(serviceDetails: serviceDetail),
                const SizedBox(height: 14),
                BuildServiceTypeDropdown(serviceDetails: serviceDetail),
                const SizedBox(height: 14),
                BuildServiceChargesTypeDropdown(
                  serviceDetails: serviceDetail,
                ),
                const SizedBox(height: 6),
                BuildDynamicFieldsSection(serviceDetails: serviceDetail),
                const SizedBox(height: 18),
                VehiclePartsSection(serviceDetails: serviceDetail),
                ServiceMediaView(serviceDetails: serviceDetail),
                if (serviceDetail.isEnabled.value &&
                    controller.serviceDetails.length > 1) ...[
                  const SizedBox(height: 12),
                  ServiceDeleteButton(onDelete: _handleDeleteItem),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class VehiclePartsSection extends GetView<CreateEditServiceOrderController> {
  const VehiclePartsSection({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    debugPrint('VehiclePartsSection: ${serviceDetails.isPartRequired.value}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Parts',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        // parts required
        Obx(
          () {
            final selectedValue = serviceDetails.isPartRequired.value;

            void selectValue(String value) {
              serviceDetails.isPartRequired.value = value;
              if (serviceDetails.vehiclePartFields.isEmpty) {
                serviceDetails.addVehiclePartsField();
                serviceDetails.vehiclePartsKey.currentState?.insertItem(0);
              }
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: controller.isLoading.value
                      ? const DropdownLoadingWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Parts Required',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: context.brandColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                for (final value in const ['yes', 'no'])
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: selectedValue == value,
                                          onChanged:
                                              !serviceDetails.isEnabled.value
                                                  ? null
                                                  : (_) => selectValue(value),
                                          activeColor: context.brandColor,
                                          checkColor: Colors.white,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          side: BorderSide(
                                            color: selectedValue == value
                                                ? context.brandColor
                                                : context.secondaryTextColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          value == 'yes' ? 'Yes' : 'No',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: context.primaryTextColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                ),
                Visibility(
                  visible: selectedValue == 'yes',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: context.fieldFillColor,
                      border: Border.all(color: context.hairlineBorderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.CREATE_EDIT_INVENTORY);
                      },
                      child: Text(
                        "+ Add Items",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: context.primaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 10),
        if (serviceDetails.isEnabled.value)
          Obx(
            () => Column(
              children: [
                if (serviceDetails.isPartRequired.value == 'yes')
                  InkWell(
                    onTap: () {
                      serviceDetails.addVehiclePartsField();
                      serviceDetails.vehiclePartsKey.currentState
                          ?.insertItem(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: context.brandColor.applyOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: context.brandColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Add part',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: context.brandColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // parts fields
        Obx(
          () => Visibility(
            visible: serviceDetails.isPartRequired.value == 'yes',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Required Parts',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                AnimatedVehiclePartsWidget(
                  animatedListKey: serviceDetails.vehiclePartsKey,
                  serviceDetails: serviceDetails,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BuildMaintenanceTypeDropdown extends StatelessWidget {
  const BuildMaintenanceTypeDropdown({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const DropdownLoadingWidget();
      }
      return _DropdownWidget<ServiceTypeEntity>(
        label: "Maintenance Type",
        hint: "Select Maintenance Type",
        value: serviceDetails.selectedMaintenanceType?.value,
        items: controller.serviceDropdown.value?.serviceType ?? [],
        itemAsString: (item) => item.name ?? '',
        isEnable: serviceDetails.isEnabled.value,
        onChanged: (newValue) {
          if (newValue != null) {
            serviceDetails.selectedMaintenanceType ??= Rxn<ServiceTypeEntity>();
            serviceDetails.selectedMaintenanceType!.value = newValue;
            serviceDetails.selectedMaintenanceType!.refresh();

            serviceDetails.selectedServiceType ??= Rxn<DataEntity>();
            serviceDetails.selectedServiceType!.value = null;
            serviceDetails.selectedServiceType!.refresh();

            serviceDetails.selectedChargesType ??= Rxn<String>();
            serviceDetails.selectedChargesType!.value = null;
            serviceDetails.selectedChargesType!.refresh();
          }
        },
      );
    });
  }
}

class BuildServiceTypeDropdown extends StatelessWidget {
  const BuildServiceTypeDropdown({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const DropdownLoadingWidget();
      }

      return _DropdownWidget<DataEntity>(
        label: "Service Type",
        hint: "Select Service Type",
        value: serviceDetails.selectedServiceType?.value,
        items: serviceDetails.selectedMaintenanceType?.value?.data ?? [],
        itemAsString: (item) => item.title ?? '',
        isEnable: serviceDetails.isEnabled.value,
        onChanged: (DataEntity? newValue) {
          if (newValue != null) {
            serviceDetails.selectedServiceType ??= Rxn<DataEntity>();
            serviceDetails.selectedServiceType!.value = newValue;
            serviceDetails.selectedServiceType!.refresh();

            serviceDetails.selectedChargesType ??= Rxn<String>();
            serviceDetails.selectedChargesType!.value = null;
            serviceDetails.selectedChargesType!.refresh();

            debugPrint('ServiceTypeDropdownWidget: $serviceDetails');
            debugPrint(serviceDetails.selectedServiceType?.value
                ?.toEntity()
                .toString());
          }
        },
      );
    });
  }
}

class BuildServiceChargesTypeDropdown extends StatelessWidget {
  const BuildServiceChargesTypeDropdown(
      {super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const DropdownLoadingWidget().marginOnly(bottom: 20);
      }

      if (serviceDetails.selectedServiceType?.value == null) {
        return const SizedBox.shrink();
      }

      return CustomStringDropdownWidget(
        labelText: 'Service Charges Type',
        hintText: 'Select Service Charges Type',
        isRequired: true,
        bottomSpacing: 0,
        items: const ['hour', 'flat'],
        selectedItem: serviceDetails.selectedChargesType?.value?.isEmpty ?? true
            ? null
            : serviceDetails.selectedChargesType?.value,
        itemAsString: (String item) => item,
        isEnabled: serviceDetails.isEnabled.value,
        onChanged: (value) {
          serviceDetails.selectedChargesType?.value = value!;
          serviceDetails.selectedChargesType?.refresh();
        },
        isDarkMode: Get.isDarkMode,
      );
    });
  }
}

class BuildDynamicFieldsSection extends StatefulWidget {
  const BuildDynamicFieldsSection({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  State<BuildDynamicFieldsSection> createState() =>
      _BuildDynamicFieldsSectionState();
}

class _BuildDynamicFieldsSectionState extends State<BuildDynamicFieldsSection> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.serviceDetails.isEnabled.value ? 1 : .5,
      child: Obx(
        () => Column(
          children: [
            if (widget.serviceDetails.selectedChargesType?.value == 'hour')
              RoundedInputField(
                hintText: "Hours",
                label: "Hours",
                isRequired: true,
                keyboardType: TextInputType.number,
                controller: widget.serviceDetails.hoursController,
                readOnly: widget.serviceDetails.isEnabled.value == false,
                borderColor: context.hairlineBorderColor,
                borderRadius: 12,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
              ).marginOnly(bottom: 14),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: RoundedInputField(
                    hintText: "Rate",
                    label: "Rate",
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    controller: widget.serviceDetails.rateController,
                    readOnly: widget.serviceDetails.isEnabled.value == false,
                    borderColor: context.hairlineBorderColor,
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedInputField(
                    hintText: "Mileage",
                    label: "Mileage",
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    controller: widget.serviceDetails.mileageController,
                    readOnly: widget.serviceDetails.isEnabled.value == false,
                    borderColor: context.hairlineBorderColor,
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedInputField(
                    hintText: "Tax",
                    label: "Tax",
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    controller: widget.serviceDetails.taxController,
                    readOnly: widget.serviceDetails.isEnabled.value == false,
                    borderColor: context.hairlineBorderColor,
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            )
            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     final fields = [

            //     ];

            //     if (constraints.maxWidth < 520) {
            //       return Column(
            //         children: [
            //           fields[0],
            //           const SizedBox(height: 14),
            //           fields[1],
            //           const SizedBox(height: 14),
            //           fields[2],
            //         ],
            //       );
            //     }

            //     return Row(
            //       children: [
            //         Expanded(child: fields[0]),
            //         const SizedBox(width: 10),
            //         Expanded(child: fields[1]),
            //         const SizedBox(width: 10),
            //         Expanded(child: fields[2]),
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class ServiceMediaView extends StatelessWidget {
  const ServiceMediaView({super.key, required this.serviceDetails});
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();

    return Column(
      children: [
        FilesBeforServiceView(serviceDetails: serviceDetails),
        Obx(() => controller.isUpdating.value
            ? FilesAfterServiceView(serviceDetails: serviceDetails)
            : const SizedBox.shrink()),
      ],
    );
  }
}

class ServiceDeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const ServiceDeleteButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEditServiceOrderController>();

    return Obx(() {
      if (controller.serviceDetails.length <= 1) {
        return const SizedBox.shrink();
      }
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.applyOpacity(0.07),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.applyOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Remove service',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _DropdownWidget<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;
  final bool isEnable;

  const _DropdownWidget({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: Text(hint),
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.hintTextColor,
            ),
        label: Text.rich(
          TextSpan(
            text: label,
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: context.brandColor),
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.hairlineBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.focusedBorderColor,
            width: 1.4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.hairlineBorderColor),
        ),
      ),
      initialValue: value,
      onChanged: isEnable == false ? null : onChanged,
      items: items
          .map((item) =>
              DropdownMenuItem<T>(value: item, child: Text(itemAsString(item))))
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';

import '../../../../components/dropdown_loading.dart';
import '../../controllers/create_edit_service_order_controller.dart';

class TechniciansDropdownWidget
    extends GetView<CreateEditServiceOrderController> {
  const TechniciansDropdownWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //
              // dropdoen view
              controller.isLoading.value
                  ? const DropdownLoadingWidget()
                  : SearchableDropDown<TechnicianEntity>(
                      list: controller.technicians
                          .where((item) =>
                              (!controller.selectedTechnicians.contains(item)))
                          .toList(),
                      bottomSheetLabel: 'Select technician',
                      searchHint: 'search by name',
                      fieldLabel: 'Technicians',
                      fieldHint: 'Select technician',
                      isRequired: true,
                      showOnlyLetters: true,
                      getName: (p0) => p0.name ?? "",
                      getImage: (p0) => p0.name ?? "",
                      selectedItem: null,
                      dropdownSearchDecoration:
                          SearchableDropdownDecoration.bordered,
                      dropdownDecoration: SearchableDropdownDecoration.bordered,
                      onItemSelected: (TechnicianEntity? item) {
                        if (item != null) {
                          controller.selectedTechnicians.add(item);
                        }
                      },
                      itemAsString: (item) {
                        return "${item.name}";
                      },
                      compareFunction: (item_1, item_2) {
                        return item_1 == item_2;
                      },
                    ),

              //
              //
              // selected technicians view

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0;
                      i < controller.selectedTechnicians.length;
                      i++)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: context.brandColor.applyOpacity(0.07),
                        border: Border.all(color: context.hairlineBorderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(
                        left: 11,
                        right: 5,
                        top: 6,
                        bottom: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //
                          //
                          // technician name
                          Text(
                            controller.selectedTechnicians.elementAt(i).name ??
                                "default text",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: context.primaryTextColor),
                          ),

                          //
                          //
                          // remove button
                          InkResponse(
                            onTap: () {
                              controller.selectedTechnicians.removeAt(i);
                            },
                            radius: 18,
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: context.secondaryTextColor,
                            ),
                          ).marginOnly(left: 5)
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

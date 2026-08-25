import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/widgets/dropdown.dart';
import 'package:ts_admin/app/core/widgets/multi_select_search_dropdown.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/data_entity.dart';

/// Off-days picker + enable/disable selector, shared by the new-account and
/// update-user screens. Driven by the controller's reactive fields passed in.
class OffDaysSection extends StatelessWidget {
  const OffDaysSection({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.offDays,
    required this.selectedOffDays,
    required this.enableDisableOptions,
    required this.selectedEnableOption,
    required this.onRetry,
  });

  final RxBool isLoading;
  final RxBool hasError;
  final RxList<DataEntity> offDays;
  final RxList<DataEntity> selectedOffDays;
  final RxList<DataEntity> enableDisableOptions;
  final Rxn<DataEntity> selectedEnableOption;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Off Days",
              style: context.theme.textTheme.titleLarge,
            )
          ],
        ).marginOnly(top: 16, left: 10, bottom: 6),
        Obx(
          () => isLoading.value
              ? _buildLoading()
              : hasError.value
                  ? _buildRetry(
                      const Text("Something went wrong..."),
                      GestureDetector(
                        onTap: onRetry,
                        child: const Text(
                          "try again",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : offDays.isEmpty
                      ? _buildRetry(
                          const Text("No data found..."),
                          GestureDetector(
                            onTap: onRetry,
                            child: const Text(
                              "refesh",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      : MultiSelectSearchDropdown<DataEntity>(
                          items: offDays,
                          labelOf: (e) => e.name ?? "",
                          initialPicked: selectedOffDays.toList(),
                          hintText: 'Select Off Days',
                          showSearch: false,
                          showLeadingAvatar: false,
                          showSelectAllButton: false,
                          sortItems: false,
                          maxSelections: 4,
                          onPickedChanged: (picked) {
                            selectedOffDays.value = picked;
                          },
                        ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enable / Disable Off Days",
              style: context.theme.textTheme.titleLarge,
            )
          ],
        ).marginOnly(top: 16, left: 10, bottom: 6),
        SizedBox(
          height: 50,
          child: DropDown<DataEntity>(
            listItems: enableDisableOptions
                .map(
                  (e) => DropdownMenuItem<DataEntity>(
                    value: e,
                    child: Text(e.name ?? ""),
                  ),
                )
                .toList(),
            hint: "Enable / Disable Off Days",
            selectedValue: selectedEnableOption.value,
            onChange: (value) {
              selectedEnableOption.value = value;
              selectedEnableOption.refresh();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildRetry(Text message, Widget button) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: message,
          ),
          button
        ],
      ).marginOnly(top: 12, right: 12, left: 12),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/leave_requests_history_controller.dart';

class LeaveStatusFilter extends StatelessWidget {
  const LeaveStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaveRequestsHistoryController>();
    final isDark = context.isDark;

    return Obx(() {
      final isActive = controller.selectedStatus.value != 'All';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Status',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: context.secondaryTextColor,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: context.surfaceColor.applyOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? context.brandColor
                    : isDark
                        ? Colors.white.applyOpacity(0.08)
                        : Colors.black.applyOpacity(0.06),
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'All Statuses',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.secondaryTextColor,
                      ),
                ),
                value: controller.selectedStatus.value == 'All'
                    ? null
                    : controller.selectedStatus.value,
                items: controller.statusOptions
                    .map((item) => DropdownMenuItem<String>(
                          value: item == 'All' ? null : item,
                          child: Text(
                            item,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedStatus.value = value ?? 'All';
                },
                buttonStyleData: ButtonStyleData(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.expand_more_rounded,
                    color: context.secondaryTextColor,
                  ),
                  iconSize: 20,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: context.surfaceColor,
                  ),
                  offset: const Offset(0, 0),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  height: 36,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

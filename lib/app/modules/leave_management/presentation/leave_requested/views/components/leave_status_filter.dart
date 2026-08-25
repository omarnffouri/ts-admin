import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class LeaveStatusFilter extends StatelessWidget {
  const LeaveStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.statusOptions,
    required this.onStatusChanged,
  });

  final RxString selectedStatus;
  final List<String> statusOptions;
  final Function(String) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statusOptions.length,
        itemBuilder: (context, index) {
          final status = statusOptions[index];

          return Padding(
            padding: EdgeInsets.only(
              right: index == (statusOptions.length - 1) ? 0 : 10,
            ),
            child: Obx(
              () {
                final bool isSelected = selectedStatus.value == status;

                return GestureDetector(
                  onTap: () => onStatusChanged(status),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.brandColor.applyOpacity(0.3)
                          : context.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : isDark
                                ? Colors.white.applyOpacity(0.12)
                                : Colors.black.applyOpacity(0.06),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.applyOpacity(0.30)
                                    : context.brandColor.applyOpacity(0.30),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      style: (theme.textTheme.labelLarge ?? const TextStyle())
                          .copyWith(
                        color: isSelected
                            ? Colors.white
                            : isDark
                                ? Colors.white.applyOpacity(0.9)
                                : context.brandColor,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                      child: Text(status),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

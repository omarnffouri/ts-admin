import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/vehicle_details_entity.dart';

import '../../controllers/truck_details_controller.dart';
import '../../../components/vehicle_details/section_empty_state.dart';

class CheckListWidget extends GetView<TruckDetailsController> {
  const CheckListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final checkList = controller.truckDetails.value?.overview?.checklists ?? [];

    if (checkList.isEmpty) {
      return const SectionEmptyState(
        icon: Icons.checklist_rounded,
        title: 'No checklist items',
        message: 'Checklist items for this truck will be listed here.',
        dense: true,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: checkList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Checklist check = checkList[index];
        return AddRemoveDateWidget(checklist: check);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

class AddRemoveDateWidget extends StatefulWidget {
  const AddRemoveDateWidget({
    super.key,
    required this.checklist,
  });
  final Checklist checklist;

  @override
  State<AddRemoveDateWidget> createState() => _AddRemoveDateWidgetState();
}

class _AddRemoveDateWidgetState extends State<AddRemoveDateWidget> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TruckDetailsController controller = Get.find<TruckDetailsController>();

  DateTime? _dateAdded;
  DateTime? _dateRemoved;

  @override
  void initState() {
    super.initState();
    // Initialize dates if they are provided in the checklist
    if (widget.checklist.addedDate != null) {
      _dateAdded = DateTime.parse(widget.checklist.addedDate!);
    }
    if (widget.checklist.removedDate != null) {
      _dateRemoved = DateTime.parse(widget.checklist.removedDate!);
    }
  }

  Future<void> _selectDate(bool isAdded) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Get.theme.copyWith(
            colorScheme: Get.theme.colorScheme.copyWith(
              primary: Colors.redAccent,
              onSurface: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isAdded) {
          _dateAdded = picked;
        } else {
          _dateRemoved = picked;
        }
      });
      // Update the date based on whether it's added or removed
      controller.updateTruckCheckList(
        id: widget.checklist.id.toString(),
        date: _dateFormat.format(picked),
        dateType: isAdded ? 'added_date' : 'removed_date',
      );
    }
  }

  void _clearDate(bool isAdded) {
    setState(() {
      if (isAdded) {
        _dateAdded = null;
      } else {
        _dateRemoved = null;
      }
    });

    controller.updateTruckCheckList(
      id: widget.checklist.id.toString(),
      date: "",
      dateType: isAdded ? 'added_date' : 'removed_date',
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final ThemeData theme = Theme.of(context);
    final bool hasDate = date != null;
    final String value = hasDate ? _dateFormat.format(date) : 'Select date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          button: true,
          label: hasDate ? '$label, $value' : '$label, no date selected',
          child: ExcludeSemantics(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: EdgeInsets.fromLTRB(10, 8, hasDate ? 4 : 10, 8),
                  decoration: BoxDecoration(
                    color: context.tileColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.hairlineBorderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: context.tertiaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hasDate
                                ? context.primaryTextColor
                                : context.hintTextColor,
                            fontWeight:
                                hasDate ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (hasDate)
                        IconButton(
                          onPressed: onClear,
                          tooltip: 'Clear $label',
                          iconSize: 16,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.secondaryTextColor,
                            semanticLabel: 'Clear $label',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget addedField = _buildDateField(
      label: "Date Added",
      date: _dateAdded,
      onTap: () => _selectDate(true),
      onClear: () => _clearDate(true),
    );

    final Widget removedField = _buildDateField(
      label: "Date Removed",
      date: _dateRemoved,
      onTap: () => _selectDate(false),
      onClear: () => _clearDate(false),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // checklist name
          Text(
            widget.checklist.name ?? "",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          //
          // added / removed dates — stacked on narrow widths so the fields stay
          // readable at large text sizes
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 320) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    addedField,
                    const SizedBox(height: 10),
                    removedField,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: addedField),
                  const SizedBox(width: 12),
                  Expanded(child: removedField),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

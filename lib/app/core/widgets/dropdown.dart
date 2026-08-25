import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DropDown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> listItems;
  final Widget? startIcon;
  final IconStyleData? endIcon;
  final String hint;
  T? selectedValue;
  final TextStyle? hintTextStyle;
  final void Function(dynamic value) onChange;
  final ButtonStyleData? buttonStyleData;
  final DropdownStyleData? dropdownStyleData;
  final MenuItemStyleData? menuItemStyleData;
  DropDown({
    super.key,
    required this.listItems,
    this.startIcon,
    required this.hint,
    required this.selectedValue,
    this.hintTextStyle,
    this.endIcon,
    this.buttonStyleData,
    this.dropdownStyleData,
    this.menuItemStyleData,
    required this.onChange,
  });

  @override
  State<DropDown> createState() => _DropDownState<T>();
}

class _DropDownState<T> extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                isExpanded: true,
                hint: Row(
                  children: [
                    if (widget.startIcon != null)
                      widget.startIcon!.marginOnly(right: 4),
                    Expanded(
                      child: Text(
                        widget.hint,
                        style:
                            widget.hintTextStyle ?? theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: (widget.listItems as List<DropdownMenuItem<T>>),
                value: widget.selectedValue,
                onChanged: (T? value) {
                  widget.onChange(value);
                  setState(() {
                    widget.selectedValue = value;
                  });
                },
                buttonStyleData: widget.buttonStyleData ??
                    ButtonStyleData(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              Get.isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ),
                iconStyleData: widget.endIcon ??
                    IconStyleData(
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor:
                          Get.isDarkMode ? Colors.white : Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                dropdownStyleData: widget.dropdownStyleData ??
                    DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Get.isDarkMode
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all<double>(6),
                        thumbVisibility: WidgetStateProperty.all<bool>(true),
                      ),
                    ),
                menuItemStyleData: widget.menuItemStyleData ??
                    const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_checkbox.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';

import '../../domain/entities/form_entity.dart';

class FormFieldRow extends GetView<FormDetailViewController> {
  final int formId;
  final String fieldType;
  final FormFieldEntity formField;
  final Function onSubmit;
  const FormFieldRow(
      {super.key,
      required this.formId,
      this.fieldType = 'text',
      required this.formField,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final isVaiolatedForm = formId == 75;
    switch (fieldType) {
      case 'editor':
        return Column(
          children: [
            Html(data: formField.formFieldsValue!.value, style: {
              "h2":
                  Style(fontSize: FontSize(18.sp), fontWeight: FontWeight.bold),
              "h3": Style(fontSize: FontSize(15.sp)),
              "h4": Style(fontSize: FontSize(15.sp)),
              "p": Style(fontSize: FontSize(15.sp)),
            }),
            addVerticalSpace(8.h),
          ],
        );
      case 'string':
        return AppTextAreaWidget(
          txtLabel: formField.label!,
          txtValue: formField.formFieldsValue!.value,
          isRequired: isVaiolatedForm ? false : formField.isRequired! == 1,
          isVaiolatedForm: isVaiolatedForm,
          txtController: formField.textEditingController,
          focusNode: formField.focusNode,
          onSubmit: onSubmit,
        );
      case 'textarea':
        return AppTextAreaWidget(
          txtLabel: formField.label!,
          txtValue: formField.formFieldsValue!.value,
          isRequired: isVaiolatedForm ? false : formField.isRequired! == 1,
          isVaiolatedForm: isVaiolatedForm,
          minLines: 4,
          maxLines: 4,
          focusNode: formField.focusNode,
          txtController: formField.textEditingController,
          onSubmit: onSubmit,
        );
      case 'checkbox':
        return Column(
          children: [
            if (isVaiolatedForm && formField.formFieldsValue!.value.isNotEmpty)
              CustomCheckbox(
                value: isVaiolatedForm
                    ? formField.formFieldsValue!.value.isNotEmpty
                    : true,
                text: formField.label!,
                onChange: null,
                focusNode: formField.focusNode,
              ),
            addVerticalSpace(8.h),
          ],
        );
      case 'date':
        return AppDateWidget(
          txtLabel: formField.label!,
          txtValue: formField.formFieldsValue!.value,
          isRequired: formField.isRequired! == 1,
          txtController: formField.textEditingController,
          focusNode: formField.focusNode,
        );
      default:
    }
    return const SizedBox();
  }
}

class AppTextAreaWidget extends StatelessWidget {
  AppTextAreaWidget({
    super.key,
    required this.txtLabel,
    required this.txtValue,
    required this.isRequired,
    required this.isVaiolatedForm,
    this.minLines = 1,
    this.maxLines = 2,
    this.txtController,
    required this.focusNode,
    required this.onSubmit,
  });

  final String txtLabel;
  final String txtValue;
  final int minLines;
  final int maxLines;
  final bool isRequired;
  final bool isVaiolatedForm;
  TextEditingController? txtController;
  final FocusNode focusNode;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    bool canEdit = isVaiolatedForm ? false : txtValue.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: txtLabel,
            style: Get.theme.textTheme.bodyMedium,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.sp,
                  ),
                ),
            ],
          ),
        ),
        addVerticalSpace(8.h),
        TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          enabled: canEdit,
          focusNode: focusNode,
          controller: txtController,
          validator: isRequired && txtValue.isEmpty
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This Field is Required*';
                  }
                  return null;
                }
              : null,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            onSubmit();
          },
          onTapOutside: (value) {
            focusNode.unfocus();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
              gapPadding: 4,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey[400]!),
              gapPadding: 4,
            ),
            errorStyle: const TextStyle(color: Colors.red),
            filled: true,
            fillColor: Get.isDarkMode
                ? Get.theme.scaffoldBackgroundColor
                : AppColorsLight.white,
            hintText: txtValue,
            isDense: true,
            contentPadding: EdgeInsets.all(10.w),
          ),
        ),
        addVerticalSpace(8),
      ],
    );
  }
}

class AppDateWidget extends StatelessWidget {
  AppDateWidget({
    super.key,
    required this.txtLabel,
    required this.txtValue,
    required this.isRequired,
    required this.txtController,
    required this.focusNode,
  });
  final String txtLabel;
  final String txtValue;
  final bool isRequired;
  TextEditingController txtController;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    bool showPicker = isRequired && txtValue.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: '$txtLabel:',
          style: Get.theme.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        addVerticalSpace(8.h),
        if (showPicker)
          RoundedInputField(
            label: "Date",
            hintText: "21-05-1898",
            controller: txtController,
            readOnly: true,
            suffixIcon: GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Get.theme.copyWith(
                        colorScheme: Get.theme.colorScheme.copyWith(
                          primary: Colors.redAccent,
                          onSurface:
                              Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  final formattedDate =
                      DateFormat('MM-dd-yyyy').format(pickedDate);
                  txtController.text = formattedDate;
                }
              },
              child: Icon(
                Icons.calendar_month_rounded,
                size: 25,
                color: Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
              ),
            ),
          ),
        if (showPicker == false)
          AppText(
            text: txtValue,
            style: Get.theme.textTheme.bodyMedium,
          ),
        addVerticalSpace(8.w),
      ],
    );
  }
}

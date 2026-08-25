// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/input_utils.dart';

import 'app_text.dart';

class CommonWidgets {
  Future<bool?> showAlertDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? cancelActionText,
    String defaultActionText = 'OK',
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  static void showSnackBar(
      {required String title,
      required String message,
      bool isError = true,
      Duration duration = const Duration(seconds: 3)}) {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      title,
      message,
      titleText: AppText(
        text: title,
        color: AppColorsLight.white,
      ),
      messageText: AppText(
        text: message,
        color: AppColorsLight.white,
        size: 15,
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
      backgroundColor: isError
          ? AppColorsLight.snakBarErrorColor
          : AppColorsLight.snakBarSuccessColor,
      padding: REdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      duration: duration,
    );
  }
}

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    super.key,
    this.titleText = '',
    this.titleTextAlign = TextAlign.center,
    required this.validatorMsg,
    required this.hintText,
    required this.labelText,
    this.icon,
    this.obsecure = false,
    this.readOnly = false,
    this.isRequired = true,
    this.textInputAction = TextInputAction.next,
    required this.textController,
    this.inputFormater,
    this.initialvalue,
    this.keyboardType,
    this.onChange,
    this.onsave,
  });

  final String titleText;
  final TextAlign titleTextAlign;
  final bool obsecure;
  final String validatorMsg;
  final String hintText;
  final String labelText;
  final dynamic icon;
  final bool readOnly;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextEditingController textController;
  final String? initialvalue;
  final Function(String val)? onChange;
  // ignore: prefer_typing_uninitialized_variables
  final inputFormater;
  final TextInputType? keyboardType;
  final Function(String val)? onsave;

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (newValue) {
        widget.onsave;
      },
      keyboardType: widget.keyboardType,
      initialValue: widget.initialvalue,
      textInputAction: widget.textInputAction,
      controller: widget.textController,
      validator:
          widget.keyboardType == TextInputType.emailAddress && widget.isRequired
              ? (val) {
                  final isValid = emailInputValidator(val!);
                  if (val.isEmpty) {
                    return widget.validatorMsg;
                  } else if (isValid) {
                    return null;
                  } else {
                    return 'Enter valid email address';
                  }
                }
              : widget.isRequired
                  ? (value) {
                      if (value!.isEmpty) {
                        return widget.validatorMsg;
                      }
                      return null;
                    }
                  : null,
      inputFormatters: widget.inputFormater,
      onChanged: widget.onChange,
      readOnly: widget.readOnly,
      obscureText: widget.obsecure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 30.h, left: 10.w),
        suffixIcon: widget.icon,
        errorStyle: TextStyle(fontSize: 13.sp),
        suffixIconColor: Colors.black,
        labelText: widget.readOnly ? null : widget.labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: "Poppins",
        ),
        hintText: widget.hintText, // pass the hint text parameter here
        hintStyle: const TextStyle(
          color: Colors.black26,
          fontFamily: "Poppins",
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: widget.readOnly ? Colors.grey : Colors.red,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 14.sp,
        color: Colors.black,
      ),
    );
  }
}

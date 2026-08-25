import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../controllers/request_loads_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class RequestLoadsView extends GetView<RequestLoadsController> {
  const RequestLoadsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            resizeToAvoidBottomInset: true,
            body: Container(
              height: Get.height,
              decoration: Get.isDarkMode
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Assets.images.background.path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // addVerticalSpace(10.h),
                    // FractionallySizedBox(
                    //   widthFactor: .6,
                    //   child: Image.asset(
                    //     Assets.images.tsflogo.path,
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.all(20.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.applyOpacity(0.5),
                            spreadRadius: 1.r,
                            blurRadius: 5.5.r,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back_outlined),
                              ),
                              Text(
                                'Request a Quote',
                                style: Get.theme.textTheme.headlineSmall,
                              ),
                              const SizedBox()
                            ],
                          ),
                          addVerticalSpace(20.h),

                          // name input
                          RoundedInputField(
                            hintText: "First Name",
                            controller: controller.firstNameController,
                          ),
                          addVerticalSpace(15.h),

                          // email input
                          RoundedInputField(
                            hintText: "Last Name",
                            controller: controller.lastNameController,
                            keyboardType: TextInputType.text,
                          ),

                          addVerticalSpace(15.h),

                          // password input
                          RoundedInputField(
                            hintText: "Phone",
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                          ),

                          addVerticalSpace(15.h),

                          // email input
                          RoundedInputField(
                            hintText: "Email",
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          addVerticalSpace(15.h),

                          // pickup address input
                          RoundedInputField(
                            hintText: "Pickup Address",
                            controller: controller.pickupLocationController,
                            keyboardType: TextInputType.streetAddress,
                          ),

                          addVerticalSpace(15.h),

                          // pickup date input
                          RoundedInputField(
                            hintText: "Pickup Date",
                            controller: controller.pickupDateController,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTap: () async {
                              debugPrint('tapped');
                              final pickedDate = await controller
                                  .selectDate(controller.pickupDateController);
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                controller.pickupDateController.text =
                                    formattedDate;
                              }
                            },
                          ),

                          addVerticalSpace(15.h),

                          // delivery address input
                          RoundedInputField(
                            hintText: "Delivery Address",
                            controller: controller.deliveryLocationController,
                            keyboardType: TextInputType.streetAddress,
                          ),

                          addVerticalSpace(15.h),

                          // delivery date input
                          RoundedInputField(
                            hintText: "Delivery Date",
                            controller: controller.deliveryDateController,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTap: () async {
                              debugPrint('tapped');
                              final pickedDate = await controller.selectDate(
                                  controller.deliveryDateController);
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                controller.deliveryDateController.text =
                                    formattedDate;
                              }
                            },
                          ),

                          addVerticalSpace(15.h),

                          // goods type input
                          RoundedInputField(
                            hintText: "Goods Type",
                            controller: controller.goodsTypeController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            onTap: () async {
                              debugPrint('tapped');
                              await controller.selectFromDropdown(
                                controller.goodsTypeController,
                              );
                            },
                          ),

                          addVerticalSpace(15.h),

                          // goods weight input
                          RoundedInputField(
                            hintText: "Goods Weight",
                            controller: controller.goodsWightController,
                            keyboardType: TextInputType.number,
                          ),

                          addVerticalSpace(15.h),

                          // goods height input

                          RoundedInputField(
                            hintText: "Goods Height",
                            controller: controller.goodsHightController,
                            keyboardType: TextInputType.number,
                          ),

                          //!===========
                          addVerticalSpace(30.h),

                          //login button
                          Obx(
                            () => controller.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColorsLight.mainColor,
                                  )
                                : MainAppButton(
                                    label: "Send enquiry",
                                    onPressed: () {
                                      controller.requestLoad();
                                    },
                                  ),
                          ),
                          addVerticalSpace(15.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

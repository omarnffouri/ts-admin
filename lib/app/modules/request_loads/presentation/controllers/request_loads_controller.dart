import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/utils/input_utils.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/request_loads/domain/usecases/request_loads_use_case.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class RequestLoadsController extends GetxController {
  final requestLoadsUseCase = sl<RequestLoadsUseCase>();
  // inpout field controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController pickupDateController = TextEditingController();

  TextEditingController deliveryLocationController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();

  TextEditingController goodsTypeController = TextEditingController();
  TextEditingController goodsWightController = TextEditingController();
  TextEditingController goodsHightController = TextEditingController();

  // state variab;es
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  requestLoad() async {
    if (firstNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter first name to process further.',
      );
      return;
    }
    if (lastNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter last name to process further.',
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter phone number to process further.',
      );
      return;
    }

    if (phoneController.text.length < 9) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid phone to process further.',
      );
      return;
    }

    if (!isValidEmail(emailController.text)) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid email address.',
      );
      return;
    }

    if (pickupLocationController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter pickup location to process further.',
      );
      return;
    }

    if (pickupDateController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please select pickup Date to process further.',
      );
      return;
    }

    if (deliveryLocationController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter delivery location to process further.',
      );
      return;
    }

    if (deliveryDateController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please select delivery Date to process further.',
      );
      return;
    }

    if (goodsTypeController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please enter goods type to process further.',
      );
      return;
    }

    _isLoading(true);

    final body = <String, dynamic>{
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "phone": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "pickup_location": pickupLocationController.text.trim(),
      "pickup_date_time": pickupDateController.text.trim(),
      "delivery_location": deliveryLocationController.text.trim(),
      "delivery_date_time": deliveryDateController.text.trim(),
      "goods_type": goodsTypeController.text.trim(),
      "goods_weight": goodsWightController.text.trim(),
      "goods_height": goodsHightController.text.trim(),
    };

    try {
      final response = await requestLoadsUseCase(body);
      _isLoading(false);
      response.fold(
        (success) {
          // clear all controllers
          emptyControllers(
            textEditingController: [
              firstNameController,
              lastNameController,
              phoneController,
              emailController,
              pickupLocationController,
              pickupDateController,
              deliveryLocationController,
              deliveryDateController,
              goodsTypeController,
              goodsWightController,
              goodsHightController,
            ],
          );
          CommonWidgets.showSnackBar(
            title: "Successfully Booked!",
            message:
                "Thank you for your inquiry. We will send you a price quotation based on your booked load or have one of our dispatch officers contact you. Please check your email for further details.",
            isError: false,
            duration: const Duration(seconds: 7),
          );
        },
        (Failure e) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: e.message,
            duration: const Duration(seconds: 7),
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoading(false);
    }
  }

  Future<DateTime?>? selectDate(TextEditingController controller) async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.redAccent,
              onSurface: Colors.black,
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
  }

  Future<void> selectFromDropdown(TextEditingController controller) async {
    // Define your options
    List<String> options = ["General", "Auto-Parts", "Mail"];

    // Show a modal with the options
    await showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: options.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(options[index]),
              onTap: () {
                controller.text = options[index];
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

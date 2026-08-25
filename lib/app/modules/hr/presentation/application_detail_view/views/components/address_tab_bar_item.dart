import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';

class AddressTabBarItem extends GetView<ApplicationDetailViewController> {
  final AddressTabs tab;
  const AddressTabBarItem({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tab.name.capitalizeFirst ?? '',
        ),
      ],
    ).marginSymmetric(vertical: 10);
  }
}

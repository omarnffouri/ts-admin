import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';

class ResourcesEmptyView extends StatelessWidget {
  const ResourcesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NoDataView(),
      ],
    ).marginSymmetric(horizontal: 24);
  }
}

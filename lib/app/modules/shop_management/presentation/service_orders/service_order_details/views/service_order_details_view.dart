import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../controllers/service_order_details_controller.dart';
import 'components/service_details_body.dart';
import 'components/service_order_details_header.dart';

class ServiceOrderDetailsView extends GetView<ServiceOrderDetailsController> {
  const ServiceOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          const ServiceOrderDetailsHeader(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SmartRefresher(
                controller: controller.refreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRefresh,
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: controller.isLoading.value
                        ? const Center(
                            key: ValueKey('service_details_loading'),
                            child: CircularProgressIndicator(
                              color: AppColorsLight.mainColor,
                            ),
                          )
                        : const ServiceDetailsBody(
                            key: ValueKey('service_details_body'),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

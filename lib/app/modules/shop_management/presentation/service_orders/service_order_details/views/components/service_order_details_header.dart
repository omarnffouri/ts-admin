import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../controllers/service_order_details_controller.dart';

class ServiceOrderDetailsHeader extends GetView<ServiceOrderDetailsController> {
  const ServiceOrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(16, topInset + 10, 16, 16),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: Get.back,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Service Order Details",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: controller.showUpdateButton.value
                  ? Material(
                      key: const ValueKey('edit_service_order'),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.CREATE_EDIT_SERVICE_ORDER,
                            arguments: controller.serviceOrder.value,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.applyOpacity(0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.applyOpacity(0.22),
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey('edit_service_order_hidden'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

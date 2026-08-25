import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/vehicle_details/vehicle_details_layout.dart';
import '../controllers/trailer_details_controller.dart';
import 'tabs/devices_page.dart';
import 'tabs/documents_page.dart';
import 'tabs/information_page.dart';
import 'tabs/overview_page.dart';

class TrailerDetailsView extends GetView<TrailerDetailsController> {
  const TrailerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VehicleDetailsLayout(
        header: VehicleDetailsHeader(
          title: 'Trailer Details',
          identifier: controller.trailerEntity.value?.identifier?.toString(),
          identifierLabel: 'Trailer',
          onBack: Get.back,
        ),
        titles: const ['Overview', 'Information', 'Documents', 'Devices'],
        pages: const [
          OverViewPage(),
          InformationPage(),
          DocumentsPage(),
          DevicesPage(),
        ],
      ),
    );
  }
}

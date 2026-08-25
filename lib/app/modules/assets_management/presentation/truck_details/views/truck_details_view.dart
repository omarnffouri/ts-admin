import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/vehicle_details/vehicle_details_layout.dart';
import '../controllers/truck_details_controller.dart';
import 'tabs/devices_page.dart';
import 'tabs/documents_page.dart';
import 'tabs/information_page.dart';
import 'tabs/overview_page.dart';

class TruckDetailsView extends GetView<TruckDetailsController> {
  const TruckDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VehicleDetailsLayout(
        header: VehicleDetailsHeader(
          title: 'Truck Details',
          identifier: controller.truckEntity.value?.identifier?.toString(),
          identifierLabel: 'Truck',
          onBack: Get.back,
        ),
        titles: controller.tabTitles,
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

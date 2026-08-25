import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../components/create_vehicle/create_vehicle_progress_header.dart';
import '../controllers/create_truck_controller.dart';
import 'tabs/general_tab.dart';
import 'tabs/lease_tab.dart';
import 'tabs/maintenance_tab.dart';
import 'tabs/ownership_tab.dart';
import 'tabs/plate_tab.dart';

class CreateTruckView extends GetView<CreateTruckController> {
  const CreateTruckView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: (controller.vehicleCreationState.value ==
                TruckCreationStates.general) &&
            (!controller.isCreating.value),
        onPopInvokedWithResult: (didPop, result) {
          controller.onBackPressed(didPop);
        },
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              //
              //
              // header
              CreateVehicleProgressHeader(
                title: '${controller.isUpdate ? 'Update' : 'Create'} Truck',
                currentStep: controller.vehicleCreationState.value,
                totalSteps: TruckCreationStates.values.length,
                stepName: controller.getStepName(
                  controller.vehicleCreationState.value,
                ),
                onBack: () => controller.onBackPressed(false),
              ),

              //
              //
              // steps
              Expanded(
                child: SafeArea(
                  top: false,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    // Block typing until the fetch lands — _setTextControllers
                    // would silently overwrite anything typed meanwhile.
                    child: AbsorbPointer(
                      absorbing: controller.isLoading.value,
                      child: PageView(
                        controller: controller.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          //
                          GeneralTap(),

                          //
                          PlateTap(),

                          //
                          OwnershipTap(),

                          //
                          LeaseTap(),

                          //
                          MaintenanceTap(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

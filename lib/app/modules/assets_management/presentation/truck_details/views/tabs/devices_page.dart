import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../controllers/truck_details_controller.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_device_card.dart';
import '../../../components/vehicle_details/vehicle_section.dart';

class DevicesPage extends GetView<TruckDetailsController> {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Devices? devices = controller.truckDetails.value?.devices;
        final bool isLoading = controller.isLoading.value;

        //
        // first load — nothing to keep on screen yet
        if (isLoading && devices == null) {
          return const _DevicesLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing truck devices',
          refreshController: controller.deviceRefreshCtrl,
          onRefresh: controller.init,
          sliver: devices == null
              ? VehicleDetailsErrorState(
                  title: 'Truck devices unavailable',
                  message: "We couldn't load this truck's devices.",
                  onRetry: controller.init,
                )
              : DevicesBody(devices: devices),
        );
      },
    );
  }
}

class DevicesBody extends GetView<TruckDetailsController> {
  const DevicesBody({super.key, required this.devices});

  final Devices devices;

  @override
  Widget build(BuildContext context) {
    final List<DeviceData> installedDevices = devices.installedDevices ?? [];
    final List<DeviceData> uninstalledDevices =
        devices.uninstalledDevices ?? [];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            //
            // installed devices
            VehicleSection(
              icon: Icons.sensors_rounded,
              title: 'Installed Devices',
              count: installedDevices.isEmpty ? null : installedDevices.length,
              action: VehicleSectionAction(
                label: 'Install Device',
                icon: Icons.add_box_outlined,
                onPressed: controller.showAddNewDeviceBottomSheet,
              ),
              child: installedDevices.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.sensors_off_rounded,
                      title: 'No installed devices',
                      message:
                          'Devices installed on this truck will be listed here.',
                      dense: true,
                    )
                  : _DeviceList(
                      devices: installedDevices,
                      isInstalled: true,
                    ),
            ),

            //
            // uninstalled devices
            VehicleSection(
              icon: Icons.history_rounded,
              title: 'UnInstalled Devices',
              count:
                  uninstalledDevices.isEmpty ? null : uninstalledDevices.length,
              child: uninstalledDevices.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.link_off_rounded,
                      title: 'No uninstalled devices',
                      message:
                          'Devices removed from this truck will be kept here.',
                      dense: true,
                    )
                  : _DeviceList(
                      devices: uninstalledDevices,
                      isInstalled: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical list of device cards inside a section.
class _DeviceList extends GetView<TruckDetailsController> {
  const _DeviceList({required this.devices, required this.isInstalled});

  final List<DeviceData> devices;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: devices.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final DeviceData device = devices[index];

        return VehicleDeviceCard(
          key: ValueKey(
            '${isInstalled ? 'installed' : 'uninstalled'}_device_${device.id ?? index}',
          ),
          device: device,
          isInstalled: isInstalled,
          onUninstall: (date) => controller.unInstallDevice(
            id: device.id.toString(),
            date: date,
          ),
        );
      },
    );
  }
}

/// Shimmering skeleton mirroring the sections while the first load is in
/// flight.
class _DevicesLoadingView extends StatelessWidget {
  const _DevicesLoadingView();

  @override
  Widget build(BuildContext context) {
    return const VehicleDetailsLoadingView(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              VehicleSectionSkeleton(
                icon: Icons.sensors_rounded,
                title: 'Installed Devices',
                itemHeight: 120,
              ),
              VehicleSectionSkeleton(
                icon: Icons.history_rounded,
                title: 'UnInstalled Devices',
                itemHeight: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

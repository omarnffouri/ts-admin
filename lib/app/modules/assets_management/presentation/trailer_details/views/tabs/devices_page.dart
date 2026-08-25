import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_device_card.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../../controllers/trailer_details_controller.dart';

class DevicesPage extends GetView<TrailerDetailsController> {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Devices? devices = controller.trailerDetails.value?.devices;
        final bool isLoading = controller.isLoading.value;

        if (isLoading && devices == null) {
          return const _DevicesLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing trailer devices',
          refreshController: controller.deviceRefreshCtrl,
          onRefresh: controller.init,
          sliver: devices == null
              ? VehicleDetailsErrorState(
                  title: 'Trailer devices unavailable',
                  message: "We couldn't load this trailer's devices.",
                  onRetry: controller.init,
                )
              : DevicesBody(devices: devices),
        );
      },
    );
  }
}

class DevicesBody extends GetView<TrailerDetailsController> {
  const DevicesBody({super.key, required this.devices});

  final Devices devices;

  @override
  Widget build(BuildContext context) {
    final List<DeviceData> installed = devices.installedDevices ?? [];
    final List<DeviceData> uninstalled = devices.uninstalledDevices ?? [];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      sliver: SliverToBoxAdapter(
        child: Column(
          spacing: 14,
          children: [
            VehicleSection(
              icon: Icons.sensors_rounded,
              title: 'Installed Devices',
              count: installed.isEmpty ? null : installed.length,
              action: VehicleSectionAction(
                label: 'Install Device',
                icon: Icons.add_box_outlined,
                onPressed: controller.showAddNewDeviceBottomSheet,
              ),
              child: installed.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.sensors_off_rounded,
                      title: 'No installed devices',
                      message:
                          'Devices installed on this trailer will be listed here.',
                      dense: true,
                    )
                  : _DeviceList(devices: installed, isInstalled: true),
            ),
            VehicleSection(
              icon: Icons.history_rounded,
              title: 'Uninstalled Devices',
              count: uninstalled.isEmpty ? null : uninstalled.length,
              child: uninstalled.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.link_off_rounded,
                      title: 'No uninstalled devices',
                      message:
                          'Devices removed from this trailer will be kept here.',
                      dense: true,
                    )
                  : _DeviceList(devices: uninstalled, isInstalled: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceList extends GetView<TrailerDetailsController> {
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
            spacing: 14,
            children: [
              VehicleSectionSkeleton(
                icon: Icons.sensors_rounded,
                title: 'Installed Devices',
                itemHeight: 120,
              ),
              VehicleSectionSkeleton(
                icon: Icons.history_rounded,
                title: 'Uninstalled Devices',
                itemHeight: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

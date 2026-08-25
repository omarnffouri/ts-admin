import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../controllers/truck_details_controller.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_information_section.dart';
import '../../../components/vehicle_details/vehicle_section.dart';

class InformationPage extends GetView<TruckDetailsController> {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Information? information =
            controller.truckDetails.value?.information;
        final bool isLoading = controller.isLoading.value;

        if (isLoading && information == null) {
          return const Skeletonizer(child: _InformationSkeleton());
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing truck information',
          refreshController: controller.informationRefreshCtrl,
          onRefresh: controller.init,
          sliver: information == null
              ? VehicleDetailsErrorState(
                  title: 'Truck information unavailable',
                  message: "We couldn't load this truck's information.",
                  onRetry: controller.init,
                )
              : InformationBody(information: information),
        );
      },
    );
  }
}

class InformationBody extends StatelessWidget {
  const InformationBody({super.key, required this.information});

  final Information information;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            _GeneralSection(general: information.general),
            _MaintenanceSection(maintenance: information.maintenance),
            _PlateSection(plate: information.plate),
            _LeaseSection(lease: information.lease),
            _OwnershipSection(ownership: information.ownership),
          ],
        ),
      ),
    );
  }
}

// general information section
class _GeneralSection extends StatelessWidget {
  const _GeneralSection({required this.general});

  final General? general;

  @override
  Widget build(BuildContext context) {
    final General? data = general;

    if (data == null) {
      return const _UnavailableSection(
        icon: Icons.local_shipping_outlined,
        title: 'General',
      );
    }

    return VehicleInformationSection(
      icon: Icons.local_shipping_outlined,
      title: 'General',
      children: [
        VehicleInformationRow(
          label: 'Identifier',
          value: '${data.identifier ?? "N/A"}',
        ),
        VehicleInformationRow(label: 'Make', value: data.maker ?? "N/A"),
        VehicleInformationRow(label: 'Model', value: data.model ?? "N/A"),
        VehicleInformationRow(
          label: 'Year',
          value: data.engineYear?.toString() ?? "N/A",
        ),
        VehicleInformationRow(
          label: 'Engine Make',
          value: data.engineMaker ?? "N/A",
        ),
        VehicleInformationRow(
          label: 'Engine Model',
          value: data.engineModel ?? "N/A",
        ),
        VehicleInformationRow(
          label: 'Engine Year',
          value: data.engineYear?.toString() ?? "N/A",
        ),
        VehicleInformationRow(
          label: 'Type',
          value: data.type?.toString() ?? "N/A",
        ),
        VehicleInformationRow(label: 'Vin', value: data.vin ?? "N/A"),
        VehicleInformationRow(
          label: 'Title Number',
          value: data.titleNumber ?? "N/A",
        ),
        VehicleInformationRow(label: 'Color', value: data.color ?? "N/A"),
        VehicleInformationRow(
          label: 'Glider',
          value: data.glider?.toString() ?? "N/A",
        ),
      ],
    );
  }
}

// maintanance information section
class _MaintenanceSection extends StatelessWidget {
  const _MaintenanceSection({required this.maintenance});

  final Maintenance? maintenance;

  @override
  Widget build(BuildContext context) {
    final Maintenance? data = maintenance;

    if (data == null) {
      return const _UnavailableSection(
        icon: Icons.build_outlined,
        title: 'Maintenance',
      );
    }

    return VehicleInformationSection(
      icon: Icons.build_outlined,
      title: 'Maintenance',
      children: [
        VehicleInformationRow(
          label: 'Next Inspection On',
          value: data.nextInspectionOn.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'In Service On',
          value: data.inServiceOn?.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'Next Service On',
          value: data.nextServiceOn?.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'Empty Weight',
          value: data.emptyWeight?.toString() ?? "N/A",
        ),
        VehicleInformationRow(
          label: 'Gross Weight',
          value: data.grossWeight?.toString() ?? "N/A",
        ),
      ],
    );
  }
}

//plate section
class _PlateSection extends StatelessWidget {
  const _PlateSection({required this.plate});

  final Plate? plate;

  @override
  Widget build(BuildContext context) {
    final Plate? data = plate;

    if (data == null) {
      return const _UnavailableSection(
        icon: Icons.pin_outlined,
        title: 'Plate',
      );
    }

    return VehicleInformationSection(
      icon: Icons.pin_outlined,
      title: 'Plate',
      children: [
        VehicleInformationRow(
          label: 'Licence Plate Number',
          value: data.licencePlateNumber,
        ),
        VehicleInformationRow(
          label: 'Licence Plate State',
          value: data.licencePlateState,
        ),
        VehicleInformationRow(
          label: 'Tags Expires On',
          value: data.tagsExpiresOn.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'Plates Owned By',
          value: data.platesOwnedBy,
        ),
      ],
    );
  }
}

//Lease section
class _LeaseSection extends StatelessWidget {
  const _LeaseSection({required this.lease});

  final Lease? lease;

  @override
  Widget build(BuildContext context) {
    final Lease? data = lease;

    if (data == null) {
      return const _UnavailableSection(
        icon: Icons.receipt_long_outlined,
        title: 'Lease',
      );
    }

    return VehicleInformationSection(
      icon: Icons.receipt_long_outlined,
      title: 'Lease',
      children: [
        VehicleInformationRow(
          label: 'Leasing Company',
          value: data.leasingCompany,
        ),
        VehicleInformationRow(
          label: 'Lease Reference',
          value: data.leaseReference,
        ),
        VehicleInformationRow(
          label: 'Lease End Date',
          value: data.leaseEndDate?.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'Lease Early Walk Date',
          value: data.leaseEarlyWalkDate.formatDateOrNA(),
        ),
        VehicleInformationRow(
          label: 'Lease Monthly Payment',
          value: data.leaseMonthlyPayment,
        ),
        VehicleInformationRow(
          label: 'Lease Maintenance CPM',
          value: data.leaseMaintenanceCpm,
        ),
        VehicleInformationRow(
          label: 'Lease Mileage Yearly Allowance',
          value: data.leaseMileageYearlyAllowance,
        ),
      ],
    );
  }
}

// ownership information section
class _OwnershipSection extends StatelessWidget {
  const _OwnershipSection({required this.ownership});

  final Ownership? ownership;

  @override
  Widget build(BuildContext context) {
    final Ownership? data = ownership;

    if (data == null) {
      return const _UnavailableSection(
        icon: Icons.badge_outlined,
        title: 'Ownership',
      );
    }

    return VehicleInformationSection(
      icon: Icons.badge_outlined,
      title: 'Ownership',
      children: [
        VehicleInformationRow(label: 'Owned By', value: data.ownedBy),
        VehicleInformationRow(label: 'Owner Name', value: data.ownerName),
        VehicleInformationRow(label: 'Owner Phone', value: data.ownerPhone),
        VehicleInformationRow(label: 'Lessor', value: data.lessor),
        VehicleInformationRow(label: 'Financed By', value: data.financedBy),
        VehicleInformationRow(
          label: 'Purchase Date',
          value: data.purchaseDate,
        ),
        VehicleInformationRow(
          label: 'Purchase Price',
          value: data.purchasePrice,
        ),
        VehicleInformationRow(label: 'Sale Date', value: data.saleDate),
        VehicleInformationRow(label: 'Sale Price', value: data.salePrice),
      ],
    );
  }
}

/// Shown when the API returned no object at all for a section — the same
/// "no data" condition the page checked before, in the shared themed style.
class _UnavailableSection extends StatelessWidget {
  const _UnavailableSection({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return VehicleInformationSection(
      icon: icon,
      title: title,
      children: [
        SectionEmptyState(
          icon: icon,
          title: 'No $title information',
          message: 'This truck has no $title details recorded yet.',
          dense: true,
        ),
      ],
    );
  }
}

/// Placeholder layout rendered through [Skeletonizer] while the first load is
/// in flight — mirrors the real section/row rhythm.
class _InformationSkeleton extends StatelessWidget {
  const _InformationSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            _skeletonSection(
              icon: Icons.local_shipping_outlined,
              title: 'General',
              rows: 6,
            ),
            _skeletonSection(
              icon: Icons.build_outlined,
              title: 'Maintenance',
              rows: 5,
            ),
            _skeletonSection(
              icon: Icons.pin_outlined,
              title: 'Plate',
              rows: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonSection({
    required IconData icon,
    required String title,
    required int rows,
  }) {
    return VehicleInformationSection(
      icon: icon,
      title: title,
      children: [
        for (int index = 0; index < rows; index++)
          const VehicleInformationRow(
            label: 'Placeholder label',
            value: 'Placeholder value',
          ),
      ],
    );
  }
}

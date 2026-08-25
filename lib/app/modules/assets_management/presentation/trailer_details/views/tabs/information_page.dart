import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_information_section.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../../controllers/trailer_details_controller.dart';

class InformationPage extends GetView<TrailerDetailsController> {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Information? information =
            controller.trailerDetails.value?.information;
        final bool isLoading = controller.isLoading.value;

        if (isLoading && information == null) {
          return const Skeletonizer(child: _InformationSkeleton());
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing trailer information',
          refreshController: controller.informationRefreshCtrl,
          onRefresh: controller.init,
          sliver: information == null
              ? VehicleDetailsErrorState(
                  title: 'Trailer information unavailable',
                  message: "We couldn't load this trailer's information.",
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
          spacing: 14,
          children: [
            _GeneralSection(general: information.general),
            _MaintenanceSection(maintenance: information.maintenance),
            _LeaseSection(lease: information.lease),
            _OwnershipSection(ownership: information.ownership),
          ],
        ),
      ),
    );
  }
}

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
          value: data.identifier?.toString(),
        ),
        VehicleInformationRow(label: 'Make', value: data.maker),
        VehicleInformationRow(label: 'Model', value: data.model),
        VehicleInformationRow(
          label: 'Year',
          value: data.makingYear?.toString(),
        ),
        VehicleInformationRow(label: 'Type', value: data.type?.toString()),
        VehicleInformationRow(label: 'Vin', value: data.vin),
        VehicleInformationRow(label: 'Title Number', value: data.titleNumber),
        VehicleInformationRow(
          label: 'Licence Plate Number',
          value: data.licencePlateNumber,
        ),
      ],
    );
  }
}

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
      ],
    );
  }
}

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
      ],
    );
  }
}

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
        VehicleInformationRow(label: 'Financed By', value: data.financedBy),
        VehicleInformationRow(label: 'Purchase Date', value: data.purchaseDate),
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
          message: 'This trailer has no $title details recorded yet.',
          dense: true,
        ),
      ],
    );
  }
}

class _InformationSkeleton extends StatelessWidget {
  const _InformationSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 30),
        child: Column(
          spacing: 14,
          children: [
            VehicleInformationSection(
              icon: Icons.local_shipping_outlined,
              title: 'General',
              children: [
                VehicleInformationRow(label: 'Identifier', value: 'Loading'),
                VehicleInformationRow(label: 'Make', value: 'Loading'),
                VehicleInformationRow(label: 'Model', value: 'Loading'),
              ],
            ),
            VehicleInformationSection(
              icon: Icons.build_outlined,
              title: 'Maintenance',
              children: [
                VehicleInformationRow(
                  label: 'Next Inspection On',
                  value: 'Loading',
                ),
                VehicleInformationRow(
                  label: 'In Service On',
                  value: 'Loading',
                ),
              ],
            ),
            VehicleInformationSection(
              icon: Icons.receipt_long_outlined,
              title: 'Lease',
              children: [
                VehicleInformationRow(
                  label: 'Leasing Company',
                  value: 'Loading',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

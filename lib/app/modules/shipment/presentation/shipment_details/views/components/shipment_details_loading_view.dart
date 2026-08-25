import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';

import 'shipment_section_card.dart';

/// Skeleton for the shipment-details page: the overview card followed by the
/// label/value sections, in the same chrome [ShipmentSectionCard] uses.
class ShipmentDetailsLoadingView extends StatelessWidget {
  const ShipmentDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: const [
          _OverviewSkeleton(),
          SizedBox(height: 12),
          _SectionSkeleton(rows: 4),
          SizedBox(height: 12),
          _SectionSkeleton(rows: 3),
          SizedBox(height: 12),
          _SectionSkeleton(rows: 2),
          SizedBox(height: 12),
          _SectionSkeleton(rows: 3),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShipmentSectionCard.decoration(context),
      child: SkeletonBones(child: child),
    );
  }
}

class _OverviewSkeleton extends StatelessWidget {
  const _OverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBone(width: 40, height: 40, radius: 12),
              SizedBox(width: 12),
              Expanded(child: SkeletonBone(height: 16, radius: 8)),
              SizedBox(width: 8),
              SkeletonBone(width: 72, height: 26, radius: 999),
            ],
          ),
          SizedBox(height: 12),
          SkeletonBone(width: 124, height: 24, radius: 999), // dispatch chip
          SizedBox(height: 12),
          SkeletonBone(height: 1, radius: 0), // divider
          SizedBox(height: 12),
          _DriverRowSkeleton(),
          SizedBox(height: 10),
          _DriverRowSkeleton(),
        ],
      ),
    );
  }
}

class _DriverRowSkeleton extends StatelessWidget {
  const _DriverRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonBone(width: 32, height: 32, radius: 10),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBone(height: 11, radius: 5),
              SizedBox(height: 6),
              FractionallySizedBox(
                widthFactor: 0.55,
                child: SkeletonBone(height: 9, radius: 5),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        SkeletonBone(width: 44, height: 10, radius: 5),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title: icon + label.
          const Row(
            children: [
              SkeletonBone(width: 18, height: 18, radius: 5),
              SizedBox(width: 8),
              SkeletonBone(width: 132, height: 12),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < rows; i++) ...[
            const Row(
              children: [
                SkeletonBone(width: 92, height: 11, radius: 5), // label
                Spacer(),
                SkeletonBone(width: 62, height: 11, radius: 5), // value
              ],
            ),
            if (i != rows - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

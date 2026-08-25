import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';
import 'package:ts_admin/app/modules/shipment/presentation/shipments/views/shipments_view.dart';

/// Skeleton mirroring the collapsed [ShipmentListItem] anatomy.
class ShipmentsLoadingView extends StatelessWidget {
  const ShipmentsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 2.h),
        itemCount: 8,
        itemBuilder: (context, index) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      child: Container(
        decoration: ShipmentListItem.decoration(context),
        // Matches ExpandedCard's inner padding.
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 2.h),
          child: SkeletonBones(
            child: Column(
              children: [
                // Header: icon tile · shipment number · status badge.
                Row(
                  children: [
                    SkeletonBone(width: 36.r, height: 36.r, radius: 12.r),
                    SizedBox(width: 10.w),
                    const Expanded(
                      child: SkeletonBone(height: 14, radius: 7),
                    ),
                    SizedBox(width: 10.w),
                    SkeletonBone(width: 96.w, height: 30, radius: 999),
                  ],
                ),
                SizedBox(height: 12.h),
                // One driver line: type pill · name · truck.
                Row(
                  children: [
                    SkeletonBone(width: 54.w, height: 20, radius: 999),
                    SizedBox(width: 8.w),
                    const Expanded(
                      child: SkeletonBone(height: 12, radius: 6),
                    ),
                    SizedBox(width: 8.w),
                    SkeletonBone(width: 34.w, height: 11, radius: 5),
                  ],
                ),
                SizedBox(height: 6.h),
                // Expand chevron.
                SkeletonBone(width: 22.r, height: 22.r, radius: 6),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

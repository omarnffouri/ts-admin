import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';
import 'package:ts_admin/app/modules/shipment/presentation/additional_pay/views/components/additional_pay_request_card.dart';

/// Skeleton mirroring [AdditionalPayRequestCard] anatomy.
class AdditionalPayLoadingView extends StatelessWidget {
  const AdditionalPayLoadingView({super.key, required this.status});

  /// The tab being loaded — drawing action bones on a decided tab would
  /// collapse every card on arrival.
  final AdditionalPayStatus status;

  @override
  Widget build(BuildContext context) {
    final Widget card = _SkeletonCard(status: status);

    return IgnorePointer(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 2.h),
        itemCount: 6,
        itemBuilder: (context, index) => card,
      ),
    );
  }
}

/// Skeleton mirroring the status-tab pills, for the first load.
/// Rendered inside [_StatusTabs]'s scroll strip, so no scroll view here.
class AdditionalPayTabsSkeleton extends StatelessWidget {
  const AdditionalPayTabsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final int tabCount = AdditionalPayStatus.values.length;

    return IgnorePointer(
      child: Row(
        children: List.generate(
          tabCount,
          (index) => Padding(
            padding: EdgeInsets.only(right: index == tabCount - 1 ? 0 : 8.w),
            child: const _SkeletonTab(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonTab extends StatelessWidget {
  const _SkeletonTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        color: context.flatCardColor,
        borderRadius: BorderRadius.circular(14),
        border: context.isDark
            ? null
            : Border.all(color: Colors.black.applyOpacity(0.04)),
      ),
      child: SkeletonBones(
        child: Row(
          children: [
            const SkeletonBone(width: 28, height: 28, radius: 14),
            SizedBox(width: 8.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBone(width: 42.w, height: 8, radius: 4),
                SizedBox(height: 6.h),
                SkeletonBone(width: 18.w, height: 10, radius: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.status});

  final AdditionalPayStatus status;

  @override
  Widget build(BuildContext context) {
    final double slot = AdditionalPayRequestCard.glyphSlot.w;
    final double gutter = AdditionalPayRequestCard.glyphGutter.w;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
        decoration: AdditionalPayRequestCard.decoration(context),
        // Bones only — the shimmer repaints every opaque pixel under it.
        child: SkeletonBones(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SkeletonBone(
                              width: slot,
                              height: slot,
                              radius: 7,
                            ),
                            SizedBox(width: gutter),
                            SkeletonBone(width: 112.w, height: 13, radius: 6),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            SizedBox(
                              width: slot,
                              child: SkeletonBone(
                                  width: 14.w, height: 14, radius: 4),
                            ),
                            SizedBox(width: gutter),
                            SkeletonBone(width: 92.w, height: 10, radius: 5),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.only(left: slot + gutter),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonBone(width: 112.w, height: 10, radius: 5),
                              SizedBox(height: 7.h),
                              SkeletonBone(width: 84.w, height: 9, radius: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: AdditionalPayRequestCard.moneyColumnWidth.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SkeletonBone(width: 104.w, height: 18, radius: 8),
                        SizedBox(height: 8.h),
                        SkeletonBone(width: 66.w, height: 9, radius: 5),
                      ],
                    ),
                  ),
                ],
              ),
              if (status.hasActionRow) ...[
                SizedBox(height: 12.h),
                const Row(
                  children: [
                    Expanded(
                        flex: 2, child: SkeletonBone(height: 40, radius: 12)),
                    SizedBox(width: 10),
                    Expanded(
                        flex: 3, child: SkeletonBone(height: 40, radius: 12)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

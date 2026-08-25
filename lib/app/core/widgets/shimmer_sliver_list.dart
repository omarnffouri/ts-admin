import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';

/// Shimmering placeholder sliver: [itemCount] rounded cards of [itemHeight],
/// or custom per-item bones via [itemBuilder].
///
/// [itemBuilder] output goes inside the shimmer mask, so build it from
/// [SkeletonBone]s only — an opaque card fill there flattens into one
/// rectangle. Paint card chrome around this sliver, not in the builder.
class ShimmerSliverList extends StatelessWidget {
  const ShimmerSliverList({
    super.key,
    required this.itemCount,
    this.itemHeight = 120,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 24),
    this.itemSpacing = 12,
    this.borderRadius = 16,
    this.itemBuilder,
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final double borderRadius;
  final IndexedWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => SkeletonBones(
            child: Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
              child: itemBuilder?.call(context, index) ??
                  SkeletonBone(height: itemHeight, radius: borderRadius),
            ),
          ),
          childCount: itemCount,
        ),
      ),
    );
  }
}

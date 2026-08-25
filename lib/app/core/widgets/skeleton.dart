import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Shimmer paint over a group of [SkeletonBone]s.
///
/// Wrap ONLY the bones — keep card chrome outside. `Shimmer` masks its subtree
/// with `BlendMode.srcIn`, so an opaque fill inside it repaints as the sweep
/// and the anatomy collapses into one flat rectangle.
class SkeletonBones extends StatelessWidget {
  const SkeletonBones({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;

  /// Default to the theme-resolved skeleton tokens. Override for bones on a
  /// surface that isn't the app canvas — white-based on the red hero, say.
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: baseColor ?? context.skeletonBaseColor,
        highlightColor: highlightColor ?? context.skeletonHighlightColor,
        child: child,
      ),
    );
  }
}

/// One skeleton block, sized to the real element it stands in for so nothing
/// shifts when the content arrives. Only meaningful inside [SkeletonBones].
class SkeletonBone extends StatelessWidget {
  const SkeletonBone({
    super.key,
    this.width,
    required this.height,
    this.radius = 6,
  });

  /// Null fills the parent — for bones inside an [Expanded].
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

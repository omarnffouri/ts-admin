import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Frosted translucent surface for the red [AppRedHeader] gradient — the one
/// glass recipe, so blur and fill can only be tuned in one place.
///
/// [GlassControl] is the fixed-size icon-button flavour; this is the free-form
/// panel (shift block, stat tile, animated icon button).
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.radius,
    required this.blur,
    this.onTap,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.child,
  });

  final double radius;
  final double blur;

  /// Null leaves the surface inert — no ink response is inserted at all.
  final VoidCallback? onTap;

  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final BorderRadius corners = BorderRadius.circular(radius);

    Widget surface = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: corners,
        border: Border.all(color: AppColorsLight.onHeroGlassBorder),
      ),
      child: child,
    );

    if (onTap != null) {
      surface = InkWell(
        onTap: onTap,
        borderRadius: corners,
        // The theme default splash is invisible on the gradient.
        highlightColor: Colors.white.applyOpacity(0.10),
        splashColor: Colors.white.applyOpacity(0.08),
        child: surface,
      );
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: corners,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(color: AppColorsLight.onHeroGlass, child: surface),
        ),
      ),
    );
  }
}

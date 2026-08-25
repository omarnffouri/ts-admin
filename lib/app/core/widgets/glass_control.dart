import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Frosted-glass icon button used on red gradient headers
/// (pairs with [AppRedHeader]).
class GlassControl extends StatelessWidget {
  const GlassControl({super.key, required this.icon, required this.onTap});

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.white.applyOpacity(0.16),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.applyOpacity(0.22)),
              ),
              child: IconButton(
                onPressed: onTap,
                icon: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

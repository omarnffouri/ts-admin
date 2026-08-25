import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class LoadingWrapperWidget extends StatelessWidget {
  const LoadingWrapperWidget({
    super.key,
    required this.child,
    required this.isLoading,
  });
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: AppColorsLight.white,
            child: child,
          )
        : child;
  }
}

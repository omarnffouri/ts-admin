import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class ServiceOrdersLoadingView extends StatelessWidget {
  const ServiceOrdersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
      sliver: SliverList.separated(
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: isDark ? Colors.white10 : Colors.black12,
            highlightColor: isDark ? Colors.white24 : Colors.white30,
            child: Container(
              height: 218,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          );
        },
      ),
    );
  }
}

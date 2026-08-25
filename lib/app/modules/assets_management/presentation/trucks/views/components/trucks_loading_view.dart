import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Skeleton sliver shown while the truck/trailer list is loading. The
/// skeleton tiles use a fixed height purely as loading placeholders —
/// the real [TruckCard] stays height-unconstrained so long content wraps.
class TrucksLoadingView extends StatelessWidget {
  const TrucksLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
      sliver: SliverList.separated(
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: isDark ? Colors.white10 : Colors.black12,
            highlightColor: isDark ? Colors.white24 : Colors.white30,
            child: Container(
              height: 168,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../controllers/trucks_controller.dart';
import 'truck_card.dart';

class TrucksBody extends GetView<TrucksController> {
  const TrucksBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Own Obx: parent branches return this widget as const, so list appends
    // and the load-more spinner must subscribe here to re-render.
    return Obx(() {
      final trucks = controller.trucks;
      final bool showLoadMore = controller.isLoadingMore.value;
      final int itemCount = trucks.length + (showLoadMore ? 1 : 0);

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= trucks.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: _PaginationLoader(),
                );
              }

              final truck = trucks[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CardEntrance(
                  index: index,
                  child: TruckCard(
                    truck: truck,
                    onTap: () => Get.toNamed(
                      Routes.TRUCK_DETAILS,
                      arguments: truck,
                    ),
                    onEdit: () => Get.toNamed(
                      Routes.CREATE_TRUCK,
                      arguments: truck,
                    ),
                    onNotesTap: (truck.truckNotes?.isNotEmpty ?? false)
                        ? () => controller.showNotesBottomSheet(
                              truck.id.toString(),
                              truck.truckNotes!,
                            )
                        : null,
                  ),
                ),
              );
            },
            childCount: itemCount,
          ),
        ),
      );
    });
  }
}

class _PaginationLoader extends StatelessWidget {
  const _PaginationLoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 26,
        height: 26,
        child: CircularProgressIndicator(
          color: context.brandColor,
          strokeCap: StrokeCap.round,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

/// Subtle fade + slide-up reveal, lightly staggered for the first few cards.
class _CardEntrance extends StatelessWidget {
  const _CardEntrance({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + index.clamp(0, 6) * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

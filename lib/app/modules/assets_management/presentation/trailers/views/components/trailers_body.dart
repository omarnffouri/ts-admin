import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../controllers/trailers_controller.dart';
import 'trailer_card.dart';

class TrailersBody extends GetView<TrailersController> {
  const TrailersBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Own Obx: parent branches return this widget as const, so list appends
    // and the load-more spinner must subscribe here to re-render.
    return Obx(() {
      final trailers = controller.trailers;
      final bool showLoadMore = controller.isLoadingMore.value;
      final int itemCount = trailers.length + (showLoadMore ? 1 : 0);

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= trailers.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: _PaginationLoader(),
                );
              }

              final trailer = trailers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CardEntrance(
                  index: index,
                  child: TrailerCard(
                    trailer: trailer,
                    onTap: () => Get.toNamed(
                      Routes.TRAILER_DETAILS,
                      arguments: trailer,
                    ),
                    onEdit: () => Get.toNamed(
                      Routes.CREATE_TRAILER,
                      arguments: trailer,
                    ),
                    onNotesTap: (trailer.trailerNotes?.isNotEmpty ?? false)
                        ? () => controller.showNotesBottomSheet(
                              trailer.id.toString(),
                              trailer.trailerNotes!,
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

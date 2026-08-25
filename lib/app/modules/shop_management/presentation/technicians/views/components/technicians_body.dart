import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../controllers/technicians_controller.dart';
import 'technician_item_card.dart';

class TechniciansBody extends GetView<TechniciansController> {
  const TechniciansBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final technicians = controller.filterList;
        return SlidableAutoCloseBehavior(
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
            itemCount: technicians.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _CardEntrance(
              index: index,
              child: TechnicianCard(technician: technicians[index]),
            ),
          ),
        );
      },
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
      duration: Duration(milliseconds: 260 + index.clamp(0, 8) * 35),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

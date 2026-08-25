import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';

/// A single segment inside the chat header's segmented control.
///
/// Rendered as a [Tab] driven by the [TabBar] — the label colour/weight comes
/// from the parent's `labelColor`/`labelStyle`, matching the Task Management
/// header. The unread badge is overlaid alongside the label.
class ChatTabBarItem extends GetView<ConversationsController> {
  final ConversationTabs tab;
  final String label;

  const ChatTabBarItem({super.key, required this.tab, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40.h,
      child: Obx(() {
        final bool selected = controller.currentTab.value == tab;
        final int badge = _badgeCount;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                style: DefaultTextStyle.of(context).style,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (badge > 0) ...[
              const SizedBox(width: 6),
              _Badge(count: badge, selected: selected),
            ],
          ],
        );
      }),
    );
  }

  /// Unread count for this tab — 0 for tabs without a badge (e.g. contacts).
  int get _badgeCount {
    switch (tab) {
      case ConversationTabs.chat:
        return controller.otoUnreadCounts;
      case ConversationTabs.group:
        return controller.groupUnreadCounts;
      case ConversationTabs.contacts:
        return 0;
    }
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count, required this.selected});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: selected
            ? AppColorsLight.mainColor
            : Colors.white.applyOpacity(0.28),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

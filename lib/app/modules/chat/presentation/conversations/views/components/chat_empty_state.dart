import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Clean, lightweight empty state shared across the chat tabs.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    AppColorsLight.mainColor.applyOpacity(isDark ? 0.16 : 0.08),
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColorsLight.mainColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? Colors.white.applyOpacity(0.6)
                          : AppColorsLight.textColor.applyOpacity(0.8),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

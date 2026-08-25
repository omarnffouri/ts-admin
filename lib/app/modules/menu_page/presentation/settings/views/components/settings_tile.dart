import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class SettingsTileShell extends StatelessWidget {
  const SettingsTileShell({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  final bool isDestructive;

  static const double iconSize = 20;
  static const double _badgeSize = 34;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent =
        isDestructive ? context.dangerColor : context.secondaryTextColor;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            //
            // leading badge
            Container(
              width: _badgeSize,
              height: _badgeSize,
              decoration: BoxDecoration(
                color: isDestructive
                    ? context.dangerColor.applyOpacity(0.12)
                    : context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: iconSize, color: accent),
            ),

            const SizedBox(width: 12),

            //
            // label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.tertiaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A tappable settings row: full-width ink feedback, a directional chevron and
/// a screen-reader label.
///
/// Taps that land within [_tapCooldown] of the previous one are ignored, so a
/// double tap can never push the same route twice. The callback itself is
/// untouched — it still runs exactly what the page passed in.
class SettingsTile extends StatefulWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.semanticsLabel,
    this.subtitle,
    this.showChevron = true,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final String semanticsLabel;
  final bool showChevron;
  final bool isDestructive;

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  static const Duration _tapCooldown = Duration(milliseconds: 700);

  DateTime? _lastTapAt;

  void _handleTap() {
    final DateTime now = DateTime.now();
    final DateTime? last = _lastTapAt;
    if (last != null && now.difference(last) < _tapCooldown) {
      return;
    }
    _lastTapAt = now;
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: InkWell(
        onTap: _handleTap,
        child: SettingsTileShell(
          icon: widget.icon,
          title: widget.title,
          subtitle: widget.subtitle,
          isDestructive: widget.isDestructive,
          trailing: widget.showChevron
              ? Icon(
                  isRtl
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: context.tertiaryTextColor,
                )
              : null,
        ),
      ),
    );
  }
}

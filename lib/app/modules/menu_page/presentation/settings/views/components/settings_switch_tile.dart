import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'settings_tile.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.onTap,
    this.isBusy = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  /// Shows a compact spinner beside the switch while an update is processing.
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final Widget row = SettingsTileShell(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isBusy) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                strokeCap: StrokeCap.round,
                color: context.secondaryTextColor,
              ),
            ),
            const SizedBox(width: 10),
          ],
          CupertinoSwitch(
            value: value,
            activeTrackColor: context.brandColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );

    return MergeSemantics(
      child: onTap == null
          ? row
          : InkWell(
              onTap: onTap,
              child: row,
            ),
    );
  }
}

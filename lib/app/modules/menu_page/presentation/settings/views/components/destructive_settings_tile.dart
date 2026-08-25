import 'package:flutter/material.dart';

import 'settings_tile.dart';

class DestructiveSettingsTile extends StatelessWidget {
  const DestructiveSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.semanticsLabel,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      isDestructive: true,
    );
  }
}

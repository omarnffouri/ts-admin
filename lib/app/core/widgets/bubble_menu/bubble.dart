import 'package:flutter/material.dart';

class Bubble {
  const Bubble({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleStyle,
    required this.bubbleColor,
    required this.onPress,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final TextStyle titleStyle;
  final Color bubbleColor;
  final void Function() onPress;
}

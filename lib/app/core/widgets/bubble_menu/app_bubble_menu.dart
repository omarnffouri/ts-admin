import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/bubble.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Creates a bubble menu for all the items for floating action menu button.
class AppBubbleMenu extends StatelessWidget {
  const AppBubbleMenu(this.item, {super.key});

  final Bubble item;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: item.bubbleColor,
      splashColor: Colors.grey.applyOpacity(0.1),
      highlightColor: Colors.grey.applyOpacity(0.1),
      elevation: 2,
      highlightElevation: 2,
      disabledColor: item.bubbleColor,
      onPressed: item.onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            item.icon,
            color: item.iconColor,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            item.title,
            style: item.titleStyle,
          ),
        ],
      ),
    );
  }
}

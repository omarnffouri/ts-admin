import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourcesLoadingErrorView extends StatelessWidget {
  const ResourcesLoadingErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //
        //
        //
        Text(
          "Something went wrong, while loading resources.",
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).marginSymmetric(horizontal: 24);
  }
}

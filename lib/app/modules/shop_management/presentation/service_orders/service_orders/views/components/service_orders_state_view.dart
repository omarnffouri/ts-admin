import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';

class ServiceOrdersStateView extends StatelessWidget {
  const ServiceOrdersStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyStateView(icon: icon, title: title, message: message),
              if (actionLabel != null && onAction != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: FilledButton.icon(
                    onPressed: onAction,
                    style: FilledButton.styleFrom(
                      backgroundColor: context.brandColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      actionLabel == 'Try again'
                          ? Icons.refresh_rounded
                          : Icons.filter_list_off_rounded,
                    ),
                    label: Text(actionLabel!.tr),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

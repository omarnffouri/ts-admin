part of '../message_notifications_view.dart';

class _MessageNotificationsErrorView
    extends GetView<MessageNotificationsController> {
  const _MessageNotificationsErrorView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.dividerColor),
            boxShadow: Get.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: AppColorsLight.mainColor.applyOpacity(0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorsLight.mainColor.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColorsLight.mainColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Couldn't load notifications",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Check your connection and try again.",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: MainAppButton(
                  label: "Retry",
                  onPressed: controller.loadInitialData,
                  borderRadius: 16,
                  leadingIcon: const Icon(
                    Icons.refresh_rounded,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

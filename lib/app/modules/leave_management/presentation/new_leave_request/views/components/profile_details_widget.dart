import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/new_leave_request_controller.dart';

class ProfileDetailsWidget extends GetView<NewLeaveRequestController> {
  const ProfileDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    final items = <MapEntry<IconData, List<String>>>[
      MapEntry(Icons.person_outline_rounded, ['Name', user?.name ?? 'N/A']),
      MapEntry(Icons.phone_outlined, ['Phone Number', user?.phone ?? 'N/A']),
      MapEntry(Icons.badge_outlined,
          ['Designation', user?.designation?.name ?? 'N/A']),
      MapEntry(Icons.apartment_outlined,
          ['Department', user?.department?.name ?? 'N/A']),
      MapEntry(Icons.email_outlined, ['Email', user?.email ?? 'N/A']),
      MapEntry(Icons.location_on_outlined, ['Address', user?.address ?? 'N/A']),
    ];

    final isDark = Get.isDarkMode;
    final divider = isDark ? Colors.white12 : const Color(0xFFEDEDED);

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i != 0) Divider(color: divider, height: 20),
          CustomCardInfo(
            icon: items[i].key,
            title: items[i].value[0],
            val: items[i].value[1],
          ),
        ],
      ],
    );
  }
}

class CustomCardInfo extends StatelessWidget {
  const CustomCardInfo({
    super.key,
    required this.title,
    required this.val,
    required this.icon,
  });

  final String title;
  final String val;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : const Color(0xFFF4F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 19,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                val,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

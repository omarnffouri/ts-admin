import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class EmployeeManagement extends StatelessWidget {
  const EmployeeManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final ThemeData theme = Theme.of(context);
    final bool isSuperAdmin =
        Get.find<AuthController>().userPermissionHelper.isSuperAdmin();

    final tiles = <Widget>[
      _LeaveTile(
        title: 'New Leave Request',
        subtitle: 'Create a new leave request',
        iconPath: Assets.icons.newLeaveRequest,
        onTap: () => Get.toNamed(Routes.NEW_LEAVE_REQUEST),
      ),
      _LeaveTile(
        title: 'My Leave Requests',
        subtitle: 'View your submitted requests',
        iconPath: Assets.icons.myLeaveRequests,
        onTap: () => Get.toNamed(Routes.LEAVE_REQUESTED),
      ),
      if (isSuperAdmin) ...[
        _LeaveTile(
          title: 'Manage Leave Requests',
          subtitle: 'Review and approve requests',
          iconPath: Assets.icons.manageLeaveRequests,
          onTap: () => Get.toNamed(Routes.MANAGE_LEAVE_REQUESTS),
        ),
        _LeaveTile(
          title: 'Leave Requests History',
          subtitle: 'Check previous leave records',
          iconPath: Assets.icons.leaveRequestsHistory,
          onTap: () => Get.toNamed(Routes.LEAVE_REQUESTS_HISTORY),
        ),
      ],
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // header
          AppRedHeader(
            width: double.infinity,
            radius: 32,
            padding: EdgeInsets.fromLTRB(12, topInset + 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Leave Management',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // grid of tiles
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const double gap = 16;
                      final double tileWidth = (constraints.maxWidth - gap) / 2;
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final tile in tiles)
                            SizedBox(width: tileWidth, child: tile),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Assets.images.leaveTS.image(
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaveTile extends StatelessWidget {
  const _LeaveTile({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.08)
              : const Color(0xFFEDEDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.applyOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // red-tinted icon container
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColorsLight.mainColor.applyOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SvgPicture.asset(
                        iconPath,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          AppColorsLight.mainColor.applyOpacity(0.7),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // red arrow chip
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color:
                            AppColorsLight.calanderBoxColor.applyOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: Get.isDarkMode
                            ? Colors.white.applyOpacity(0.8)
                            : Colors.black.applyOpacity(0.4),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? Colors.white.applyOpacity(0.6)
                        : AppColorsLight.textColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class TasksEmptyState extends StatefulWidget {
  const TasksEmptyState({
    super.key,
    required this.title,
    required this.descrption,
    required this.padding,
    required this.radius,
    this.bgColor,
  });
  final String title, descrption;
  final double padding, radius;
  final Color? bgColor;

  @override
  State<TasksEmptyState> createState() => _TasksEmptyStateState();
}

class _TasksEmptyStateState extends State<TasksEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _floatAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;
    final Color cardColor =
        isDark ? Colors.white.applyOpacity(0.06) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final Color bodyColor =
        isDark ? Colors.white.applyOpacity(0.62) : const Color(0xFF71717A);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.padding.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 28.h),
            decoration: BoxDecoration(
              color: widget.bgColor ?? cardColor,
              borderRadius: BorderRadius.circular(widget.radius.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.applyOpacity(0.08)
                    : const Color(0xFFEAECEF),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.applyOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -8 * _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 124.r,
                        height: 124.r,
                        decoration: BoxDecoration(
                          color: AppColorsLight.mainColor.applyOpacity(
                            isDark ? 0.18 : 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 94.r,
                        height: 94.r,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColorsLight.mainColorLight,
                              AppColorsLight.mainColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColorsLight.mainColor.applyOpacity(0.28),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      Positioned(
                        right: 16.r,
                        bottom: 18.r,
                        child: Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF27272A) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.applyOpacity(0.10),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColorsLight.mainColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.descrption,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: bodyColor,
                    height: 1.45,
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

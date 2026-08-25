import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class InspectionManagement extends StatelessWidget {
  const InspectionManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_InspectionOption> options = <_InspectionOption>[
      //
      // driver inspection — unchanged destination (no arguments)
      _InspectionOption(
        title: 'Driver Inspection',
        description: 'Review and manage driver inspections.',
        semanticLabel: 'Open Driver Inspection',
        icon: Icons.person_search_rounded,
        onTap: () {
          Get.toNamed(Routes.DRIVER_INSPECTION);
        },
      ),

      //
      // truck inspection — unchanged destination + "truck" argument
      _InspectionOption(
        title: 'Truck Inspection',
        description: 'Review and manage truck inspections.',
        semanticLabel: 'Open Truck Inspection',
        icon: Icons.local_shipping_rounded,
        onTap: () {
          Get.toNamed(
            Routes.TRUCK_TRAILER_INSPECTION,
            arguments: "truck",
          );
        },
      ),

      //
      // trailer inspection — unchanged destination + "trailer" argument
      _InspectionOption(
        title: 'Trailer Inspection',
        description: 'Review and manage trailer inspections.',
        semanticLabel: 'Open Trailer Inspection',
        icon: Icons.rv_hookup_rounded,
        onTap: () {
          Get.toNamed(
            Routes.TRUCK_TRAILER_INSPECTION,
            arguments: "trailer",
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          //
          // header
          const _Header(),

          //
          // body
          Expanded(
            child: SafeArea(
              top: false,
              child: _BodyReveal(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // intro line
                      const _IntroLine(),
                      const SizedBox(height: 16),

                      //
                      // responsive options (1 col on phones, 2–3 on wide)
                      _OptionsLayout(options: options),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Brand-gradient header matching the rest of the app (AppRedHeader with a
/// frosted back button and a bold white title).
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          //
          // back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          //
          // heading
          Expanded(
            child: Text(
              'Inspection Management',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact one-line hint beneath the header.
class _IntroLine extends StatelessWidget {
  const _IntroLine();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      'Choose an inspection type to continue.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: context.secondaryTextColor,
      ),
    );
  }
}

/// Lays the inspection cards out responsively: a single full-width column on
/// phones, and an equal-width 2- or 3-column grid on wider layouts. Uses a
/// [Wrap] (not a nested scroll view) so it composes inside the page scroll.
class _OptionsLayout extends StatelessWidget {
  const _OptionsLayout({required this.options});

  final List<_InspectionOption> options;

  static const double _gap = 14;

  int _columnsFor(double width) {
    if (width >= 1000) return 3;
    if (width >= 640) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = _columnsFor(constraints.maxWidth);
        final double totalGap = _gap * (columns - 1);
        final double itemWidth = (constraints.maxWidth - totalGap) / columns;

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final _InspectionOption option in options)
              SizedBox(
                width: itemWidth,
                child: InspectionTypeCard(
                  key: ValueKey(option.title),
                  title: option.title,
                  description: option.description,
                  semanticLabel: option.semanticLabel,
                  icon: option.icon,
                  onTap: option.onTap,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _InspectionOption {
  const _InspectionOption({
    required this.title,
    required this.description,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final String semanticLabel;
  final IconData icon;
  final VoidCallback onTap;
}

class InspectionTypeCard extends StatefulWidget {
  const InspectionTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final String semanticLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<InspectionTypeCard> createState() => _InspectionTypeCardState();
}

class _InspectionTypeCardState extends State<InspectionTypeCard> {
  bool _locked = false;

  /// Runs the tap callback, then ignores further taps briefly so a rapid
  /// double tap can't push the same route twice.
  void _handleTap() {
    if (_locked) return;
    _locked = true;
    widget.onTap();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    const BorderRadius radius = BorderRadius.all(Radius.circular(18));

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      onTap: _handleTap,
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: radius,
            border: Border.all(color: context.hairlineBorderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    //
                    // icon container
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.brandColor.applyOpacity(0.10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 26,
                        color: context.brandColor,
                      ),
                    ),

                    const SizedBox(width: 14),

                    //
                    // title + supporting text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: context.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    //
                    // navigation chevron (mirrors in RTL)
                    Icon(
                      isRtl
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      size: 24,
                      color: context.secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
/// Skipped entirely when the platform requests reduced motion.
class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

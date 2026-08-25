import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/glass_panel.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/views/message_notifications_view.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_hero_primitives.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_quick_start_button.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_shift_timer.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_stats_strip.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_timesheet_dialog.dart';

/// Collapsing hero for the Driver Dashboard: profile, shift status, work timer
/// and start/end CTA, shrinking to a pinned bar as the page scrolls.
///
/// The timer is never crossfaded — one widget shrinks and travels into the bar,
/// which is what makes the collapse read as a single motion.
///
/// Pair with `HeroSnapScrollPhysics` and a trailing `DashboardCollapseSpacer`
/// (`dashboard_scroll.dart`), or the collapse can rest or stall halfway.
class DashboardHeroSliver extends StatelessWidget {
  const DashboardHeroSliver({super.key, required this.topInset});

  /// Status-bar height so the content clears the notch.
  final double topInset;

  /// Scroll distance between fully expanded and fully collapsed. The status-bar
  /// inset is in both extents, so it cancels out.
  static const double collapseTravel =
      _Metrics.expandedBody - _Metrics.collapsedBody;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      // The delegate reads theme-derived colours outside any Obx, so the
      // brightness has to be a field — otherwise shouldRebuild says "no" on a
      // theme toggle and the bar keeps the old gradient until the next scroll.
      delegate: _HeroHeaderDelegate(
        topInset: topInset,
        isDark: Get.isDarkMode,
      ),
    );
  }
}

/// Vertical rhythm of the expanded hero, measured from the layout below the
/// status bar. Kept as named constants because every flying element positions
/// itself against them.
abstract class _Metrics {
  static const double sidePad = 20;
  static const double topPad = 14;

  /// Avatar outer box: image 48 + ring padding 2.5 + border 2, each side.
  static const double avatarH = 57;

  /// Gap between the avatar and whatever sits to its right.
  static const double avatarGap = 14;

  /// The profile row is as tall as its tallest child, which is the greeting +
  /// name + role-badge stack (~63), NOT the avatar.
  static const double profileRowH = 64;

  static const double gapAfterProfile = 22;
  static const double panelPad = 16;
  static const double pillH = 26;
  static const double gapAfterPill = 14;
  static const double timerDigitsH = ShiftTimer.digitsHeight;
  static const double timerGroupH = 55; // digits + unit labels
  static const double bottomPad = 22;

  static const double panelH =
      panelPad + pillH + gapAfterPill + timerGroupH + panelPad; // 127

  static const double gapAfterPanel = 18;

  static const double statsH = DashboardStatsStrip.height;

  /// 14 + 64 + 22 + 127 + 18 + 92 + 22
  static const double expandedBody = topPad +
      profileRowH +
      gapAfterProfile +
      panelH +
      gapAfterPanel +
      statsH +
      bottomPad;

  static const double collapsedBody = 56;

  // Offsets below the status bar, expanded state.
  static const double panelTop = topPad + profileRowH + gapAfterProfile; // 100
  static const double statsTop = panelTop + panelH + gapAfterPanel; // 245
  static const double timerTop = panelTop + panelPad + pillH + gapAfterPill;
  static const double ctaH = 44;
  static const double ctaTop = panelTop + panelH - panelPad - 13 - ctaH;
  static const double bellH = 42;
  static const double bellTop = topPad + (profileRowH - bellH) / 2;
  static const double avatarTop = topPad + (profileRowH - avatarH) / 2;

  /// Vertical centre of the profile row — the identity block hangs off this.
  static const double profileRowCenter = topPad + profileRowH / 2;

  /// Where the identity block starts, expanded.
  static const double identityLeft = sidePad + avatarH + avatarGap;

  // Collapsed state.
  static const double collapsedTimerScale = 0.45;
  static const double barCenter = collapsedBody / 2;
  static const double ctaCollapsedH = 36;
  static const double ctaCollapsedTop = barCenter - ctaCollapsedH / 2;
  static const double ctaCollapsedW = 80;
  static const double ctaExpandedW = 96;
  static const double bellCollapsedH = 36;
  static const double bellCollapsedTop = barCenter - bellCollapsedH / 2;
  static const double avatarCollapsedH = 36;
  static const double avatarCollapsedTop = barCenter - avatarCollapsedH / 2;
  static const double collapsedPad = 16;

  /// Where the chip (dot + timer) starts once collapsed.
  static const double chipLeft = collapsedPad + avatarCollapsedH + 10; // 62
  static const double dotSize = 6;
  static const double timerCollapsedLeft = chipLeft + dotSize + 7; // 75
  static const double timerCollapsedTop =
      barCenter - (timerDigitsH * collapsedTimerScale) / 2;

  /// The bell keeps the outer edge in both states and the CTA settles inboard
  /// of it. Swapping their order would force their travel paths to cross.
  static const double bellCollapsedRight = collapsedPad;
  static const double ctaCollapsedRight =
      collapsedPad + bellCollapsedH + 12; // 64

  /// Minimum touch target.
  static const double tap = 44;
}

class _HeroHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeroHeaderDelegate({required this.topInset, required this.isDark});

  final double topInset;
  final bool isDark;

  @override
  double get maxExtent => topInset + _Metrics.expandedBody;

  @override
  double get minExtent => topInset + _Metrics.collapsedBody;

  @override
  bool shouldRebuild(covariant _HeroHeaderDelegate oldDelegate) =>
      oldDelegate.topInset != topInset || oldDelegate.isDark != isDark;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // shrinkOffset is clamped by the framework to [0, maxExtent] — which is a
    // wider range than the collapse travel, hence the second clamp.
    final double range = math.max(maxExtent - minExtent, 1.0);
    final double t = (shrinkOffset / range).clamp(0.0, 1.0);

    // Exits run bottom-up: each element must be fully faded BEFORE the
    // shrinking bottom edge reaches it, or it gets clipped mid-transition.
    // The edge sits at (expandedBody - t*travel), so the deeper an element is,
    // the earlier its window has to close.
    final double statsOut = _out(t, 0.0, 0.20); // deepest — goes first
    final double calendarIn = 1 - _out(t, 0.06, 0.26);
    final double greetingIn = 1 - _out(t, 0.10, 0.34);
    final double panelIn = 1 - _out(t, 0.05, 0.38);
    final double unitsIn = 1 - _out(t, 0.15, 0.34);
    final double nameIn = 1 - _out(t, 0.28, 0.50);
    final double pillIn = 1 - _out(t, 0.28, 0.46);
    final double dotIn = _in(t, 0.46, 0.72);
    final double shadowIn = _in(t, 0.86, 1.0);

    // The timer, the status dot and the CTA leave the panel as one group —
    // they start early enough to clear the edge without an artificial rise.
    final double travelT = _out(t, 0.30, 0.85);
    final double bellT = _out(t, 0.50, 1.0);
    // The CTA clears the bell's column before it rises past it.
    final double ctaX = _out(t, 0.0, 0.28);

    final double avatarH =
        lerpDouble(_Metrics.avatarH, _Metrics.avatarCollapsedH, t)!;
    final double ctaH =
        lerpDouble(_Metrics.ctaH, _Metrics.ctaCollapsedH, travelT)!;
    final double bellH =
        lerpDouble(_Metrics.bellH, _Metrics.bellCollapsedH, bellT)!;

    final Radius bottomRadius =
        Radius.circular(lerpDouble(34, 18, _out(t, 0.30, 1.0))!);

    // The drop shadow must live OUTSIDE the ClipRRect — painted inside, the
    // clip discards it entirely and the collapsed bar never separates from
    // the content scrolling underneath. Text scaling is clamped because the
    // hero is absolutely positioned: unbounded scale slides the timer under
    // the CTA instead of wrapping.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: bottomRadius),
          boxShadow: shadowIn <= 0.01 ? null : _heroBarShadow(isDark, shadowIn),
        ),
        child: ClipRRect(
          // RenderSliverPersistentHeader does not clip its child — we must.
          borderRadius: BorderRadius.vertical(bottom: bottomRadius),
          child: Stack(
            // The ClipRRect above already clips this exact rect.
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                  child: _HeroBackground(isDark: isDark, borderT: shadowIn)),

              // ── Glass panel behind the shift block (dies with the block) ──────
              if (panelIn > 0.01)
                Positioned(
                  key: const ValueKey('hero-panel'),
                  left: _Metrics.sidePad,
                  right: _Metrics.sidePad,
                  top: topInset + _Metrics.panelTop,
                  height: _Metrics.panelH,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: panelIn,
                      child: const GlassPanel(radius: 18, blur: 14),
                    ),
                  ),
                ),

              // ── Shift pill ───────────────────────────────────────────────────
              if (pillIn > 0.01)
                Positioned(
                  key: const ValueKey('hero-pill'),
                  left: _Metrics.sidePad + _Metrics.panelPad,
                  top: topInset + _Metrics.panelTop + _Metrics.panelPad,
                  height: _Metrics.pillH,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: pillIn,
                      child: Obx(
                          () => _StatusPill(active: controller.isClockedIn)),
                    ),
                  ),
                ),

              // ── Stats tiles — deepest in the hero, so first to leave ─────────
              if (statsOut < 0.99)
                Positioned(
                  key: const ValueKey('hero-stats'),
                  left: _Metrics.sidePad,
                  right: _Metrics.sidePad,
                  top: topInset + _Metrics.statsTop - 40 * statsOut,
                  height: _Metrics.statsH,
                  child: IgnorePointer(
                    ignoring: statsOut > 0.1,
                    child: Opacity(
                      opacity: 1 - statsOut,
                      child: const DashboardStatsStrip(),
                    ),
                  ),
                ),

              // ── Greeting + name + role badge ─────────────────────────────────
              // No fixed height — the block grows with the text scale and hangs
              // off the row's centre. A fixed box overflows instead.
              if (greetingIn > 0.01 || nameIn > 0.01)
                Positioned(
                  key: const ValueKey('hero-identity'),
                  left: lerpDouble(_Metrics.identityLeft, 60, t)!,
                  right: 128,
                  top: topInset + _Metrics.profileRowCenter,
                  child: IgnorePointer(
                    child: FractionalTranslation(
                      translation: const Offset(0, -0.5),
                      child: _IdentityBlock(
                        greetingOpacity: greetingIn,
                        nameOpacity: nameIn,
                      ),
                    ),
                  ),
                ),

              // ── Timesheet shortcut (its job is taken over by the stats row) ──
              if (calendarIn > 0.01)
                Positioned(
                  key: const ValueKey('hero-calendar'),
                  right: _Metrics.sidePad + _Metrics.bellH + 10,
                  top: topInset + _Metrics.bellTop,
                  height: _Metrics.bellH,
                  width: _Metrics.bellH,
                  child: IgnorePointer(
                    ignoring: calendarIn < 0.9,
                    child: Opacity(
                      opacity: calendarIn,
                      child: Transform.scale(
                        scale: lerpDouble(1.0, 0.85, 1 - calendarIn)!,
                        child: _HeroIconButton(
                          icon: Icons.calendar_month_rounded,
                          size: _Metrics.bellH,
                          iconSize: 20,
                          onTap: () => showTimesheetDialog(controller),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Anchor 1: the avatar. Shrinks, never fades. ──────────────────
              _tapAligned(
                key: const ValueKey('hero-avatar'),
                left: lerpDouble(_Metrics.sidePad, _Metrics.collapsedPad, t)!,
                top: topInset +
                    lerpDouble(
                        _Metrics.avatarTop, _Metrics.avatarCollapsedTop, t)!,
                height: avatarH,
                child: _HeroAvatar(size: avatarH),
              ),

              // ── Collapsed status dot, handed off from the pill ───────────────
              if (dotIn > 0.01)
                Positioned(
                  key: const ValueKey('hero-dot'),
                  // Timer's curve, so the dot arrives with the digits.
                  left: lerpDouble(
                    _Metrics.identityLeft,
                    _Metrics.chipLeft,
                    travelT,
                  )!,
                  top: topInset + _Metrics.barCenter - _Metrics.dotSize / 2,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: dotIn,
                      child: Obx(
                        () => PulseDot(
                          color: controller.isClockedIn
                              ? AppColorsLight.onHeroOnline
                              : AppColorsLight.onHeroTextMuted,
                          active: controller.isClockedIn,
                          size: _Metrics.dotSize,
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Anchor 2: the timer. Scales and travels into the bar. ────────
              Positioned(
                key: const ValueKey('hero-timer'),
                left: lerpDouble(
                  _Metrics.sidePad + _Metrics.panelPad,
                  _Metrics.timerCollapsedLeft,
                  travelT,
                )!,
                // Bounded on the right so large text scales shrink to fit instead
                // of sliding under the CTA.
                right: lerpDouble(140, 152, travelT)!,
                top: topInset +
                    lerpDouble(
                      _Metrics.timerTop,
                      _Metrics.timerCollapsedTop,
                      travelT,
                    )!,
                child: IgnorePointer(
                  child: Transform.scale(
                    // Paint-time scale, not a font-size lerp — no relayout.
                    scale:
                        lerpDouble(1.0, _Metrics.collapsedTimerScale, travelT)!,
                    alignment: Alignment.topLeft,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: ShiftTimer(unitsOpacity: unitsIn),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Notification bell ────────────────────────────────────────────
              _tapAligned(
                key: const ValueKey('hero-bell'),
                right: lerpDouble(
                  _Metrics.sidePad,
                  _Metrics.bellCollapsedRight,
                  bellT,
                )!,
                top: topInset +
                    lerpDouble(
                        _Metrics.bellTop, _Metrics.bellCollapsedTop, bellT)!,
                height: bellH,
                child: _NotificationBell(size: bellH),
              ),

              // ── The start / end CTA — reachable in both states ───────────────
              _tapAligned(
                key: const ValueKey('hero-cta'),
                right: lerpDouble(
                  _Metrics.sidePad + _Metrics.panelPad,
                  _Metrics.ctaCollapsedRight,
                  ctaX,
                )!,
                top: topInset +
                    lerpDouble(
                      _Metrics.ctaTop,
                      _Metrics.ctaCollapsedTop,
                      travelT,
                    )!,
                height: ctaH,
                child: QuickStartButton(
                  height: ctaH,
                  width: lerpDouble(
                    _Metrics.ctaExpandedW,
                    _Metrics.ctaCollapsedW,
                    travelT,
                  )!,
                  glow: 1 - _out(t, 0.0, 0.30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ClockInOutController get controller => Get.find<ClockInOutController>();

  /// Positions [child] at its visual size while guaranteeing a 44pt tap band.
  Widget _tapAligned({
    Key? key,
    double? left,
    double? right,
    required double top,
    required double height,
    required Widget child,
  }) {
    final double band = math.max(height, _Metrics.tap);
    return Positioned(
      key: key,
      left: left,
      right: right,
      top: top - (band - height) / 2,
      height: band,
      // widthFactor keeps the tap band hugging the child — a bare Center would
      // stretch to the full row and swallow its neighbours' taps.
      child: Align(widthFactor: 1, child: child),
    );
  }
}

/// Eased exit: 0 while `t < begin`, 1 once `t >= end`.
double _out(double t, double begin, double end) => Curves.easeOutCubic
    .transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

/// Eased entrance — arrives late so it never looks premature.
double _in(double t, double begin, double end) =>
    Curves.easeIn.transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

/// Shadow under the collapsed bar, faded in once content scrolls beneath it.
/// [t] is the collapse progress (0 expanded, 1 collapsed).
List<BoxShadow> _heroBarShadow(bool isDark, double t) => [
      BoxShadow(
        color: Colors.black.applyOpacity((isDark ? 0.42 : 0.16) * t),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ];

/// Dark mode needs a hairline as well — a black shadow is invisible against
/// the near-black hero gradient.
Color? _heroBarBorder(bool isDark, double t) =>
    isDark ? Colors.white.applyOpacity(0.10 * t) : null;

/// The brand gradient, plus the hairline that separates the collapsed bar from
/// the content sliding under it. The bar's drop shadow is NOT here — it has to
/// be painted outside the header's ClipRRect or the clip discards it.
class _HeroBackground extends StatelessWidget {
  const _HeroBackground({required this.isDark, required this.borderT});

  final bool isDark;

  /// Collapse progress the hairline fades in on (0 expanded, 1 collapsed).
  final double borderT;

  @override
  Widget build(BuildContext context) {
    final Color? border = _heroBarBorder(isDark, borderT);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppRedHeader.gradient,
        border:
            border == null ? null : Border(bottom: BorderSide(color: border)),
      ),
    );
  }
}

class _HeroAvatar extends GetView<ClockInOutController> {
  const _HeroAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    // Ring + padding + border consume a fixed 9pt of the outer box.
    final double image = math.max(size - 9, 12.0);

    return Obx(() {
      final clockedIn = controller.isClockedIn;
      return GestureDetector(
        onTap: () => showImageDialog(
          context,
          controller.authController.user.value?.image ?? "",
        ),
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: clockedIn
                  ? AppColorsLight.onHeroOnline
                  : Colors.white.applyOpacity(0.4),
              width: 2,
            ),
            boxShadow: clockedIn
                ? [
                    BoxShadow(
                      color: AppColorsLight.onHeroOnline.applyOpacity(0.5),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: ProfileImage.network(
            url: controller.authController.user.value?.image,
            width: image,
            height: image,
            showLetterOnError: true,
            letter: controller.authController.user.value?.firstName?[0]
                .toUpperCase(),
          ),
        ),
      );
    });
  }
}

/// Greeting, name and role badge — the part of the identity that scrolls away.
class _IdentityBlock extends GetView<ClockInOutController> {
  const _IdentityBlock({
    required this.greetingOpacity,
    required this.nameOpacity,
  });

  final double greetingOpacity;
  final double nameOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: greetingOpacity,
            child: Transform.translate(
              offset: Offset(0, -6 * (1 - greetingOpacity)),
              child: Text(
                _greeting(),
                maxLines: 1,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColorsLight.onHeroTextSecondary,
                  fontSize: 11.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Opacity(
            opacity: nameOpacity,
            child: Transform.translate(
              offset: Offset(0, -6 * (1 - nameOpacity)),
              child: Text(
                controller.authController.user.value?.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Opacity(
            opacity: greetingOpacity,
            child: _RoleBadge(
              label: controller.authController.user.value?.designation?.name ??
                  "Driver",
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColorsLight.mainColor.applyOpacity(0.18)
            : AppColorsLight.white.applyOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColorsLight.mainColor.applyOpacity(0.35)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _NotificationBell extends GetView<ClockInOutController> {
  const _NotificationBell({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.authController.userPermissionHelper
          .canViewMessageNotifications()) {
        return const SizedBox.shrink();
      }

      final total =
          controller.messagesNotifyController.currentPagination.value?.total ??
              0;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          _HeroIconButton(
            icon: Icons.notifications_rounded,
            size: size,
            iconSize: size * 0.48,
            onTap: () async {
              try {
                await Get.to(() => const MessageNotificationsView());
                controller.messagesNotifyController.currentPagination.refresh();
              } catch (_) {}
            },
          ),
          if (total > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColorsLight.mainColorLight,
                      AppColorsLight.mainColorDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xFF1B1012),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  total > 99 ? "99+" : "$total",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppColorsLight.onHeroOnline : AppColorsLight.onHeroTextMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.applyOpacity(0.14),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.applyOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseDot(color: color, active: active),
          const SizedBox(width: 7),
          Text(
            active ? "On shift" : "Off shift",
            style: TextStyle(
              color: active ? Colors.white : AppColorsLight.onHeroTextSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Frosted icon button — the hero's glass treatment at a tappable size.
class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 13,
      blur: 10,
      onTap: onTap,
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

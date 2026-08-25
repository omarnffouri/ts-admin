import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_hero_card.dart';

/// Snaps the hero fully open or fully collapsed: a release that would settle
/// inside the collapse travel springs to the nearest end instead.
///
/// Extends [BouncingScrollPhysics] rather than wrapping it so SmartRefresher's
/// `physics is BouncingScrollPhysics` check still holds.
class HeroSnapScrollPhysics extends BouncingScrollPhysics {
  const HeroSnapScrollPhysics({super.parent});

  /// Scroll distance of the collapse — the header's own travel is the only
  /// value that puts the snap targets on the header's ends.
  static const double travel = DashboardHeroSliver.collapseTravel;

  @override
  HeroSnapScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      HeroSnapScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final double pixels = position.pixels;

    // Overscrolled (pull-to-refresh drop, bottom bounce): default physics.
    if (pixels < position.minScrollExtent ||
        pixels > position.maxScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = toleranceFor(position);

    // Natural resting point of this release — 0.135 is the drag friction
    // constant BouncingScrollSimulation itself uses.
    final double rest = velocity.abs() < tolerance.velocity
        ? pixels
        : FrictionSimulation(0.135, pixels, velocity).finalX;

    if (rest > 0 && rest < travel) {
      final double target = (rest > travel / 2 ? travel : 0.0)
          .clamp(0.0, position.maxScrollExtent);
      if ((target - pixels).abs() < tolerance.distance) return null;
      return ScrollSpringSimulation(
        spring,
        pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return super.createBallisticSimulation(position, velocity);
  }
}

/// Trailing filler so a short body can still scroll far enough to finish the
/// collapse — a `CustomScrollView` only scrolls by `content - viewport`.
///
/// Must be the LAST sliver so `precedingScrollExtent` covers everything above.
class DashboardCollapseSpacer extends StatelessWidget {
  const DashboardCollapseSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final double needed = constraints.viewportMainAxisExtent +
            DashboardHeroSliver.collapseTravel;
        final double extra =
            math.max(0.0, needed - constraints.precedingScrollExtent);
        return SliverToBoxAdapter(child: SizedBox(height: extra));
      },
    );
  }
}

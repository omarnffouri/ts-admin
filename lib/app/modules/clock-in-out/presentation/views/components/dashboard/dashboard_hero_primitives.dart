import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Shimmer palette for on-hero skeletons — white-based, because these sit on
/// the red hero gradient rather than the feed canvas. Pass to `SkeletonBones`.
const Color heroBoneBase = Color(0x29FFFFFF); // white 16%
const Color heroBoneHighlight = Color(0x61FFFFFF); // white 38%

/// A softly pulsing status dot (animates only when [active]).
class PulseDot extends StatefulWidget {
  const PulseDot({
    super.key,
    required this.color,
    required this.active,
    this.size = 8,
  });

  final Color color;
  final bool active;
  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant PulseDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _syncTicker();
  }

  /// A running ticker schedules a frame every vsync, so leaving it repeating
  /// while the dot renders static would stop the screen ever going idle.
  void _syncTicker() {
    final bool shouldRun =
        widget.active && !MediaQuery.disableAnimationsOf(context);
    if (shouldRun == _c.isAnimating) return;
    shouldRun ? _c.repeat(reverse: true) : _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: widget.color.applyOpacity(0.7), blurRadius: 6),
        ],
      ),
    );
    if (!widget.active || MediaQuery.disableAnimationsOf(context)) return dot;
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_c),
      child: dot,
    );
  }
}

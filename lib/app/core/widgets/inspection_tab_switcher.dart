import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Reusable segmented control with an animated brand-colored indicator.
///
/// Purely presentational: the caller owns the selected index and the change
/// callback, so a page's existing tab-selection logic is preserved. Works for
/// any number of segments and reads well at large text sizes and in RTL.
///
/// Shared across the inspection pages (driver, truck, trailer).
class InspectionTabSwitcher extends StatelessWidget {
  const InspectionTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceColor.applyOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Stack(
        children: [
          //
          // sliding selection indicator
          Positioned.fill(
            child: AnimatedAlign(
              alignment: _alignmentFor(selectedIndex),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 1 / labels.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.tabButton,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: context.tabButton.applyOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //
          // segments
          Row(
            children: [
              for (int i = 0; i < labels.length; i++)
                Expanded(
                  child: _Segment(
                    label: labels[i],
                    selected: selectedIndex == i,
                    reduceMotion: reduceMotion,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Distributes the indicator evenly across the track, resolving to the
  /// leading edge for the first segment and the trailing edge for the last.
  AlignmentGeometry _alignmentFor(int index) {
    if (labels.length <= 1) return AlignmentDirectional.center;
    final double t = index / (labels.length - 1); // 0..1
    return AlignmentDirectional(-1 + 2 * t, 0);
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.reduceMotion,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '$label tab, selected' : '$label tab',
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: AnimatedDefaultTextStyle(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                style:
                    (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
                  color: selected ? Colors.white : context.secondaryTextColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

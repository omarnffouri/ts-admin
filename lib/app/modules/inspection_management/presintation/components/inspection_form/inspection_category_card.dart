import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'inspection_completion_counter.dart';

class InspectionCategoryCard extends StatelessWidget {
  const InspectionCategoryCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.isSelectedAll,
    required this.tileController,
    required this.onExpansionChanged,
    required this.onSelectAllChanged,
    required this.children,
  });

  final String title;
  final int completed;
  final int total;
  final bool isSelectedAll;
  final ExpansibleController tileController;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<bool> onSelectAllChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(18),
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
      child: ExpansionTile(
        controller: tileController,
        initiallyExpanded: false,
        onExpansionChanged: onExpansionChanged,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: context.secondaryTextColor,
        collapsedIconColor: context.secondaryTextColor,
        // Honour the platform "reduce motion" setting.
        expansionAnimationStyle:
            reduceMotion ? AnimationStyle.noAnimation : null,
        title: _CategoryHeader(
          title: title,
          completed: completed,
          total: total,
          isSelectedAll: isSelectedAll,
          onSelectAllChanged: onSelectAllChanged,
        ),
        children: [
          Divider(height: 1, color: context.hairlineBorderColor),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

/// Collapsed card content. The category title is the primary element; the
/// progress badge and Select All move to a second row when the row is narrow
/// or text is scaled up, so they never collide with the title.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.title,
    required this.completed,
    required this.total,
    required this.isSelectedAll,
    required this.onSelectAllChanged,
  });

  final String title;
  final int completed;
  final int total;
  final bool isSelectedAll;
  final ValueChanged<bool> onSelectAllChanged;

  static const double _minSingleRowWidth = 230;
  static const double _maxSingleRowTextScale = 1.2;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    final Widget titleText = Semantics(
      label: '$title, $completed of $total selected',
      excludeSemantics: true,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.primaryTextColor,
        ),
      ),
    );

    final Widget badge = InspectionCountBadge(
      completed: completed,
      total: total,
    );

    final Widget selectAll = _SelectAllControl(
      completed: completed,
      total: total,
      isSelectedAll: isSelectedAll,
      onChanged: onSelectAllChanged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool singleRow = constraints.maxWidth >= _minSingleRowWidth &&
            textScale <= _maxSingleRowTextScale;

        if (singleRow) {
          return Row(
            children: [
              Expanded(child: titleText),
              const SizedBox(width: 10),
              badge,
              const SizedBox(width: 4),
              selectAll,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            titleText,
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [badge, selectAll],
            ),
          ],
        );
      },
    );
  }
}

/// Select All as a single tappable label + box. Reports `!isSelectedAll`,
/// exactly like the checkbox it replaces, and shows an indeterminate box when
/// only part of the category is selected (a visual state only — the underlying
/// flag is still the existing boolean).
class _SelectAllControl extends StatelessWidget {
  const _SelectAllControl({
    required this.completed,
    required this.total,
    required this.isSelectedAll,
    required this.onChanged,
  });

  final int completed;
  final int total;
  final bool isSelectedAll;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isPartial = !isSelectedAll && completed > 0 && completed < total;

    return Semantics(
      button: true,
      checked: isSelectedAll,
      mixed: isPartial,
      label: 'Select all, $completed of $total selected',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!isSelectedAll),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Select All',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _SelectionBox(
                  isSelected: isSelectedAll,
                  isPartial: isPartial,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Checkbox-shaped indicator with checked / indeterminate / empty states.
class _SelectionBox extends StatelessWidget {
  const _SelectionBox({required this.isSelected, required this.isPartial});

  final bool isSelected;
  final bool isPartial;

  @override
  Widget build(BuildContext context) {
    final bool filled = isSelected || isPartial;

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? context.brandColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: filled ? context.brandColor : context.panelBorderColor,
          width: 1.4,
        ),
      ),
      child: filled
          ? Icon(
              isSelected ? Icons.check_rounded : Icons.remove_rounded,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }
}

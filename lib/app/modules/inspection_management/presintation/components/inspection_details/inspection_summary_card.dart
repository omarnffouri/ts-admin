import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/inspection_request_widgets.dart';

import '../inspection_type_visuals.dart';

class InspectionSummaryHeader extends StatelessWidget {
  const InspectionSummaryHeader({
    super.key,
    required this.number,
    required this.type,
    required this.isSatisfactory,
  });

  final String number;
  final String type;
  final bool isSatisfactory;

  static const String _fallback = 'N/A';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String trimmedNumber = number.trim();
    final String label = trimmedNumber.isEmpty ? _fallback : '#$trimmedNumber';
    final String typeLabel = InspectionTypeVisuals.subjectLabel(type);

    return Semantics(
      container: true,
      label: 'Inspection $label, $typeLabel, result '
          '${InspectionResultBadge.labelFor(isSatisfactory)}',
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // type icon
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.brandColor.applyOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                InspectionTypeVisuals.subjectIcon(type),
                size: 24,
                color: context.brandColor,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'INSPECTION',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      InspectionStatusBadge(status: typeLabel),
                      InspectionResultBadge(isSatisfactory: isSatisfactory),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overall-result badge. Always pairs the semantic color with an icon and a
/// word, so the result never depends on color alone.
class InspectionResultBadge extends StatelessWidget {
  const InspectionResultBadge({super.key, required this.isSatisfactory});

  final bool isSatisfactory;

  static String labelFor(bool isSatisfactory) =>
      isSatisfactory ? 'Satisfactory' : 'Unsatisfactory';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color =
        isSatisfactory ? context.successColor : context.dangerColor;
    final String label = labelFor(isSatisfactory);

    return Semantics(
      label: 'Result, $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.applyOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.applyOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSatisfactory
                  ? Icons.verified_rounded
                  : Icons.report_problem_rounded,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../inspection_type_visuals.dart';

class InspectionSubjectCard extends StatelessWidget {
  const InspectionSubjectCard({
    super.key,
    required this.type,
    required this.subject,
    this.reference,
  });

  /// Existing inspection type argument: "driver" / "truck" / "trailer".
  final String type;

  /// The inspected entity as passed in the route arguments (driver name for
  /// driver inspections, unit identifier for truck / trailer inspections).
  final String subject;

  /// Existing request id, shown only when it adds information.
  final String? reference;

  static const String _fallback = 'N/A';

  static String? _clean(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
    return trimmed;
  }

  /// Up to two initials, letters only — falls back to the type icon when the
  /// subject has none (e.g. a numeric unit number).
  static String? _initials(String value) {
    final Iterable<String> words = value
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .take(2);

    final String initials = words
        .map((String word) => word.characters.first)
        .where((String letter) => RegExp(r'[A-Za-z]').hasMatch(letter))
        .join()
        .toUpperCase();

    return initials.isEmpty ? null : initials;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;

    final String? cleanedSubject = _clean(subject);
    final String title = cleanedSubject ?? _fallback;
    final String label = InspectionTypeVisuals.subjectLabel(type);

    final String? cleanedReference = _clean(reference);
    final bool showReference =
        cleanedReference != null && cleanedReference != cleanedSubject;

    final String? initials =
        cleanedSubject != null && InspectionTypeVisuals.showsInitials(type)
            ? _initials(cleanedSubject)
            : null;

    return Semantics(
      container: true,
      label: showReference
          ? '$label, $title, request number $cleanedReference'
          : '$label, $title',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            // avatar — driver initials when available, otherwise the type icon
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.brandColor.applyOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: initials == null
                  ? Icon(
                      InspectionTypeVisuals.subjectIcon(type),
                      size: 24,
                      color: context.brandColor,
                    )
                  : Text(
                      initials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.brandColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //
                  // type caption
                  Text(
                    label.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 2),

                  //
                  // inspected entity
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.primaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  //
                  // request number (only when it adds information)
                  if (showReference) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 14,
                          color: context.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Request #$cleanedReference',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

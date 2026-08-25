import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/clipboard_helper.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import '../../../../domain/entities/truck_entity.dart';

/// Single truck row. Every truck in the directory renders through this
/// same widget so the layout stays identical across the list. Height is
/// intentionally unconstrained so long names/identifiers can wrap.
class TruckCard extends StatelessWidget {
  const TruckCard({
    super.key,
    required this.truck,
    this.onTap,
    this.onEdit,
    this.onNotesTap,
  });

  final TruckEntity truck;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onNotesTap;

  static const double _radius = 18;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String name = truck.lessorName?.trim() ?? '';
    final String? licencePlate = truck.licencePlateNumber?.trim();
    final String? vin = truck.vin?.trim();
    final int? identifier = truck.identifier;
    final int? id = truck.id;
    final bool hasNotes = truck.truckNotes?.isNotEmpty ?? false;

    final bool hasLicencePlate =
        licencePlate != null && licencePlate.isNotEmpty;
    final bool hasVin = vin != null && vin.isNotEmpty;
    final bool hasIdentifier = identifier != null;
    final bool hasId = id != null;
    final bool hasAnyMetadata =
        hasLicencePlate || hasVin || hasIdentifier || hasId;

    return Slidable(
      key: ValueKey(id ?? name.hashCode),
      closeOnScroll: true,
      groupTag: 'truck_listing_slide_group',
      endActionPane: onEdit == null
          ? null
          : ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.28,
              children: [
                SlidableAction(
                  onPressed: (_) => onEdit?.call(),
                  backgroundColor: context.primaryTextColor,
                  foregroundColor: context.backgroundColor,
                  icon: Icons.edit_outlined,
                  label: 'Edit'.tr,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(_radius),
                    bottomRight: Radius.circular(_radius),
                  ),
                  padding: const EdgeInsets.all(2),
                ),
              ],
            ),
      child: Semantics(
        button: true,
        label: name.isEmpty
            ? 'View truck details'.tr
            : '${'View details for'.tr} $name',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_radius),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.tileColor,
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: context.isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.applyOpacity(0.045),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TruckAvatar(name: name),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Unnamed Truck'.tr : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: context.primaryTextColor,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TruckStatusBadge(status: truck.status),
                    ],
                  ),
                  if (hasAnyMetadata) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: context.hairlineBorderColor),
                    const SizedBox(height: 10),
                  ],
                  if (hasLicencePlate)
                    TruckMetadataRow(
                      icon: Icons.pin_outlined,
                      value: licencePlate,
                      semanticLabel: 'License plate'.tr,
                      copyMessage: 'License plate copied successfully.'.tr,
                    ),
                  if (hasVin)
                    Padding(
                      padding: EdgeInsets.only(top: hasLicencePlate ? 6 : 0),
                      child: TruckMetadataRow(
                        icon: Icons.confirmation_number_outlined,
                        value: vin,
                        semanticLabel: 'VIN'.tr,
                        copyMessage: 'VIN copied successfully.'.tr,
                      ),
                    ),
                  if (hasIdentifier)
                    Padding(
                      padding: EdgeInsets.only(
                        top: hasLicencePlate || hasVin ? 6 : 0,
                      ),
                      child: TruckMetadataRow(
                        icon: Icons.tag_rounded,
                        value: '$identifier',
                        semanticLabel: 'Identifier'.tr,
                        copyMessage: 'Identifier copied successfully.'.tr,
                      ),
                    ),
                  if (hasId)
                    Padding(
                      padding: EdgeInsets.only(
                        top: hasLicencePlate || hasVin || hasIdentifier ? 6 : 0,
                      ),
                      child: TruckMetadataRow(
                        icon: Icons.badge_outlined,
                        value: '$id',
                        semanticLabel: 'ID'.tr,
                        copyMessage: 'ID copied successfully.'.tr,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (hasNotes && onNotesTap != null)
                        _TruckNotesButton(onTap: onNotesTap!),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: context.tertiaryTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small tappable pill surfacing the truck's existing notes thread. Kept
/// separate from [TruckAvatar] so every card's avatar renders the same way
/// while the notes affordance stays available exactly as it does today.
class _TruckNotesButton extends StatelessWidget {
  const _TruckNotesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'View notes'.tr,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.brandColor.applyOpacity(
                context.isDark ? 0.16 : 0.08,
              ),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: context.brandColor.applyOpacity(0.24),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: context.isDark
                      ? Colors.white.applyOpacity(0.9)
                      : context.brandColor,
                ),
                const SizedBox(width: 5),
                Text(
                  'Notes'.tr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.isDark
                            ? Colors.white.applyOpacity(0.9)
                            : context.brandColor,
                        fontWeight: FontWeight.w700,
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

class TruckMetadataRow extends StatelessWidget {
  const TruckMetadataRow({
    super.key,
    required this.icon,
    required this.value,
    required this.semanticLabel,
    required this.copyMessage,
  });

  final IconData icon;
  final String value;
  final String semanticLabel;
  final String copyMessage;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$semanticLabel: $value',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 15,
            color: context.tertiaryTextColor,
          ).marginOnly(right: 6, top: 2),
          Expanded(
            child: ExcludeSemantics(
              child: RichText(
                text: TextSpan(
                  text: value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      try {
                        ClipboardHelper.copyPlainText(
                          value,
                          showSnackBar: true,
                          message: copyMessage,
                        );
                      } catch (_) {}
                    },
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TruckAvatar extends StatelessWidget {
  const TruckAvatar({super.key, required this.name});

  final String name;

  static const double _size = 44;

  String get _initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String initials = _initials;

    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.brandColor.applyOpacity(context.isDark ? 0.18 : 0.10),
        border: Border.all(color: context.brandColor.applyOpacity(0.24)),
      ),
      child: initials.isEmpty
          ? Icon(
              Icons.local_shipping_rounded,
              size: 20,
              color: context.isDark
                  ? Colors.white.applyOpacity(0.85)
                  : context.brandColor,
            )
          : Text(
              initials,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.isDark
                        ? Colors.white.applyOpacity(0.9)
                        : context.brandColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
    );
  }
}

class TruckStatusBadge extends StatelessWidget {
  const TruckStatusBadge({super.key, required this.status});

  final String? status;

  Color _color(BuildContext context) {
    final bool isDark = context.isDark;
    switch (status?.trim().toLowerCase()) {
      case 'active':
        return isDark ? Colors.green.shade300 : Colors.green.shade700;
      case 'pending':
      case 'hold':
        return isDark ? Colors.orange.shade300 : Colors.orange.shade800;
      case 'inactive':
      case 'expired':
        return Theme.of(context).colorScheme.error;
      default:
        return context.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _color(context);
    final String? raw = status?.trim();
    final String label =
        (raw == null || raw.isEmpty) ? 'Unknown'.tr : raw.toTitleCase();

    return Semantics(
      label: '${'Status'.tr}: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.applyOpacity(context.isDark ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

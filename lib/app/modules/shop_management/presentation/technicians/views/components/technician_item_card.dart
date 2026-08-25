import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../domain/entities/technician_entity.dart';
import '../../controllers/technicians_controller.dart';

/// Compact technician row. The technician model only carries a name and
/// status today, so the card stays deliberately small (no tap-to-details —
/// that interaction doesn't exist upstream yet).
class TechnicianCard extends GetView<TechniciansController> {
  final TechnicianEntity technician;

  const TechnicianCard({super.key, required this.technician});

  static const double _radius = 16;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isActive = technician.isActive == true;
    final String name = technician.name?.trim() ?? '';

    return Slidable(
      key: ValueKey(technician.id),
      closeOnScroll: true,
      groupTag: 'technician_listing_slide_group',
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => controller.onDisableTechnicianCicked(technician),
            backgroundColor: context.brandColor,
            foregroundColor: Colors.white,
            icon: isActive ? Icons.person_off_outlined : Icons.person_outline,
            label: isActive ? 'Disable'.tr : 'Enable'.tr,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
          SlidableAction(
            onPressed: (_) {
              Get.toNamed(Routes.CREATE_EDIT_TECHNICIAN, arguments: technician);
            },
            backgroundColor: context.primaryTextColor,
            foregroundColor: context.backgroundColor,
            icon: Icons.edit_outlined,
            label: 'Update'.tr,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
        ],
      ),
      child: Semantics(
        label: name.isEmpty
            ? 'Technician, ${isActive ? 'active' : 'inactive'}'
            : '$name, ${isActive ? 'active' : 'inactive'}',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: context.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.045),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _TechnicianAvatar(name: name),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name.isEmpty ? 'No Name Provided'.tr : name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _TechnicianStatusBadge(isActive: isActive),
            ],
          ),
        ),
      ),
    );
  }
}

/// Initials avatar; falls back to a generic person icon when the technician
/// has no usable name.
class _TechnicianAvatar extends StatelessWidget {
  const _TechnicianAvatar({required this.name});

  final String name;

  static const double _size = 40;

  String get _initials {
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
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
              Icons.person_outline_rounded,
              size: 18,
              color: context.isDark
                  ? Colors.white.applyOpacity(0.85)
                  : context.brandColor,
            )
          : Text(
              initials,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.isDark
                        ? Colors.white.applyOpacity(0.9)
                        : context.brandColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
    );
  }
}

class _TechnicianStatusBadge extends StatelessWidget {
  const _TechnicianStatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isActive
        ? (context.isDark ? Colors.green.shade300 : Colors.green.shade700)
        : Theme.of(context).colorScheme.error;
    final String label = isActive ? 'Active'.tr : 'Inactive'.tr;

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: foreground.applyOpacity(context.isDark ? 0.18 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: foreground.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration:
                  BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_botton.dart';
import 'package:ts_admin/app/core/widgets/app_botton_outline.dart';
import 'package:ts_admin/app/core/widgets/inspection_request_widgets.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_driver_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/driver_inspection/controllers/driver_inspection_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class DriverInspectionRequestCard extends GetView<DriverInspectionController> {
  const DriverInspectionRequestCard({
    super.key,
    required this.inspection,
    required this.index,
    required this.isPendingInspection,
  });

  final InspectionDriverEntity inspection;
  final int index;
  final bool isPendingInspection;

  static String? _clean(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    final String name = _clean(inspection.name) ?? 'N/A';
    final String phone = _clean(inspection.phone) ?? 'N/A';
    final String? status = _clean(inspection.status);
    final DateTime? createdAt = inspection.createdAt;

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
        controller: inspection.tileController,
        initiallyExpanded: false,
        onExpansionChanged: (_) {},
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: context.secondaryTextColor,
        collapsedIconColor: context.secondaryTextColor,
        title: _CollapsedHeader(
          name: name,
          id: inspection.id,
          phone: phone,
          status: status,
        ),
        children: [
          Divider(height: 1, color: context.hairlineBorderColor),
          const SizedBox(height: 12),

          //
          // requested by
          InspectionMetadataRow(
            icon: Icons.person_outline_rounded,
            label: 'Requested by',
            value: _clean(inspection.requestBy) ?? 'N/A',
          ),

          //
          // inspected by (inspected mode only)
          if (!isPendingInspection) ...[
            const SizedBox(height: 10),
            InspectionMetadataRow(
              icon: Icons.verified_user_outlined,
              label: 'Inspected by',
              value: _clean(inspection.inspectedBy) ?? 'N/A',
            ),
          ],

          //
          // created date (only when present)
          if (createdAt != null) ...[
            const SizedBox(height: 10),
            InspectionMetadataRow(
              icon: Icons.event_outlined,
              label: 'Created',
              value: DateFormat('yyyy-MM-dd').format(createdAt),
            ),
          ],

          const SizedBox(height: 16),

          //
          // actions
          _Actions(
            inspection: inspection,
            isPendingInspection: isPendingInspection,
          ),
        ],
      ),
    );
  }
}

/// Collapsed card content: driver avatar, name (primary title), compact request
/// number + optional status badge, and a phone metadata row.
class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    required this.name,
    required this.id,
    required this.phone,
    required this.status,
  });

  final String name;
  final String? id;
  final String phone;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // driver avatar
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.brandColor.applyOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_rounded,
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
              //
              // driver name (primary title)
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              //
              // request number + optional status badge
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Request #${id ?? '—'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                  if (status != null) InspectionStatusBadge(status: status!),
                ],
              ),

              const SizedBox(height: 8),

              //
              // phone
              Row(
                children: [
                  Icon(
                    Icons.phone_rounded,
                    size: 15,
                    color: context.secondaryTextColor,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Semantics(
                      label: 'Phone number, $phone',
                      child: Text(
                        phone,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Expanded-card actions: the shared primary button (New Inspection / View
/// Details) plus a super-admin-only Delete. Stacks vertically when the row is
/// too narrow or text is scaled up.
class _Actions extends GetView<DriverInspectionController> {
  const _Actions({
    required this.inspection,
    required this.isPendingInspection,
  });

  final InspectionDriverEntity inspection;
  final bool isPendingInspection;

  void _onPrimary() {
    if (isPendingInspection) {
      Get.toNamed(
        Routes.NEW_INSPECTION,
        arguments: {
          'type': controller.type,
          'value': inspection.name,
          'id': inspection.id,
        },
      );
    } else {
      Get.toNamed(
        Routes.INSPECTION_DETAILS,
        arguments: {
          'type': controller.type,
          'id': inspection.id,
        },
      );
    }
  }

  void _onDelete(BuildContext context) {
    showDeleteDialog(
      context,
      () async {
        Get.back();
        await controller.deleteRequest(inspection, isPendingInspection);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String primaryLabel =
        isPendingInspection ? 'New Inspection' : 'View Details';

    return Obx(() {
      final bool showDelete = controller.isSuperAdmin;
      final bool deleting = inspection.isDeleting.value;

      final Widget primaryButton = AppButton(
        isLoading: false,
        text: primaryLabel,
        onTap: _onPrimary,
      );

      if (!showDelete) {
        return SizedBox(width: double.infinity, child: primaryButton);
      }

      final Widget deleteButton = AppButtonOutline(
        text: 'Delete',
        isLoading: deleting,
        onTap: () => _onDelete(context),
      );

      return LayoutBuilder(
        builder: (context, constraints) {
          final bool stack = constraints.maxWidth < 340 ||
              MediaQuery.textScalerOf(context).scale(14) > 20;

          if (stack) {
            return Column(
              children: [
                SizedBox(width: double.infinity, child: primaryButton),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: deleteButton),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: primaryButton),
              const SizedBox(width: 10),
              Expanded(flex: 1, child: deleteButton),
            ],
          );
        },
      );
    });
  }
}

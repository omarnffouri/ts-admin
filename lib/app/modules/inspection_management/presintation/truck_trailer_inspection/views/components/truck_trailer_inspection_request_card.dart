import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_botton.dart';
import 'package:ts_admin/app/core/widgets/app_botton_outline.dart';
import 'package:ts_admin/app/core/widgets/inspection_request_widgets.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_truck_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/controllers/truck_trailer_inspection_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

/// Reusable, status-configurable request card for a truck/trailer inspection.
///
/// A single collapsed/expanded layout serves both the Pending and Inspected
/// modes — the [isPendingInspection] flag drives which metadata rows and
/// primary action are shown. All navigation, arguments and delete behavior are
/// identical to the previous implementation (UI-only redesign).
class TruckTrailerInspectionRequestCard
    extends GetView<TruckTrailerInspectionController> {
  const TruckTrailerInspectionRequestCard({
    super.key,
    required this.inspection,
    required this.index,
    required this.isPendingInspection,
  });

  final InspectionTrailerTruckEntity inspection;
  final int index;
  final bool isPendingInspection;

  /// Normalizes the "null"/blank sentinels the API sometimes returns so the UI
  /// never renders a literal "null" or an unexplained blank value.
  static String? _clean(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    final bool isTrailer = controller.type.value.toLowerCase() == 'trailer';

    final String identifier = _clean(inspection.truckIdentifier) ?? 'N/A';
    final String? status = _clean(inspection.status);
    final String? location = _clean(inspection.trailerLocation);
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
          identifier: identifier,
          id: inspection.id,
          status: status,
          typeIcon: isTrailer
              ? Icons.rv_hookup_rounded
              : Icons.local_shipping_rounded,
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
          // location (only when present)
          if (location != null) ...[
            const SizedBox(height: 10),
            InspectionMetadataRow(
              icon: Icons.place_outlined,
              label: 'Location',
              value: location,
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

/// Collapsed card content: type avatar, identifier (primary title) and a
/// compact request number + optional status badge.
class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    required this.identifier,
    required this.id,
    required this.status,
    required this.typeIcon,
  });

  final String identifier;
  final String? id;
  final String? status;
  final IconData typeIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // type avatar
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.brandColor.applyOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            typeIcon,
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
              // identifier (primary title)
              Text(
                identifier,
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
class _Actions extends GetView<TruckTrailerInspectionController> {
  const _Actions({
    required this.inspection,
    required this.isPendingInspection,
  });

  final InspectionTrailerTruckEntity inspection;
  final bool isPendingInspection;

  void _onPrimary() {
    if (isPendingInspection) {
      Get.toNamed(
        Routes.NEW_INSPECTION,
        arguments: {
          'type': controller.type.value,
          'value': inspection.id,
          'id': inspection.id,
        },
      );
    } else {
      Get.toNamed(
        Routes.INSPECTION_DETAILS,
        arguments: {
          'type': controller.type.value,
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

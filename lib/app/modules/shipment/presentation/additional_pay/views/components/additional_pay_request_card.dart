import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';

import 'package:ts_admin/app/core/utils/additional_pay_extensions.dart';

import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/action_pill_button.dart';

import 'approved_amount_caption.dart';

class AdditionalPayRequestCard extends StatelessWidget {
  const AdditionalPayRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onOpenShipment,
    this.isLast = false,
  });

  final AdditionalPayEntity request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onOpenShipment;
  final bool isLast;

  //! Shared with the list skeleton so the two silhouettes can't drift.
  static const double glyphSlot = 22;
  static const double glyphGutter = 7;
  static const double moneyColumnWidth = 128;

  static BoxDecoration decoration(BuildContext context) => BoxDecoration(
        color: context.flatCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: context.isDark
            ? null
            : Border.all(color: Colors.black.applyOpacity(0.04)),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                  spreadRadius: -6,
                ),
              ],
      );

  @override
  Widget build(BuildContext context) {
    final AdditionalPayStatus status = request.status.value;
    final String? note = request.note.value;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        if (t >= 1.0) return child!;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 18),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, isLast ? 40.h : 0),
        child: Container(
          decoration: decoration(context),
          // Approve/Reject sit inside and hit-test first, so they keep their
          // own taps on a pending row.
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onOpenShipment,
              splashColor: AppColorsLight.mainColor.applyOpacity(0.06),
              highlightColor: AppColorsLight.mainColor.applyOpacity(0.03),
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HeaderRow(request: request, status: status),
                    if (!status.hasActionRow &&
                        (note?.isNotEmpty ?? false)) ...[
                      SizedBox(height: 8.h),
                      _NoteLine(note: note!),
                    ],
                    if (status.hasActionRow) ...[
                      SizedBox(height: 12.h),
                      _ActionRow(onApprove: onApprove, onReject: onReject),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Driver + context left, money in a fixed column so the figures line up
/// decimal-for-decimal down the list.
class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.request, required this.status});

  final AdditionalPayEntity request;
  final AdditionalPayStatus status;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool isPending = status.hasActionRow;
    final Color glyph = isPending ? AppColorsLight.mainColor : status.color;
    final String? team = request.teamName;
    final double railIndent = AdditionalPayRequestCard.glyphSlot.w +
        AdditionalPayRequestCard.glyphGutter.w;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _RailLine(
                glyph: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.r),
                    color: glyph.applyOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    size: 13.sp,
                    color: glyph,
                  ),
                ),
                label: Text(
                  request.driverName ?? '',
                  maxLines: 2,
                  style: text.titleSmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
              if (team?.isNotEmpty ?? false) ...[
                SizedBox(height: 2.h),
                _TeamLine(team: team!),
              ],
              SizedBox(height: 3.h),
              // Indented to the rail so all four lines share one left edge.
              Padding(
                padding: EdgeInsets.only(left: railIndent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MetaLine(request: request),
                    SizedBox(height: 3.h),
                    Text(
                      request.requestedCaption,
                      maxLines: 2,
                      style: text.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: context.mutedTextColor.applyOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: AdditionalPayRequestCard.moneyColumnWidth.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Only the headline scales; the caption keeps its own size.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  request.deltaLabel,
                  maxLines: 1,
                  style: text.titleLarge?.copyWith(
                    fontSize: 19.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: isPending
                        ? context.amountAccentColor
                        : context.primaryTextColor,
                  ),
                ),
              ),
              ApprovedAmountCaption(amount: request.approvedAmountLabel),
            ],
          ),
        ),
      ],
    );
  }
}

/// Glyph slot + label. Owns the rail geometry both icon rows align to.
class _RailLine extends StatelessWidget {
  const _RailLine({required this.glyph, required this.label});

  final Widget glyph;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AdditionalPayRequestCard.glyphSlot.w,
          height: AdditionalPayRequestCard.glyphSlot.w,
          child: glyph,
        ),
        SizedBox(width: AdditionalPayRequestCard.glyphGutter.w),
        Expanded(child: label),
      ],
    );
  }
}

class _TeamLine extends StatelessWidget {
  const _TeamLine({required this.team});

  final String team;

  @override
  Widget build(BuildContext context) {
    final Color tone = context.secondaryTextColor;

    return _RailLine(
      // Bare glyph, no badge — two filled squares in the rail would be busy.
      glyph: Icon(Icons.groups_rounded, size: 14.sp, color: tone),
      label: Text(
        team,
        maxLines: 2,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: tone,
              height: 1.15,
            ),
      ),
    );
  }
}

/// Ref · truck. Weight and color carry the hierarchy — a container around
/// non-interactive data reads as a tappable filter chip.
class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.request});

  final AdditionalPayEntity request;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.mutedTextColor;
    final TextStyle base =
        (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: muted,
      height: 1.25,
    );

    final String? ref = request.shipmentRef;
    final String? truck = request.truckNumber;
    final bool hasRef = ref?.isNotEmpty ?? false;
    final bool hasTruck = truck?.isNotEmpty ?? false;
    if (!hasRef && !hasTruck) return const SizedBox.shrink();

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          if (hasRef)
            TextSpan(
              text: ref,
              style: base.copyWith(
                fontWeight: FontWeight.w700,
                color: context.secondaryTextColor,
              ),
            ),
          if (hasRef && hasTruck)
            TextSpan(
              text: '  ·  ',
              style: base.copyWith(color: muted.applyOpacity(0.45)),
            ),
          if (hasTruck) TextSpan(text: 'Truck $truck'),
        ],
      ),
      maxLines: 2,
    );
  }
}

class _NoteLine extends StatelessWidget {
  const _NoteLine({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.mutedTextColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Neutral, not status-colored — the badge already carries status.
        Icon(Icons.sticky_note_2_outlined, size: 13.sp, color: muted),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  height: 1.3,
                  color: context.mutedTextColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.onApprove, required this.onReject});

  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ActionPillButton(
            label: 'Reject',
            icon: Icons.close_rounded,
            background: context.mutedControlColor,
            foreground: isDark
                ? Colors.white.applyOpacity(0.9)
                : Colors.black.applyOpacity(0.75),
            onTap: onReject,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 3,
          child: ActionPillButton(
            label: 'Approve',
            icon: Icons.check_rounded,
            background: AppColorsLight.approveActionColor,
            foreground: AppColorsLight.approveActionTextColor,
            onTap: onApprove,
          ),
        ),
      ],
    );
  }
}

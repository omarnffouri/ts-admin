import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';

import 'package:ts_admin/app/core/utils/additional_pay_extensions.dart';

import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/action_pill_button.dart';

/// Confirmation sheet for approving / rejecting an additional pay request.
class AdditionalPayActionSheet extends StatelessWidget {
  const AdditionalPayActionSheet({
    super.key,
    required this.request,
    required this.isApprove,
    required this.noteController,
    required this.submittingId,
    required this.onConfirm,
  });

  final AdditionalPayEntity request;
  final bool isApprove;
  final TextEditingController noteController;

  /// Busy only when it matches this sheet's own request.
  final RxnInt submittingId;
  final VoidCallback onConfirm;

  AdditionalPayStatus get _decision =>
      isApprove ? AdditionalPayStatus.approved : AdditionalPayStatus.rejected;

  @override
  Widget build(BuildContext context) {
    // System handles keyboard resize; cap keeps the sheet under full screen.
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.75),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _DragHandle()),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isApprove ? 'Approve request' : 'Reject request',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const _CloseButton(),
                ],
              ),
              SizedBox(height: 14.h),
              _RequestSummary(request: request),
              SizedBox(height: 12.h),
              _NoteField(
                controller: noteController,
                decision: _decision,
                hint: isApprove
                    ? 'Why is this being approved? (required)'
                    : 'Why is this being rejected? (required)',
              ),
              SizedBox(height: 14.h),
              _SheetActions(
                request: request,
                decision: _decision,
                noteController: noteController,
                submittingId: submittingId,
                onConfirm: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: Get.textTheme.bodySmall?.color?.applyOpacity(0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.mutedControlColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: Get.back,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: Get.textTheme.bodyMedium?.color?.applyOpacity(0.85),
          ),
        ),
      ),
    );
  }
}

class _RequestSummary extends StatelessWidget {
  const _RequestSummary({required this.request});

  /// Money column cap — keeps the driver block readable.
  static const double _moneyColumnMaxWidth = 140;

  final AdditionalPayEntity request;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.mutedTextColor;
    final Color highlight = context.amountAccentColor;
    final String? approved = request.approvedAmountLabel;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  request.driverName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${request.shipmentRef} · Truck ${request.truckNumber}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // One FittedBox scales both lines together (card has no cap by design).
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _moneyColumnMaxWidth.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    request.deltaLabel,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: highlight,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (approved != null) ...[
                    SizedBox(height: 1.h),
                    // Worded here; the card uses the check variant.
                    Text(
                      'approved $approved',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({
    required this.controller,
    required this.hint,
    required this.decision,
  });

  final TextEditingController controller;
  final String hint;
  final AdditionalPayStatus decision;

  String get _noun =>
      decision == AdditionalPayStatus.approved ? 'approval' : 'rejection';

  @override
  Widget build(BuildContext context) {
    final Color? muted = Get.textTheme.bodySmall?.color?.applyOpacity(0.5);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        // An untouched field is empty, not wrong.
        final bool showError =
            value.text.trim().isNotEmpty && !decision.acceptsNote(value.text);

        return Container(
          decoration: BoxDecoration(
            color: context.surfaceVariantColor,
            borderRadius: BorderRadius.circular(14),
            border: showError
                ? Border.all(color: AppColorsLight.rejectActionColor)
                : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            style: Get.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Get.textTheme.bodyMedium?.copyWith(color: muted),
              errorText: showError
                  ? 'Add at least $kMinDecisionNoteLength characters '
                      'explaining the $_noun'
                  : null,
              errorStyle: Get.textTheme.bodySmall?.copyWith(
                color: AppColorsLight.rejectActionColor,
                fontWeight: FontWeight.w600,
              ),
              // Shares its row with the 1/500 counter — one line ellipsizes.
              errorMaxLines: 2,
              // All five: the Container draws the box, Material would double it.
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              counterStyle: Get.textTheme.bodySmall?.copyWith(
                color: muted,
                fontSize: 10.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SheetActions extends StatelessWidget {
  const _SheetActions({
    required this.request,
    required this.decision,
    required this.noteController,
    required this.submittingId,
    required this.onConfirm,
  });

  final AdditionalPayEntity request;
  final AdditionalPayStatus decision;
  final TextEditingController noteController;
  final RxnInt submittingId;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final Color? cancelFg = Get.textTheme.bodyMedium?.color?.applyOpacity(0.9);
    final bool isApprove = decision == AdditionalPayStatus.approved;
    final Color base = isApprove
        ? AppColorsLight.approveActionColor
        : AppColorsLight.rejectActionColor;
    final Color fg =
        isApprove ? AppColorsLight.approveActionTextColor : Colors.white;

    // Outer listener is the rare one, so typing rebuilds only the Row.
    return Obx(() {
      final bool busy = submittingId.value == request.id;

      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: noteController,
        builder: (context, value, _) {
          final bool noteOk = decision.acceptsNote(value.text);
          final bool enabled = noteOk && !busy;
          // Spinner is drawn in the foreground colour — invisible if faded.
          final bool solid = noteOk || busy;

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: ActionPillButton(
                  label: 'Cancel',
                  height: 44,
                  background: context.mutedControlColor,
                  foreground: cancelFg ?? Colors.white,
                  onTap: busy ? null : Get.back,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 3,
                child: ActionPillButton(
                  label: isApprove
                      ? 'Approve ${request.amountLabel}'
                      : 'Reject request',
                  icon: isApprove ? Icons.check_rounded : Icons.close_rounded,
                  height: 44,
                  scaleLabel: isApprove,
                  isLoading: busy,
                  background: solid ? base : base.applyOpacity(0.28),
                  foreground: solid ? fg : fg.applyOpacity(0.45),
                  onTap: enabled ? onConfirm : null,
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

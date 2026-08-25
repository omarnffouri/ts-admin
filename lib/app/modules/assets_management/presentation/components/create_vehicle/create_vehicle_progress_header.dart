import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

class CreateVehicleProgressHeader extends StatelessWidget {
  const CreateVehicleProgressHeader({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.stepName,
    required this.onBack,
  });

  final String title;
  final int currentStep;
  final int totalSteps;
  final String stepName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.paddingOf(context).top + 10.h,
        16.w,
        16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Semantics(
                button: true,
                label: 'Go back',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: Colors.white.applyOpacity(0.16),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.applyOpacity(0.22),
                        ),
                      ),
                      child: Icon(
                        isRtl
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_back_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Semantics(
            label: 'Step ${currentStep + 1} of $totalSteps, $stepName',
            child: Row(
              children: [
                Text(
                  '${currentStep + 1}/$totalSteps',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / totalSteps,
                      minHeight: 5,
                      color: Colors.white,
                      backgroundColor: Colors.white30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    stepName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

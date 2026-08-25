import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_listview.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../components/inspection_form/inspection_completion_counter.dart';
import '../../components/inspection_form/inspection_details_section.dart';
import '../../components/inspection_page_header.dart';
import '../../components/inspection_form/inspection_subject_card.dart';
import '../../components/inspection_form/inspection_text_field.dart';
import '../../components/inspection_type_visuals.dart';
import '../controllers/new_inspection_controller.dart';

import 'components/dropdown_widget.dart';
import 'components/inspection_categories_list.dart';
import 'components/select_dates_widget.dart';
import 'components/select_time_widget.dart';
import 'components/signature_widget.dart';

/// Shared inspection form — the single screen behind driver, truck and trailer
/// inspections. Everything type-specific (title, subject, categories, final
/// fields) comes from the existing controller state; the layout below is the
/// same for all of them.
class NewInspectionView extends StatefulWidget {
  const NewInspectionView({super.key});

  @override
  State<NewInspectionView> createState() => _NewInspectionViewState();
}

class _NewInspectionViewState extends State<NewInspectionView> {
  final NewInspectionController controller =
      Get.find<NewInspectionController>();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _checklistKey = GlobalKey();
  final GlobalKey _dateKey = GlobalKey();
  final GlobalKey _milesKey = GlobalKey();
  final GlobalKey _signatureKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (controller.isSubmitting.value) {
      return;
    }

    await controller.submitInspectionRequest();

    if (!mounted) {
      return;
    }
    _revealInvalidField();
  }

  /// Brings whichever field the existing validation rejected back into view.
  void _revealInvalidField() {
    final Map<String, GlobalKey> targets = <String, GlobalKey>{
      'checks': _checklistKey,
      'date': _dateKey,
      'miles': _milesKey,
      'signature': _signatureKey,
    };

    final BuildContext? target =
        targets[controller.invalidField.value]?.currentContext;
    if (target == null) {
      return;
    }

    Scrollable.ensureVisible(
      target,
      alignment: 0.1,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            //
            // header
            Obx(
              () => InspectionPageHeader(
                title: InspectionTypeVisuals.pageTitle(
                  controller.selectedInspectionType.value,
                ),
              ),
            ),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _BodyReveal(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // inspected subject
                        Obx(
                          () => InspectionSubjectCard(
                            type: controller.type.value,
                            subject: controller.value.value,
                            reference: controller.id.value,
                          ),
                        ),

                        const SizedBox(height: 20),

                        //
                        // checklist
                        _ChecklistSection(key: _checklistKey),

                        //
                        // final details, signature and submit — gated by the
                        // same flag as before.
                        Obx(
                          () => !controller.showInspection.value
                              ? const SizedBox(width: double.infinity)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 22),
                                    _FinalDetailsSection(
                                      dateKey: _dateKey,
                                      milesKey: _milesKey,
                                    ),
                                    const SizedBox(height: 22),
                                    _SignatureSection(key: _signatureKey),
                                    const SizedBox(height: 26),
                                    Obx(
                                      () => MainAppButton(
                                        label: 'Submit',
                                        height: 52,
                                        borderRadius: 14,
                                        isLoading:
                                            controller.isSubmitting.value,
                                        leadingIcon: const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.white,
                                        ),
                                        onPressed: _onSubmit,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Checklist block: overall progress plus one card per category. Shows the
/// existing shimmer while the categories load and an inline retry when the
/// request came back without any.
class _ChecklistSection extends GetView<NewInspectionController> {
  const _ChecklistSection({super.key});

  int _completedChecks() {
    int completed = 0;
    for (final field in controller.inspectionFields) {
      completed +=
          field.checks?.where((check) => check.isPassed == true).length ?? 0;
    }
    return completed;
  }

  int _totalChecks() {
    int total = 0;
    for (final field in controller.inspectionFields) {
      total += field.checks?.length ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return InspectionDetailsSection(
      icon: Icons.checklist_rounded,
      title: 'Inspection Checklist',
      subtitle: 'Switch on every check that passed.',
      padded: false,
      spacing: 0,
      trailing: Obx(
        () => InspectionCompletionCounter(
          completed: _completedChecks(),
          total: _totalChecks(),
        ),
      ),
      children: [
        Obx(
          () {
            if (controller.isLoading.value) {
              return const LoadingListView(count: 6);
            }

            if (controller.inspectionFields.isEmpty) {
              return controller.showInspection.value
                  ? const _ChecklistUnavailable()
                  : const SizedBox(width: double.infinity);
            }

            return const InspectionCategoriesList();
          },
        ),
      ],
    );
  }
}

/// Section-level message shown when the checklist request returned nothing —
/// reuses the controller's existing loader for the retry.
class _ChecklistUnavailable extends GetView<NewInspectionController> {
  const _ChecklistUnavailable();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No inspection checks are available right now.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Semantics(
              button: true,
              label: 'Try loading the checklist again',
              child: TextButton(
                onPressed: controller.loadInspectionData,
                style: TextButton.styleFrom(
                  minimumSize: const Size(64, 48),
                  foregroundColor: context.brandColor,
                ),
                child: Text(
                  'Try again',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: context.brandColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The fields that close the inspection. Which ones appear is decided by the
/// existing state (`type`, `showTimeWidget`) — nothing here was added or
/// removed.
class _FinalDetailsSection extends GetView<NewInspectionController> {
  const _FinalDetailsSection({
    required this.dateKey,
    required this.milesKey,
  });

  final GlobalKey dateKey;
  final GlobalKey milesKey;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isDriver = controller.type.value == "driver";

        return InspectionDetailsSection(
          icon: Icons.fact_check_outlined,
          title: 'Inspection Details',
          children: [
            //
            // date
            SelectDateWidget(fieldKey: dateKey),

            //
            // time (revealed once a date is picked)
            if (controller.showTimeWidget.value) const SelectTimeWidget(),

            //
            // qualification / satisfactory question
            const DropDownWidget(),

            //
            // miles (driver inspections only)
            if (isDriver)
              InspectionTextField(
                fieldKey: milesKey,
                controller: controller.milesTxtController,
                label: 'Miles',
                hint: 'Add miles here',
                isRequired: true,
                keyboardType: TextInputType.number,
                semanticsLabel: 'Road test miles, required',
              ),

            //
            // explanation / remarks
            InspectionTextField(
              controller: controller.remarksTxtController,
              label: isDriver
                  ? 'Explain additional training planned for this driver'
                  : 'Remarks',
              hint: isDriver
                  ? 'Add additional training here'
                  : 'Add remarks here',
              textInputAction: TextInputAction.done,
            ),
          ],
        );
      },
    );
  }
}

/// Signature block — a titled surface around the shared pad.
class _SignatureSection extends StatelessWidget {
  const _SignatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const InspectionDetailsSection(
      icon: Icons.draw_outlined,
      title: 'Signature',
      subtitle: 'Required before the inspection can be submitted.',
      padded: false,
      spacing: 0,
      children: [SignatureWidget()],
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

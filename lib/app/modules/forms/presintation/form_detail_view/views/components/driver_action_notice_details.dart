import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';

/// Read-only, sectioned presentation for the Driver Action Notice fields.
///
/// The API-provided field order remains the source of truth. An `editor`
/// field starts a visual section and every following field stays in that
/// section until the next `editor` field.
class DriverActionNoticeDetails extends StatelessWidget {
  const DriverActionNoticeDetails({
    super.key,
    required this.form,
  });

  final FormEntity form;

  @override
  Widget build(BuildContext context) {
    final List<_FormSectionData> sections = _buildSections(
      form.formFields ?? const <FormFieldEntity>[],
    );

    return Form(
      key: form.formGlobalKey,
      child: Column(
        children: [
          _DetailsSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CreationCardHeader(
                  icon: Icons.assignment_outlined,
                  title: 'Notice Details',
                ),
                const SizedBox(height: 18),
                DriverActionNoticeSummary(form: form),
                for (int index = 0; index < sections.length; index++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Divider(
                      height: 1,
                      color: context.hairlineBorderColor,
                    ),
                  ),
                  FormDetailsSection(
                    heading: sections[index].heading,
                    fields: sections[index].fields,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  List<_FormSectionData> _buildSections(List<FormFieldEntity> fields) {
    final List<_FormSectionData> sections = <_FormSectionData>[];
    FormFieldEntity? heading;
    List<FormFieldEntity> currentFields = <FormFieldEntity>[];

    void addCurrentSection() {
      if (heading != null || currentFields.isNotEmpty) {
        sections.add(
          _FormSectionData(
            heading: heading,
            fields: currentFields,
          ),
        );
      }
    }

    for (final FormFieldEntity field in fields) {
      if (field.type == 'editor') {
        addCurrentSection();
        heading = field;
        currentFields = <FormFieldEntity>[];
      } else {
        currentFields.add(field);
      }
    }
    addCurrentSection();

    return sections;
  }
}

class DriverActionNoticeSummary extends StatelessWidget {
  const DriverActionNoticeSummary({
    super.key,
    required this.form,
  });

  final FormEntity form;

  @override
  Widget build(BuildContext context) {
    final List<_SummaryItemData> items = <_SummaryItemData>[
      _SummaryItemData(
        icon: Icons.calendar_today_outlined,
        label: 'Date',
        value: form.createdAt.formatDateOrNA(),
      ),
      _SummaryItemData(
        icon: (form.isSigned ?? false)
            ? Icons.check_circle_outline_rounded
            : Icons.pending_actions_outlined,
        label: '',
        value: (form.isSigned ?? false) ? 'Signed' : 'Pending',
      ),
      if (form.applicantFormId != null)
        _SummaryItemData(
          icon: Icons.tag_rounded,
          label: 'Form #',
          value: form.applicantFormId.toString(),
        ),
    ];

    return Semantics(
      container: true,
      label:
          '${_displayValue(form.formName)}, ${_displayValue(form.applicantName)}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double textScale = MediaQuery.textScalerOf(context).scale(1);
            final bool useFullWidth = textScale > 1.3;
            final int columnCount = useFullWidth
                ? 1
                : constraints.maxWidth >= 330
                    ? 3
                    : 2;
            const double spacing = 12;
            final double itemWidth = useFullWidth
                ? constraints.maxWidth
                : (constraints.maxWidth - (spacing * (columnCount - 1))) /
                    columnCount;

            return Wrap(
              spacing: spacing,
              runSpacing: 10,
              children: [
                for (final _SummaryItemData item in items)
                  SizedBox(
                    width: itemWidth,
                    child: _SummaryItem(item: item),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FormDetailsSection extends StatelessWidget {
  const FormDetailsSection({
    super.key,
    required this.heading,
    required this.fields,
  });

  final FormFieldEntity? heading;
  final List<FormFieldEntity> fields;

  @override
  Widget build(BuildContext context) {
    final List<FormFieldEntity> visibleFields = fields
        .where(
          (FormFieldEntity field) =>
              field.type != 'checkbox' ||
              (field.formFieldsValue?.value.isNotEmpty ?? false),
        )
        .toList(growable: false);

    if (heading == null && visibleFields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (heading != null) ...[
              _SectionHtml(data: heading?.formFieldsValue?.value ?? ''),
              if (visibleFields.isNotEmpty) const SizedBox(height: 12),
            ],
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool useTwoColumns = constraints.maxWidth >= 320 &&
                    MediaQuery.textScalerOf(context).scale(1) <= 1.3;
                const double spacing = 10;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final FormFieldEntity field in visibleFields)
                      SizedBox(
                        width: useTwoColumns &&
                                (field.type == 'string' || field.type == 'date')
                            ? (constraints.maxWidth - spacing) / 2
                            : constraints.maxWidth,
                        child: _DriverActionNoticeField(field: field),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DriverActionNoticeActionPanel extends GetView<FormDetailViewController> {
  const DriverActionNoticeActionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.tileColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.panelBorderColor),
          boxShadow: context.isDark
              ? null
              : [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Signature',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Signature drawing area',
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 96,
                  maxHeight: 130,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.panelBorderColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: Signature(
                  controller: controller.signatureController,
                  backgroundColor: theme.colorScheme.surface,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: controller.signatureController.clear,
                icon: const Icon(Icons.undo_rounded, size: 18),
                label: const Text('Undo'),
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool stackButtons = constraints.maxWidth < 360;
                final Widget rejectButton = Semantics(
                  button: true,
                  label: 'Reject Driver Action Notice',
                  child: OutlinedButton(
                    onPressed: controller.showFormRejectionBottomSheet,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                    child: const Text('Reject'),
                  ),
                );
                final Widget continueButton = Semantics(
                  button: true,
                  label: 'Save signature and continue',
                  child: FilledButton(
                    onPressed: controller.saveAndContinue,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Save and Continue'),
                  ),
                );

                if (stackButtons) {
                  return Column(
                    children: [
                      SizedBox(width: double.infinity, child: continueButton),
                      const SizedBox(height: 10),
                      SizedBox(width: double.infinity, child: rejectButton),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: rejectButton),
                    const SizedBox(width: 12),
                    Expanded(child: continueButton),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverActionNoticeField extends StatelessWidget {
  const _DriverActionNoticeField({required this.field});

  final FormFieldEntity field;

  @override
  Widget build(BuildContext context) {
    final String label = _displayValue(field.label);
    final String value = _displayValue(field.formFieldsValue?.value);

    switch (field.type) {
      case 'string':
      case 'date':
        return FormDetailsRow(label: label, value: value);
      case 'textarea':
        return _LongTextValue(label: label, value: value);
      case 'checkbox':
        return FormSelectionSummary(label: label, isSelected: true);
      default:
        return const SizedBox.shrink();
    }
  }
}

class FormDetailsRow extends StatelessWidget {
  const FormDetailsRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: context.fieldFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormSelectionSummary extends StatelessWidget {
  const FormSelectionSummary({
    super.key,
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      selected: isSelected,
      label: '$label, ${isSelected ? 'selected' : 'not selected'}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected
              ? context.brandColor
                  .withValues(alpha: context.isDark ? 0.12 : 0.06)
              : context.fieldFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? context.brandColor.withValues(alpha: 0.24)
                : context.hairlineBorderColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 21,
              color:
                  isSelected ? context.brandColor : context.secondaryTextColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LongTextValue extends StatelessWidget {
  const _LongTextValue({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: context.fieldFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_containsHtml(value))
              _ReadOnlyHtmlValue(data: value)
            else
              SelectableText(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyHtmlValue extends StatelessWidget {
  const _ReadOnlyHtmlValue({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Html(
      data: data,
      style: {
        'body': Style(
          color: theme.colorScheme.onSurface,
          fontSize: FontSize.medium,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(
          color: theme.colorScheme.onSurface,
          fontSize: FontSize.medium,
          margin: Margins.zero,
        ),
      },
    );
  }
}

class _SectionHtml extends StatelessWidget {
  const _SectionHtml({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Html(
      data: data,
      style: {
        'body': Style(
          color: theme.colorScheme.onSurface,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'h2': Style(
          color: theme.colorScheme.onSurface,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w700,
          margin: Margins.zero,
        ),
        'h3': Style(
          color: theme.colorScheme.onSurface,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w700,
          margin: Margins.zero,
        ),
        'h4': Style(
          color: theme.colorScheme.onSurface,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w700,
          margin: Margins.zero,
        ),
        'p': Style(
          color: context.secondaryTextColor,
          fontSize: FontSize.medium,
          margin: Margins.zero,
        ),
      },
    );
  }
}

class _DetailsSurface extends StatelessWidget {
  const _DetailsSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _CreationCardHeader extends StatelessWidget {
  const _CreationCardHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.brandColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: context.brandColor),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.item});

  final _SummaryItemData item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: item.label.isEmpty ? item.value : '${item.label}: ${item.value}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: 19, color: context.secondaryTextColor),
          const SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (item.label.isNotEmpty)
                    TextSpan(
                      text: '${item.label} ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  TextSpan(
                    text: item.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSectionData {
  const _FormSectionData({
    required this.heading,
    required this.fields,
  });

  final FormFieldEntity? heading;
  final List<FormFieldEntity> fields;
}

class _SummaryItemData {
  const _SummaryItemData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

String _displayValue(String? value) {
  final String normalizedValue = value?.trim() ?? '';
  if (normalizedValue.isEmpty || normalizedValue.toLowerCase() == 'null') {
    return 'N/A';
  }
  return value!;
}

bool _containsHtml(String value) {
  return RegExp(r'<[a-zA-Z][^>]*>').hasMatch(value);
}

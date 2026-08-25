import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class CreateVehicleStepScaffold extends StatelessWidget {
  const CreateVehicleStepScaffold({
    super.key,
    required this.sections,
    required this.navigationBar,
    this.formKey,
  });

  final List<Widget> sections;

  final Widget navigationBar;

  final GlobalKey<FormState>? formKey;

  static void revealField(GlobalKey? key) {
    final BuildContext? fieldContext = key?.currentContext;
    if (fieldContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      fieldContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.15,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: sections,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child:
                formKey == null ? content : Form(key: formKey, child: content),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.backgroundColor,
            border: Border(
              top: BorderSide(color: context.hairlineBorderColor),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: navigationBar,
        ),
      ],
    );
  }
}

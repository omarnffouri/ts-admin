// Layout + behaviour harness for the shared inspection form widgets used by
// the driver, truck and trailer inspections.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_category_card.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_checklist_item.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_completion_counter.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_details_section.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_page_header.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_signature_pad.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_subject_card.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_form/inspection_text_field.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/components/inspection_type_visuals.dart';

Widget _host({
  required Widget child,
  required Brightness brightness,
  required double textScale,
  TextDirection direction = TextDirection.ltr,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Directionality(
      textDirection: direction,
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  final List<TextEditingController> controllers = <TextEditingController>[];
  final List<SignatureController> signatures = <SignatureController>[];

  TextEditingController makeController([String text = '']) {
    final TextEditingController controller = TextEditingController(text: text);
    controllers.add(controller);
    return controller;
  }

  SignatureController makeSignature() {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
    );
    signatures.add(controller);
    return controller;
  }

  tearDownAll(() {
    for (final TextEditingController controller in controllers) {
      controller.dispose();
    }
    for (final SignatureController controller in signatures) {
      controller.dispose();
    }
  });

  //
  // a category that mirrors the API shape: a long title plus a partially
  // completed checklist.
  Widget buildForm({
    required String type,
    required ExpansibleController tileController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InspectionSubjectCard(
          type: type,
          subject: type == InspectionTypeVisuals.driver ? 'John Doe' : '1042',
          reference: '77',
        ),
        const SizedBox(height: 18),
        InspectionDetailsSection(
          icon: Icons.checklist_rounded,
          title: 'Inspection Checklist',
          subtitle: 'Switch on every check that passed.',
          padded: false,
          spacing: 0,
          trailing: const InspectionCompletionCounter(
            completed: 24,
            total: 73,
          ),
          children: [
            InspectionCategoryCard(
              title: 'Placing Vehicle in Motion and Use of Controls',
              completed: 3,
              total: 11,
              isSelectedAll: false,
              tileController: tileController,
              onExpansionChanged: (_) {},
              onSelectAllChanged: (_) {},
              children: <Widget>[
                InspectionChecklistItem(
                  title: 'Engine start, warm up and shut down procedures',
                  isPassed: true,
                  onChanged: (_) {},
                ),
                InspectionChecklistItem(
                  title: 'Use of clutch and gear changes without excess noise',
                  isPassed: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        InspectionDetailsSection(
          icon: Icons.fact_check_outlined,
          title: 'Inspection Details',
          children: [
            InspectionTextField(
              controller: makeController('2026-07-29'),
              label: 'Date',
              hint: 'Select Date',
              isRequired: true,
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
            ),
            InspectionTextField(
              controller: makeController(),
              label: 'Miles',
              hint: 'Add miles here',
              isRequired: true,
              keyboardType: TextInputType.number,
            ),
            InspectionTextField(
              controller: makeController(),
              label: 'Explain additional training planned for this driver',
              hint: 'Add additional training here',
            ),
          ],
        ),
        const SizedBox(height: 22),
        InspectionDetailsSection(
          icon: Icons.draw_outlined,
          title: 'Signature',
          padded: false,
          spacing: 0,
          children: [
            InspectionSignaturePad(
              controller: makeSignature(),
              helperText: 'Sign inside the box using your finger or a stylus.',
              onUndo: () {},
            ),
          ],
        ),
        const SizedBox(height: 26),
        MainAppButton(
          label: 'Submit',
          height: 52,
          onPressed: () {},
        ),
      ],
    );
  }

  for (final String type in <String>['driver', 'truck', 'trailer']) {
    for (final Brightness brightness in Brightness.values) {
      for (final double textScale in <double>[1.0, 1.5, 2.0, 3.0]) {
        for (final Size size in <Size>[
          const Size(300, 640),
          const Size(375, 812),
          const Size(800, 500),
          const Size(900, 1200),
        ]) {
          for (final TextDirection direction in TextDirection.values) {
            testWidgets(
              '$type form renders — ${brightness.name}, scale $textScale, '
              '${size.width.toInt()}px, ${direction.name}',
              (tester) async {
                tester.view.physicalSize = size;
                tester.view.devicePixelRatio = 1.0;
                addTearDown(tester.view.resetPhysicalSize);
                addTearDown(tester.view.resetDevicePixelRatio);

                final ExpansibleController tileController =
                    ExpansibleController();

                await tester.pumpWidget(
                  _host(
                    brightness: brightness,
                    textScale: textScale,
                    direction: direction,
                    child: buildForm(
                      type: type,
                      tileController: tileController,
                    ),
                  ),
                );
                await tester.pump(const Duration(milliseconds: 500));

                expect(tester.takeException(), isNull);
              },
            );
          }
        }
      }
    }
  }

  testWidgets('category card: expansion, counter and Select All reporting',
      (tester) async {
    final ExpansibleController tileController = ExpansibleController();
    final List<bool> selectAllValues = <bool>[];
    final List<bool> expansionValues = <bool>[];

    await tester.pumpWidget(
      _host(
        brightness: Brightness.light,
        textScale: 1.0,
        child: InspectionCategoryCard(
          title: 'Pre-Trip Inspection',
          completed: 3,
          total: 11,
          isSelectedAll: false,
          tileController: tileController,
          onExpansionChanged: expansionValues.add,
          onSelectAllChanged: selectAllValues.add,
          children: <Widget>[
            InspectionChecklistItem(
              title: 'Lights and reflectors',
              isPassed: false,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );

    // collapsed state shows the title and the compact counter
    expect(find.text('Pre-Trip Inspection'), findsOneWidget);
    expect(find.text('3 / 11'), findsOneWidget);

    // Select All reports the flipped value and does not toggle the section
    await tester.tap(find.text('Select All'));
    await tester.pumpAndSettle();
    expect(selectAllValues, <bool>[true]);
    expect(expansionValues, isEmpty);

    // tapping the header expands the section
    await tester.tap(find.text('Pre-Trip Inspection'));
    await tester.pumpAndSettle();
    expect(expansionValues, <bool>[true]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checklist item toggles from the row and from the switch',
      (tester) async {
    final List<bool> values = <bool>[];

    await tester.pumpWidget(
      _host(
        brightness: Brightness.dark,
        textScale: 1.0,
        child: InspectionChecklistItem(
          title: 'Brake check',
          isPassed: false,
          onChanged: values.add,
        ),
      ),
    );

    await tester.tap(find.text('Brake check'));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(values, <bool>[true, true]);
  });

  testWidgets('subject card falls back to N/A and hides duplicate reference',
      (tester) async {
    await tester.pumpWidget(
      _host(
        brightness: Brightness.light,
        textScale: 1.0,
        child: const Column(
          children: [
            InspectionSubjectCard(type: 'driver', subject: '  ', reference: ''),
            SizedBox(height: 12),
            InspectionSubjectCard(
              type: 'truck',
              subject: '1042',
              reference: '1042',
            ),
          ],
        ),
      ),
    );

    expect(find.text('N/A'), findsOneWidget);
    expect(find.textContaining('null'), findsNothing);
    expect(find.textContaining('Request #'), findsNothing);
  });

  testWidgets('submit bar keeps its size and ignores taps while submitting',
      (tester) async {
    int taps = 0;

    Widget bar({required bool isSubmitting}) => _host(
          brightness: Brightness.light,
          textScale: 1.0,
          child: SizedBox(
            width: 320,
            child: MainAppButton(
              label: 'Submit',
              height: 52,
              isLoading: isSubmitting,
              onPressed: () => taps++,
            ),
          ),
        );

    await tester.pumpWidget(bar(isSubmitting: false));
    final Size idleSize = tester.getSize(find.byType(MainAppButton));
    await tester.tap(find.byType(MainAppButton));
    expect(taps, 1);

    await tester.pumpWidget(bar(isSubmitting: true));
    await tester.pump(const Duration(milliseconds: 300));
    final Size busySize = tester.getSize(find.byType(MainAppButton));

    await tester.tap(find.byType(MainAppButton));
    expect(taps, 1);
    expect(busySize, idleSize);
    expect(idleSize.height, 52);
  });

  testWidgets('signature pad renders and Undo fires', (tester) async {
    int undos = 0;

    await tester.pumpWidget(
      _host(
        brightness: Brightness.dark,
        textScale: 1.0,
        child: InspectionSignaturePad(
          controller: makeSignature(),
          onUndo: () => undos++,
        ),
      ),
    );

    await tester.tap(find.text('Undo'));
    await tester.pump();

    expect(undos, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header shows the per-type title without overflowing',
      (tester) async {
    for (final String type in <String>['driver', 'truck', 'trailer']) {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2.0),
              ),
              child: Scaffold(
                body: InspectionPageHeader(
                  title: InspectionTypeVisuals.pageTitle(type),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(InspectionTypeVisuals.pageTitle(type)), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

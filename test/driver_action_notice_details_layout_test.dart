import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/views/components/driver_action_notice_details.dart';

FormFieldEntity _field({
  required String type,
  required String label,
  required String value,
}) {
  return FormFieldEntity(
    type: type,
    label: label,
    isRequired: 0,
    formFieldsValue: FormFieldsValueEntity(value: value),
  );
}

FormEntity _form() {
  return FormEntity(
    formId: 75,
    applicantFormId: 1042,
    formName:
        'Driver Action Notice with a long localized form name that can wrap',
    applicantName: 'Alexandria Johnson-Williams',
    isSigned: false,
    createdAt: DateTime(2026, 7, 29),
    attachments: const <FormAttachmentEntity>[],
    videos: const <FormAttachmentEntity>[],
    otherDocuments: const <FormAttachmentEntity>[],
    formFields: <FormFieldEntity>[
      _field(
        type: 'editor',
        label: '',
        value: '<h2>Employee Information</h2>',
      ),
      _field(
        type: 'string',
        label: 'Driver name',
        value: 'Alexandria Johnson-Williams',
      ),
      _field(type: 'date', label: 'Date', value: '07-29-2026'),
      _field(
        type: 'string',
        label: 'Department with a long localized label',
        value: 'Regional Transportation and Logistics Operations',
      ),
      _field(
        type: 'editor',
        label: '',
        value: '<h2>Types of Warning</h2>',
      ),
      _field(type: 'checkbox', label: 'Verbal Warning', value: '1'),
      _field(type: 'checkbox', label: 'Written Warning', value: ''),
      _field(
        type: 'editor',
        label: '',
        value: '<h2>Types of Offenses</h2>',
      ),
      _field(
        type: 'checkbox',
        label: 'Failure to follow established safety procedures',
        value: '1',
      ),
      _field(
        type: 'textarea',
        label: 'Description of violation',
        value:
            '<p>A long read-only explanation that must wrap without appearing editable.</p>',
      ),
    ],
  );
}

Widget _host({
  required FormEntity form,
  required Brightness brightness,
  required double textScale,
  required TextDirection direction,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (BuildContext context, Widget? child) {
      return MaterialApp(
        theme: ThemeData(brightness: brightness),
        home: Directionality(
          textDirection: direction,
          child: Builder(
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                ),
                child: Scaffold(
                  body: Column(
                    children: [
                      AppReadHeader(
                        title: 'Form Details',
                        subtitle: form.formName!,
                        onBack: () {},
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: DriverActionNoticeDetails(form: form),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void main() {
  final List<
      ({
        Brightness brightness,
        double textScale,
        Size size,
        TextDirection direction,
      })> scenarios = [
    (
      brightness: Brightness.light,
      textScale: 1,
      size: const Size(300, 640),
      direction: TextDirection.ltr,
    ),
    (
      brightness: Brightness.dark,
      textScale: 2,
      size: const Size(300, 640),
      direction: TextDirection.rtl,
    ),
    (
      brightness: Brightness.light,
      textScale: 3,
      size: const Size(375, 812),
      direction: TextDirection.ltr,
    ),
    (
      brightness: Brightness.dark,
      textScale: 1,
      size: const Size(440, 956),
      direction: TextDirection.ltr,
    ),
    (
      brightness: Brightness.dark,
      textScale: 1.5,
      size: const Size(800, 500),
      direction: TextDirection.rtl,
    ),
    (
      brightness: Brightness.light,
      textScale: 2,
      size: const Size(900, 1200),
      direction: TextDirection.ltr,
    ),
  ];

  for (final scenario in scenarios) {
    testWidgets(
      'renders without overflow — ${scenario.brightness.name}, '
      '${scenario.textScale}x, ${scenario.size.width.toInt()}px, '
      '${scenario.direction.name}',
      (WidgetTester tester) async {
        tester.view.physicalSize = scenario.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final FormEntity form = _form();
        await tester.pumpWidget(
          _host(
            form: form,
            brightness: scenario.brightness,
            textScale: scenario.textScale,
            direction: scenario.direction,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Form Details'), findsOneWidget);
        expect(find.text('Employee Information'), findsOneWidget);
        expect(find.text('Verbal Warning'), findsOneWidget);
        expect(find.text('Written Warning'), findsNothing);
        expect(find.textContaining('<p>'), findsNothing);
      },
    );
  }

  testWidgets('selected values and fallback remain explicit',
      (WidgetTester tester) async {
    final FormEntity form = _form();
    form.formFields!.insert(
      2,
      _field(type: 'string', label: 'Manager', value: ''),
    );

    await tester.pumpWidget(
      _host(
        form: form,
        brightness: Brightness.light,
        textScale: 1,
        direction: TextDirection.ltr,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('N/A'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
    expect(find.textContaining('null'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

// Layout harness for the shared Create Truck and Create Trailer controls.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/create_vehicle_step_scaffold.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/step_navigation_bar.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/vehicle_choice_field.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/vehicle_date_field.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/vehicle_dropdown_field.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/vehicle_form_section.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/create_vehicle/vehicle_text_field.dart';

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
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

void main() {
  final List<TextEditingController> controllers = [];

  TextEditingController makeController([String text = '']) {
    final c = TextEditingController(text: text);
    controllers.add(c);
    return c;
  }

  tearDownAll(() {
    for (final c in controllers) {
      c.dispose();
    }
  });

  Widget buildStep(GlobalKey<FormState> formKey) {
    return CreateVehicleStepScaffold(
      formKey: formKey,
      navigationBar: StepNavigationBar(
        nextLabel: 'Create Truck',
        onNext: () {},
        onBack: () {},
      ),
      sections: [
        VehicleFormSection(
          icon: Icons.local_shipping_rounded,
          title: 'Truck identity',
          children: [
            VehicleTextField(
              label: 'Maker',
              hintText: 'Maker',
              controller: makeController('Freightliner'),
              isRequired: true,
            ),
            VehicleFieldPair(
              first: VehicleTextField(
                label: 'Model',
                hintText: 'Model',
                controller: makeController(),
              ),
              second: VehicleTextField(
                label: 'Year',
                hintText: 'Year',
                controller: makeController(),
              ),
            ),
            VehicleDateField(
              controller: makeController('2026-01-01'),
              label: 'Tags Expire On',
              hint: 'Tags Expire On',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              isRequired: true,
            ),
            VehicleChoiceField<String>(
              label: 'Glider',
              hintText: 'Select glider',
              items: const ['Yes', 'No'],
              selectedItem: 'Yes',
              itemAsString: (item) => item,
              onChanged: (_) {},
            ),
            const VehicleDropdownLoading(),
            VehicleDropdownMessage(
              icon: Icons.error_outline_rounded,
              message: 'Could not load Type options.',
              actionLabel: 'Try again',
              onAction: () {},
              isError: true,
            ),
          ],
        ),
      ],
    );
  }

  for (final brightness in Brightness.values) {
    for (final textScale in <double>[1.0, 1.5, 2.0, 3.0]) {
      for (final size in <Size>[
        const Size(300, 640),
        const Size(375, 812),
        const Size(600, 900),
      ]) {
        for (final direction in TextDirection.values) {
          testWidgets(
            'step renders — ${brightness.name}, scale $textScale, '
            '${size.width.toInt()}px, ${direction.name}',
            (tester) async {
              tester.view.physicalSize = size;
              tester.view.devicePixelRatio = 1.0;
              addTearDown(tester.view.resetPhysicalSize);
              addTearDown(tester.view.resetDevicePixelRatio);

              await tester.pumpWidget(
                _host(
                  brightness: brightness,
                  textScale: textScale,
                  direction: direction,
                  child: buildStep(GlobalKey<FormState>()),
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

  testWidgets('navigation bar renders in RTL and while loading',
      (tester) async {
    await tester.pumpWidget(
      _host(
        brightness: Brightness.dark,
        textScale: 2.0,
        direction: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepNavigationBar(nextLabel: 'Next', onNext: () {}),
            const SizedBox(height: 12),
            StepNavigationBar(
              nextLabel: 'Create Truck',
              onNext: () {},
              onBack: () {},
              isLoading: true,
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/inspection_form/inspection_signature_pad.dart';
import '../../controllers/new_inspection_controller.dart';

/// Signature step of the inspection form. Binds the shared pad to the existing
/// [SignatureController] — the captured points, the PNG export and the Undo
/// action all behave exactly as before.
class SignatureWidget extends GetView<NewInspectionController> {
  const SignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InspectionSignaturePad(
      controller: controller.signatureController,
      helperText: 'Sign inside the box using your finger or a stylus.',
      onUndo: () {
        controller.signatureController.clear();
      },
    );
  }
}

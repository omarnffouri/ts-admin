import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../controllers/create_edit_inventory_controller.dart';
import 'components/create_edit_inventory_header.dart';
import 'components/inventory_form.dart';

class CreateEditInventoryView extends GetView<CreateEditInventoryController> {
  const CreateEditInventoryView({super.key});

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
            const CreateEditInventoryHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: Obx(
                  () => ModalProgressHUD(
                    inAsyncCall: controller.isSubmitting.value,
                    progressIndicator: const SizedBox(),
                    child: const InventoryForm(),
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

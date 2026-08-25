import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../components/shop_form/shop_form_section.dart';
import '../../components/shop_form/shop_text_field.dart';
import '../controllers/create_edit_technician_controller.dart';

class CreateEditTechnicianView extends GetView<CreateEditTechnicianController> {
  const CreateEditTechnicianView({super.key});

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
              () {
                final String action = controller.technicianEntity.value != null
                    ? 'Edit'
                    : 'Create';

                return AppReadHeader(
                  title: '$action Technician',
                  subtitle: 'Shop technician',
                  onBack: Get.back,
                );
              },
            ),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // technician information
                        const _TechnicianInformationSection(),

                        const SizedBox(height: 24),

                        //
                        // create/update technician button
                        Obx(() {
                          final String label =
                              controller.technicianEntity.value != null
                                  ? "Update Technician"
                                  : "Create Technician";
                          return SizedBox(
                            width: double.infinity,
                            child: MainAppButton(
                              label: label,
                              height: 52,
                              borderRadius: 14,
                              isLoading: controller.isSubmitting.value,
                              leadingIcon: const Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () => controller.onSubmit(),
                            ),
                          );
                        })
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

class _TechnicianInformationSection
    extends GetView<CreateEditTechnicianController> {
  const _TechnicianInformationSection();

  @override
  Widget build(BuildContext context) {
    return ShopFormSection(
      icon: Icons.engineering_outlined,
      title: 'Technician Information',
      children: [
        //
        // first name
        ShopTextField(
          fieldKey: controller.firstNameFieldKey,
          controller: controller.firstNameController,
          focusNode: controller.firstNameFocusNode,
          label: 'First Name',
          hintText: 'Enter first name',
          semanticsLabel: 'First name, required',
          isRequired: true,
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(controller.lastNameFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "First name is required";
            }
            return null;
          },
        ),

        //
        // last name
        ShopTextField(
          fieldKey: controller.lastNameFieldKey,
          controller: controller.lastNameController,
          focusNode: controller.lastNameFocusNode,
          label: 'Last Name',
          hintText: 'Enter last name',
          semanticsLabel: 'Last name, required',
          isRequired: true,
          prefixIcon: Icons.badge_outlined,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Last name is required";
            }
            return null;
          },
        ),
      ],
    );
  }
}

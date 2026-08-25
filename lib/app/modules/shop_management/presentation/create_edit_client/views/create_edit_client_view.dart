import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import '../../components/shop_form/shop_form_section.dart';
import '../../components/shop_form/shop_text_field.dart';
import '../controllers/create_edit_client_controller.dart';

class CreateEditClientView extends GetView<CreateEditClientController> {
  const CreateEditClientView({super.key});

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
                final String action =
                    controller.isUpdating.value ? 'Edit' : 'Create';
                final String scope = controller.isUsedPart.value
                    ? 'Used part client'
                    : 'Shop client';

                return AppReadHeader(
                  title: '$action Client',
                  subtitle: scope,
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
                        // client information
                        const _ClientInformationSection(),

                        const SizedBox(height: 20),

                        //
                        // contact information
                        const _ContactInformationSection(),

                        const SizedBox(height: 24),

                        //
                        // create/update client button
                        Obx(() {
                          final String label = controller.isUpdating.value
                              ? "Update Client"
                              : "Create Client";
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

/// Company name, contact person and tax reference — the client's own details.
class _ClientInformationSection extends GetView<CreateEditClientController> {
  const _ClientInformationSection();

  @override
  Widget build(BuildContext context) {
    return ShopFormSection(
      icon: Icons.business_outlined,
      title: 'Client Information',
      children: [
        //
        // company name
        ShopTextField(
          fieldKey: controller.companyNameFieldKey,
          controller: controller.companyNameController,
          focusNode: controller.companyNameFocusNode,
          label: 'Company Name',
          hintText: 'Enter company name',
          semanticsLabel: 'Company name, required',
          isRequired: true,
          prefixIcon: Icons.badge_outlined,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(controller.contactPersonFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Company Name is required";
            }
            return null;
          },
        ),

        //
        // contact person
        ShopTextField(
          fieldKey: controller.contactPersonFieldKey,
          controller: controller.contactPersonController,
          focusNode: controller.contactPersonFocusNode,
          label: 'Contact Person',
          hintText: 'Enter contact person name',
          semanticsLabel: 'Contact person, required',
          isRequired: true,
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(controller.taxReferenceFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Contact Person is required";
            }
            return null;
          },
        ),

        //
        // tax reference
        ShopTextField(
          fieldKey: controller.taxReferenceFieldKey,
          controller: controller.taxReferenceController,
          focusNode: controller.taxReferenceFocusNode,
          label: 'Tax Reference',
          hintText: 'Enter tax reference',
          semanticsLabel: 'Tax reference, required',
          isRequired: true,
          prefixIcon: Icons.receipt_long_outlined,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context)
              .requestFocus(controller.contactNumberFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Tax Reference is required";
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Contact number, email and address — how the client is reached.
class _ContactInformationSection extends GetView<CreateEditClientController> {
  const _ContactInformationSection();

  @override
  Widget build(BuildContext context) {
    return ShopFormSection(
      icon: Icons.contact_phone_outlined,
      title: 'Contact Information',
      children: [
        //
        // contact number
        ShopTextField(
          fieldKey: controller.contactNumberFieldKey,
          controller: controller.contactNumberController,
          focusNode: controller.contactNumberFocusNode,
          label: 'Contact Number',
          hintText: 'Enter contact number',
          semanticsLabel: 'Contact number, required',
          isRequired: true,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(controller.emailFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Contact Number is required";
            }
            return null;
          },
        ),

        //
        // email
        ShopTextField(
          fieldKey: controller.emailFieldKey,
          controller: controller.emailController,
          focusNode: controller.emailFocusNode,
          label: 'Email',
          hintText: 'Enter email address',
          semanticsLabel: 'Email address, required',
          isRequired: true,
          prefixIcon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(controller.addressFocusNode),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Email is required";
            }
            if (!GetUtils.isEmail(p0)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),

        //
        // address — grows with the entered address instead of a fixed box
        ShopTextField(
          fieldKey: controller.addressFieldKey,
          controller: controller.addressController,
          focusNode: controller.addressFocusNode,
          label: 'Address',
          hintText: 'Enter address',
          semanticsLabel: 'Address, required',
          isRequired: true,
          prefixIcon: Icons.location_on_outlined,
          keyboardType: TextInputType.streetAddress,
          minLines: 1,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Address is required";
            }
            return null;
          },
        ),
      ],
    );
  }
}

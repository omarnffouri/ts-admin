import 'package:flutter/material.dart';
import 'package:get/get.dart';
// The redesigned form primitives (persistent label, filled card surface,
// hairline/focus/error borders) shared with the create-edit shop forms.
import 'package:ts_admin/app/modules/shop_management/presentation/components/shop_form/shop_form_section.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/shop_form/shop_text_field.dart';

import '../../controllers/update_profile_controller.dart';
import 'profile_form_fields.dart';

/// First name, last name and phone — the exact three fields the page had
/// before, still bound to the controller's own text controllers.
///
/// No `validator` is attached on purpose: `UpdateProfileController.updateProfile`
/// remains the only validator, so the rules and messages stay identical. No
/// input formatters are attached either, so phone input (leading zeros, country
/// codes, spaces) reaches the API exactly as it did.
class ProfileInformationSection extends GetView<UpdateProfileController> {
  const ProfileInformationSection({super.key, required this.fields});

  final ProfileFormFields fields;

  @override
  Widget build(BuildContext context) {
    return ShopFormSection(
      icon: Icons.person_outline_rounded,
      title: 'Personal Information',
      children: [
        //
        // first name
        ShopTextField(
          fieldKey: fields.firstNameKey,
          controller: controller.firstNameController,
          focusNode: fields.firstNameFocusNode,
          label: 'First Name',
          hintText: 'Enter first name',
          semanticsLabel: 'First name, required',
          isRequired: true,
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(fields.lastNameFocusNode),
        ),

        //
        // last name — allowed to wrap so long names are never clipped
        ShopTextField(
          fieldKey: fields.lastNameKey,
          controller: controller.lastNameController,
          focusNode: fields.lastNameFocusNode,
          label: 'Last Name',
          hintText: 'Enter last name',
          semanticsLabel: 'Last name, required',
          isRequired: true,
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          minLines: 1,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(fields.phoneFocusNode),
        ),

        //
        // phone
        ShopTextField(
          fieldKey: fields.phoneKey,
          controller: controller.phoneController,
          focusNode: fields.phoneFocusNode,
          label: 'Phone Number',
          hintText: 'Enter phone number',
          semanticsLabel: 'Phone number, required',
          isRequired: true,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
        ),
      ],
    );
  }
}

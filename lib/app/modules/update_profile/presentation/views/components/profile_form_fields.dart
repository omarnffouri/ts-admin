import 'package:flutter/material.dart';

/// Focus nodes and field keys for the three personal-information inputs.
///
/// Owned by the page's state object — never created inside `build` — so focus,
/// keyboard traversal and scroll-to-field survive rebuilds. The
/// [TextEditingController]s deliberately stay owned by
/// `UpdateProfileController`; only these view-level nodes live here.
class ProfileFormFields {
  final GlobalKey<FormFieldState<String>> firstNameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> lastNameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> phoneKey =
      GlobalKey<FormFieldState<String>>();

  final FocusNode firstNameFocusNode = FocusNode(debugLabel: 'firstName');
  final FocusNode lastNameFocusNode = FocusNode(debugLabel: 'lastName');
  final FocusNode phoneFocusNode = FocusNode(debugLabel: 'phone');

  void dispose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    phoneFocusNode.dispose();
  }
}

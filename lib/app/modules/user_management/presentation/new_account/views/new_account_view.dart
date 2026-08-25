import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/dropdown.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/data_entity.dart';
import '../controllers/new_account_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../widgets/off_days_section.dart';

class NewAccountView extends GetView<NewAccountController> {
  const NewAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Column(
        children: [
          //
          // app header
          const _Header(),

          //
          //
          // body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    //
                    // personal information
                    _FormSection(
                      title: "Personal Information",
                      children: [
                        RoundedInputField(
                          label: "First Name",
                          hintText: "first name",
                          controller: controller.firstName,
                          isRequired: true,
                          keyboardType: TextInputType.name,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "First name is required";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Last Name",
                          hintText: "last name",
                          controller: controller.lastName,
                          isRequired: true,
                          keyboardType: TextInputType.name,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Last name is required";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Email",
                          hintText: "abc@gmail.com",
                          controller: controller.email,
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Email is required";
                            }
                            if (!GetUtils.isEmail(p0)) {
                              return "Invalid email";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Password",
                          hintText: "*********",
                          controller: controller.password,
                          isRequired: true,
                          passwordView: true,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Password is required";
                            }
                            if (p0.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Phone",
                          hintText: "0123456789",
                          controller: controller.phone,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          maxLength: 13,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Phone number is required";
                            }
                            if (p0.length < 10 || p0.length > 13) {
                              return "Phone number must be 10 to 13 digits";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Birth Date",
                          hintText: "21-05-1898",
                          controller: controller.dateOfBirth,
                          readOnly: true,
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: theme.copyWith(
                                      colorScheme: theme.colorScheme.copyWith(
                                        primary: Colors.redAccent,
                                        onSurface: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.red, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('MM-dd-yyyy').format(pickedDate);
                                controller.dateOfBirth.text = formattedDate;
                              }
                            },
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 25,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ),
                          ),
                        ).marginOnly(top: 14),
                      ],
                    ),

                    const SizedBox(height: 16),

                    //
                    //
                    // employment details
                    _FormSection(
                      title: "Employment Details",
                      children: [
                        RoundedInputField(
                          label: "Joining Date",
                          hintText: "21-05-1898",
                          controller: controller.joiningDate,
                          readOnly: true,
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: theme.copyWith(
                                      colorScheme: theme.colorScheme.copyWith(
                                        primary: Colors.redAccent,
                                        onSurface: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.red, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('MM-dd-yyyy').format(pickedDate);
                                controller.joiningDate.text = formattedDate;
                              }
                            },
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 25,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ),
                          ),
                        ).marginOnly(top: 14),
                        RoundedInputField(
                          label: "Employee Number",
                          hintText: "0123456789",
                          controller: controller.employNumber,
                          keyboardType: TextInputType.number,
                          validator: (p0) {
                            return null;
                          },
                        ).marginOnly(top: 14),
                        Obx(
                          () => controller.isLoadingCountries.value
                              ? buildOptionsLoadingView()
                              : controller.errorWhileLoadingCountries.value
                                  ? buildOptionRetryButtonView(
                                      const Text("Something went wrong..."),
                                      GestureDetector(
                                        onTap: () {
                                          controller.getAllCountries();
                                        },
                                        child: const Text(
                                          "try again",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : controller.countries.isEmpty
                                      ? buildOptionRetryButtonView(
                                          const Text("No country found..."),
                                          GestureDetector(
                                            onTap: () {
                                              controller.getAllCountries();
                                            },
                                            child: const Text(
                                              "refesh",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: DropDown<DataEntity>(
                                            listItems: controller.countries
                                                .map(
                                                  (e) => DropdownMenuItem<
                                                      DataEntity>(
                                                    value: e,
                                                    child: Text(e.name ?? ""),
                                                  ),
                                                )
                                                .toList(),
                                            hint: "Select country",
                                            selectedValue: controller
                                                .selectedCountries.value,
                                            onChange: (value) {
                                              //
                                              controller.selectedCountries
                                                  .value = value;
                                              controller.selectedCountries
                                                  .refresh();
                                            },
                                          ),
                                        ).marginOnly(top: 14),
                        ),
                        RoundedInputField(
                          label: "Address",
                          hintText: "state, street 00 etc",
                          controller: controller.address,
                          isRequired: true,
                          keyboardType: TextInputType.streetAddress,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Address is required";
                            }
                            return null;
                          },
                        ).marginOnly(top: 14),
                        Obx(
                          () => controller.isLoadingSupervisor.value
                              ? buildOptionsLoadingView()
                              : controller.errorWhileLoadingSupervisor.value
                                  ? buildOptionRetryButtonView(
                                      const Text("Something went wrong..."),
                                      GestureDetector(
                                        onTap: () {
                                          controller.getAllSupervisors();
                                        },
                                        child: const Text(
                                          "try again",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : controller.supervisors.isEmpty
                                      ? buildOptionRetryButtonView(
                                          const Text("No supervisor found..."),
                                          GestureDetector(
                                            onTap: () {
                                              controller.getAllSupervisors();
                                            },
                                            child: const Text(
                                              "refesh",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: SearchableDropDown<DataEntity>(
                                            list: controller.supervisors,
                                            bottomSheetLabel:
                                                'Select supervisor',
                                            searchHint: 'search by name',
                                            fieldLabel: 'Select supervisor',
                                            fieldHint: 'Select supervisor',
                                            isRequired: false,
                                            showOnlyLetters: true,
                                            getName: (p0) => p0.name ?? "",
                                            getImage: (p0) => p0.name ?? "",
                                            selectedItem: controller
                                                .selectedSupervisor.value,
                                            dropdownSearchDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            dropdownDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            onItemSelected: (DataEntity? item) {
                                              if (item != null) {
                                                controller.selectedSupervisor
                                                    .value = item;
                                              }
                                            },
                                            itemAsString: (item) {
                                              return item.name ?? '';
                                            },
                                            compareFunction: (item_1, item_2) {
                                              return item_1 == item_2;
                                            },
                                          ),
                                        ).marginOnly(top: 14),
                        ),
                        Obx(
                          () => controller.isLoadingDepartments.value
                              ? buildOptionsLoadingView()
                              : controller.errorWhileLoadingDepartments.value
                                  ? buildOptionRetryButtonView(
                                      const Text("Something went wrong..."),
                                      GestureDetector(
                                        onTap: () {
                                          controller.getAllDepartments();
                                        },
                                        child: const Text(
                                          "try again",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : controller.departments.isEmpty
                                      ? buildOptionRetryButtonView(
                                          const Text("No department found..."),
                                          GestureDetector(
                                            onTap: () {
                                              controller.getAllDepartments();
                                            },
                                            child: const Text(
                                              "refesh",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: SearchableDropDown<DataEntity>(
                                            list: controller.departments,
                                            bottomSheetLabel:
                                                'Select department',
                                            searchHint: 'search by name',
                                            fieldLabel: 'Select department',
                                            fieldHint: 'Select department',
                                            isRequired: false,
                                            showOnlyLetters: true,
                                            getName: (p0) => p0.name ?? "",
                                            getImage: (p0) => p0.name ?? "",
                                            selectedItem: controller
                                                .selectedDepartment.value,
                                            dropdownSearchDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            dropdownDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            onItemSelected: (DataEntity? item) {
                                              if (item != null) {
                                                controller.selectedDepartment
                                                    .value = item;
                                              }
                                            },
                                            itemAsString: (item) {
                                              return item.name ?? '';
                                            },
                                            compareFunction: (item_1, item_2) {
                                              return item_1 == item_2;
                                            },
                                          ),
                                        ).marginOnly(top: 14),
                        ),
                        Obx(
                          () => controller.isLoadingDesignations.value
                              ? buildOptionsLoadingView()
                              : controller.errorWhileLoadingDesignations.value
                                  ? buildOptionRetryButtonView(
                                      const Text("Something went wrong..."),
                                      GestureDetector(
                                        onTap: () {
                                          controller.getAllDesignations();
                                        },
                                        child: const Text(
                                          "try again",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : controller.departments.isEmpty
                                      ? buildOptionRetryButtonView(
                                          const Text(
                                              "No desigination found..."),
                                          GestureDetector(
                                            onTap: () {
                                              controller.getAllDesignations();
                                            },
                                            child: const Text(
                                              "refesh",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: SearchableDropDown<DataEntity>(
                                            list: controller.designations,
                                            bottomSheetLabel:
                                                'Select designation',
                                            searchHint: 'search by name',
                                            fieldLabel: 'Select designation',
                                            fieldHint: 'Select designation',
                                            isRequired: false,
                                            showOnlyLetters: true,
                                            getName: (p0) => p0.name ?? "",
                                            getImage: (p0) => "",
                                            selectedItem: controller
                                                .selectedDesignation.value,
                                            dropdownSearchDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            dropdownDecoration:
                                                SearchableDropdownDecoration
                                                    .bordered,
                                            onItemSelected: (DataEntity? item) {
                                              if (item != null) {
                                                controller.selectedDesignation
                                                    .value = item;
                                              }
                                            },
                                            itemAsString: (item) {
                                              return item.name ?? '';
                                            },
                                            compareFunction: (item_1, item_2) {
                                              return item_1 == item_2;
                                            },
                                          ),
                                        ).marginOnly(top: 14),
                        ),
                        OffDaysSection(
                          isLoading: controller.isLoadingUserOffDays,
                          hasError: controller.errorWhileLoadingUserOffDays,
                          offDays: controller.userOffDays,
                          selectedOffDays: controller.selectedUserOffDays,
                          enableDisableOptions: controller.enableDisableOffDays,
                          selectedEnableOption:
                              controller.selectedEnableOffDays,
                          onRetry: controller.getAllUserOffDays,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    //
                    //
                    // roles & access
                    _FormSection(
                      title: "Roles & Access",
                      children: [
                        Obx(
                          () => controller.isLoadingRoles.value
                              ? buildRolesLoadingView()
                              : controller.errorWhileLoadingRoles.value
                                  ? buildOptionRetryButtonView(
                                      const Text("Something went wrong..."),
                                      GestureDetector(
                                        onTap: () {
                                          controller.getAllRoles();
                                        },
                                        child: const Text(
                                          "try again",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  : controller.departments.isEmpty
                                      ? buildOptionRetryButtonView(
                                          const Text("No role found..."),
                                          GestureDetector(
                                            onTap: () {
                                              controller.getAllRoles();
                                            },
                                            child: const Text(
                                              "refesh",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      : GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                            mainAxisExtent: 60,
                                          ),
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: controller.roles.length,
                                          itemBuilder: (context, index) {
                                            final role =
                                                controller.roles[index];
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                child: CheckboxListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 10,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  title: Text(
                                                    role.name
                                                            ?.capitalizeFirst ??
                                                        "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                  activeColor:
                                                      AppColorsLight.mainColor,
                                                  checkColor: Colors.white,
                                                  value: role.isSelected,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .platform,
                                                  onChanged: (value) {
                                                    role.isSelected =
                                                        !role.isSelected;
                                                    controller.roles.refresh();
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: MainAppButton(
                          label: 'Create',
                          height: 52,
                          borderRadius: 14,
                          isLoading: controller.isSubmitting.value,
                          leadingIcon: const Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.createAdmin();
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsLoadingView() {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildRolesLoadingView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 60,
      ),
      primary: false,
      shrinkWrap: true,
      itemCount: 15,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white30,
          child: CheckboxListTile(
            title: Text(
              "Role",
              style: Get.theme.textTheme.bodyMedium,
            ),
            activeColor: AppColorsLight.mainColor,
            checkColor: Colors.white,
            value: true,
            controlAffinity: ListTileControlAffinity.platform,
            onChanged: (value) {},
          ),
        );
      },
    );
  }

  Widget buildOptionRetryButtonView(Text message, Widget button) {
    return SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: message,
            ),
            button
          ],
        ).marginOnly(top: 14));
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.08)
              : const Color(0xFFEDEDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.applyOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _Header extends GetView<NewAccountController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(12, topInset + 12, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              "Create User",
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

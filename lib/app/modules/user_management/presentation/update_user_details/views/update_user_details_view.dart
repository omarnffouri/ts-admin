import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/dropdown.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/data_entity.dart';

import '../controllers/update_user_details_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../widgets/off_days_section.dart';

class UpdateUserDetailsView extends GetView<UpdateUserDetailsController> {
  const UpdateUserDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;
    // Color primaryColorDark = theme.primaryColorDark;
    // Color primaryColorLight = theme.primaryColorLight;
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    // Color cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              //
              // app header
              const _Header(),

              //
              //
              // body
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        //
                        //
                        //
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
                        ).marginOnly(top: 20),

                        //
                        //
                        //
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
                        ).marginOnly(top: 12),

                        //
                        //
                        //
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
                        ).marginOnly(top: 12),

                        //
                        //
                        //
                        RoundedInputField(
                          label: "Phone",
                          hintText: "0123456789",
                          controller: controller.phone,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Phone number is required";
                            }
                            if (p0.length < 10) {
                              return "Invalid phone number";
                            }
                            return null;
                          },
                        ).marginOnly(top: 12),

                        RoundedInputField(
                          label: "Joining Date",
                          hintText: "05-15-1898",
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
                        ).marginOnly(top: 12),

                        //
                        //
                        //
                        RoundedInputField(
                          label: "Birth Date",
                          hintText: "05-22-1898",
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
                        ).marginOnly(top: 12),

                        //
                        //
                        //
                        RoundedInputField(
                          label: "Employee Number",
                          hintText: "0123456789",
                          controller: controller.employNumber,
                          keyboardType: TextInputType.number,
                          validator: (p0) {
                            return null;
                          },
                        ).marginOnly(top: 12),

                        //
                        //
                        //
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
                                                .selectedCountry.value,
                                            onChange: (value) {
                                              //
                                              controller.selectedCountry.value =
                                                  value;
                                              controller.selectedCountry
                                                  .refresh();
                                            },
                                          ),
                                        ).marginOnly(top: 12),
                        ),

                        //
                        //
                        //
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
                        ).marginOnly(top: 12),

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
                                        ).marginOnly(top: 12),
                        ),

                        //
                        //
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
                                          child: DropDown<DataEntity>(
                                            listItems: controller.departments
                                                .map(
                                                  (e) => DropdownMenuItem<
                                                      DataEntity>(
                                                    value: e,
                                                    child: Text(e.name ?? ""),
                                                  ),
                                                )
                                                .toList(),
                                            hint: "Select department",
                                            selectedValue: controller
                                                .selectedDepartment.value,
                                            onChange: (value) {
                                              //
                                              debugPrint(
                                                  "selected department: ${value?.id}");
                                              controller.selectedDepartment
                                                  .value = value;
                                              controller.selectedDepartment
                                                  .refresh();
                                            },
                                          ),
                                        ).marginOnly(top: 12),
                        ),

                        //
                        //
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
                                          child: DropDown<DataEntity>(
                                            listItems: controller.designations
                                                .map(
                                                  (e) => DropdownMenuItem<
                                                      DataEntity>(
                                                    value: e,
                                                    child: Text(e.name ?? ""),
                                                  ),
                                                )
                                                .toList(),
                                            hint: "Select desigination",
                                            selectedValue: controller
                                                .selectedDesignation.value,
                                            onChange: (value) {
                                              //
                                              controller.selectedDesignation
                                                  .value = value;
                                              controller.selectedDesignation
                                                  .refresh();
                                            },
                                          ),
                                        ).marginOnly(top: 12),
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

                        //
                        //
                        //
                        // roles heading
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Roles",
                              style: theme.textTheme.titleLarge,
                            )
                          ],
                        ).marginOnly(top: 16, left: 10),

                        //
                        //
                        //
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
                                            mainAxisSpacing: 0,
                                            mainAxisExtent: 50,
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

                        //
                        //
                        // submit button
                        Obx(
                          () => controller.isSubmitting.value
                              ? const CircularProgressIndicator(
                                  color: AppColorsLight.mainColor,
                                )
                              : MainAppButton(
                                  label: "Update",
                                  onPressed: () {
                                    controller.updateAdmin();
                                  },
                                ),
                        ).marginSymmetric(vertical: 20),
                      ],
                    ),
                  ),
                ).marginOnly(left: 12, right: 12),
              ),
            ],
          ),
        ),
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
        margin: const EdgeInsets.only(top: 12),
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
        mainAxisSpacing: 0,
        mainAxisExtent: 50,
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
        ).marginOnly(top: 12));
  }
}

class _Header extends GetView<UpdateUserDetailsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ).paddingOnly(right: 10),

          //
          //
          //
          Expanded(
            child: Row(
              children: [
                Text(
                  "Update User",
                  maxLines: 1,
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/data_entity.dart';
import '../../../domain/entities/rule_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_all_countries_usecase.dart';
import '../../../domain/usecases/get_all_departments_usecase.dart';
import '../../../domain/usecases/get_all_designations_usecase.dart';
import '../../../domain/usecases/get_all_rules_usecase.dart';
import '../../../domain/usecases/get_all_supervisors_usecase.dart';
import '../../../domain/usecases/get_user_off_days_usecase.dart';
import '../../../domain/usecases/update_admin_request_usecase.dart';
import '../../all_user/controllers/all_user_controller.dart';

class UpdateUserDetailsController extends GetxController {
  // usecases
  final getAllRulesUsecase = sl<GetAllRulesUsecase>();
  final getAllSupervisorsUsecase = sl<GetAllSupervisorsUsecase>();
  final getAllCountriesUsecase = sl<GetAllCountriesUsecase>();
  final getAllDepartmentsUsecase = sl<GetAllDepartmentsUsecase>();
  final getAllDesignationsUsecase = sl<GetAllDesignationsUsecase>();
  final getUserOffDaysUsecase = sl<GetUserOffDaysUsecase>();
  final updateAdminUsecase = sl<UpdateAdminUsecase>();

  // variables
  final Rxn<UserEntity> userDetails = Rxn<UserEntity>();
  final RxList<RuleEntity> roles = <RuleEntity>[].obs;
  final RxList<DataEntity> countries = <DataEntity>[].obs;
  final RxList<DataEntity> supervisors = <DataEntity>[].obs;
  final RxList<DataEntity> departments = <DataEntity>[].obs;
  final RxList<DataEntity> designations = <DataEntity>[].obs;
  final RxList<DataEntity> userOffDays = <DataEntity>[].obs;
  final RxList<DataEntity> enableDisableOffDays = <DataEntity>[
    const DataEntity(id: "0", name: "Disable"),
    const DataEntity(id: "1", name: "Enable"),
  ].obs;

  //
  //
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController joiningDate = TextEditingController();
  final TextEditingController employNumber = TextEditingController();
  final TextEditingController address = TextEditingController();

  // add form key
  final formKey = GlobalKey<FormState>();

  //
  //
  // countries states
  final RxBool isLoadingCountries = false.obs;
  final RxBool errorWhileLoadingCountries = false.obs;
  final Rxn<DataEntity> selectedCountry = Rxn();

  // Supervisor states
  final RxBool isLoadingSupervisor = false.obs;
  final RxBool errorWhileLoadingSupervisor = false.obs;
  final Rxn<DataEntity> selectedSupervisor = Rxn();

  //
  // departments states
  final RxBool isLoadingDepartments = false.obs;
  final RxBool errorWhileLoadingDepartments = false.obs;
  final Rxn<DataEntity> selectedDepartment = Rxn();

  //
  // designations states
  final RxBool isLoadingDesignations = false.obs;
  final RxBool errorWhileLoadingDesignations = false.obs;
  final Rxn<DataEntity> selectedDesignation = Rxn();

  //
  // user off days states
  final RxBool isLoadingUserOffDays = false.obs;
  final RxBool errorWhileLoadingUserOffDays = false.obs;
  final RxList<DataEntity> selectedUserOffDays = <DataEntity>[].obs;

  final Rxn<DataEntity> selectedEnableOffDays = Rxn();

  //
  // rules states
  final RxBool isLoadingRoles = false.obs;
  final RxBool errorWhileLoadingRoles = false.obs;

  // submit button state
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      userDetails.value = args as UserEntity;
    }

    Future.wait([
      getAllRoles(),
      getAllCountries(),
      getAllSupervisors(),
      getAllDepartments(),
      getAllDesignations(),
      getAllUserOffDays(),
    ]);

    setOldDataToView();
  }

  setOldDataToView() {
    if (userDetails.value != null) {
      firstName.text = userDetails.value!.firstName != "null"
          ? (userDetails.value!.firstName ?? "")
          : "";
      lastName.text = userDetails.value!.lastName != "null"
          ? (userDetails.value!.lastName ?? "")
          : "";
      email.text = userDetails.value!.email != "null"
          ? (userDetails.value!.email ?? "")
          : "";
      phone.text = userDetails.value!.phone != "null"
          ? (userDetails.value!.phone ?? "")
          : "";
      dateOfBirth.text = userDetails.value!.birthDate != "null"
          ? (userDetails.value!.birthDate ?? "")
          : "";
      employNumber.text = userDetails.value!.emplyeeNumber != "null"
          ? (userDetails.value!.emplyeeNumber ?? "")
          : "";
      address.text = userDetails.value!.address != "null"
          ? (userDetails.value!.address ?? "")
          : "";

      joiningDate.text = userDetails.value!.joiningDate != "null"
          ? (userDetails.value!.joiningDate ?? "")
          : "";

      final isOffDaysEnabled = userDetails.value?.offDaysEnabled;
      selectedEnableOffDays.value = isOffDaysEnabled == true
          ? enableDisableOffDays.firstWhere((e) => e.id == "1")
          : enableDisableOffDays.firstWhere((e) => e.id == "0");
    }
  }

  Future<void> getAllRoles() async {
    roles.clear();
    isLoadingRoles(true);
    errorWhileLoadingRoles(false);
    try {
      final response = await getAllRulesUsecase.call(const NoParams());
      response.fold(
        (List<RuleEntity> data) {
          roles.addAll(data);
          //
          // setting the previous selected roles
          for (var role in roles) {
            role.isSelected = (userDetails.value?.roles
                    ?.firstWhereOrNull((element) => element.id == role.id) !=
                null);
          }
          debugPrint("getAllRules length ${data.length}");
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingRoles(true);
        },
      );
      isLoadingRoles(false);
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      isLoadingRoles(false);
      errorWhileLoadingRoles(true);
    }
  }

  Future<void> getAllCountries() async {
    countries.clear();
    isLoadingCountries(true);
    errorWhileLoadingCountries(false);
    try {
      final response = await getAllCountriesUsecase.call(const NoParams());
      response.fold(
        (List<DataEntity> data) {
          countries.addAll(data);
          debugPrint("getAllCountries length ${data.length}");

          // setting previous selected country
          if (userDetails.value?.country != null) {
            selectedCountry.value = data.firstWhereOrNull(
              (element) => element.id == userDetails.value!.country!.id,
            );
          }
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingCountries(true);
        },
      );
      isLoadingCountries(false);
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      isLoadingCountries(false);
      errorWhileLoadingCountries(true);
    }
  }

  Future<void> getAllSupervisors() async {
    isLoadingSupervisor.value = true;
    errorWhileLoadingSupervisor.value = false;
    try {
      final response = await getAllSupervisorsUsecase.call(const NoParams());
      response.fold(
        (List<DataEntity> data) {
          supervisors.value = data;
          debugPrint("getAllSupervisors length ${data.length}");
          // setting previous selected supervisor
          if (userDetails.value?.supervisorId != null) {
            selectedSupervisor.value = data.firstWhereOrNull(
              (element) =>
                  element.id == userDetails.value!.supervisorId.toString(),
            );
          }
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingSupervisor.value = true;
        },
      );
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      errorWhileLoadingSupervisor.value = true;
    } finally {
      isLoadingSupervisor.value = false;
    }
  }

  Future<void> getAllDepartments() async {
    departments.clear();
    isLoadingDepartments(true);
    errorWhileLoadingDepartments(false);
    try {
      final response = await getAllDepartmentsUsecase.call(const NoParams());
      response.fold(
        (List<DataEntity> data) {
          departments.addAll(data);

          //
          // setting previous selected department
          if (userDetails.value?.department != null) {
            selectedDepartment.value = data.firstWhereOrNull(
              (element) => element.id == userDetails.value!.department!.id,
            );
          }
          debugPrint("getAllDepartments length ${data.length}");
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingDepartments(true);
        },
      );
      isLoadingDepartments(false);
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      isLoadingDepartments(false);
      errorWhileLoadingDepartments(true);
    }
  }

  Future<void> getAllDesignations() async {
    designations.clear();
    isLoadingDesignations(true);
    errorWhileLoadingDesignations(false);
    try {
      final response = await getAllDesignationsUsecase.call(const NoParams());
      response.fold(
        (List<DataEntity> data) {
          designations.addAll(data);

          //
          // setting previous selected designation
          if (userDetails.value?.designation != null) {
            selectedDesignation.value = data.firstWhereOrNull(
              (element) => element.id == userDetails.value!.designation!.id,
            );
          }
          debugPrint("getAllDesignations length ${data.length}");
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingDesignations(true);
        },
      );
      isLoadingDesignations(false);
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      isLoadingDesignations(false);
      errorWhileLoadingDesignations(true);
    }
  }

  Future<void> getAllUserOffDays() async {
    isLoadingUserOffDays.value = true;
    errorWhileLoadingUserOffDays.value = false;
    try {
      final response = await getUserOffDaysUsecase.call(const NoParams());
      response.fold(
        (List<DataEntity> data) {
          userOffDays.value = data;
          debugPrint("getAllUserOffDays length ${data.length}");
          // setting previous selected user off days
          if (userDetails.value?.offDays != null) {
            for (var offDay in userDetails.value!.offDays!) {
              final selectedOffDay = data.firstWhereOrNull(
                (element) => element.id == offDay.toString(),
              );
              if (selectedOffDay != null) {
                selectedUserOffDays.add(selectedOffDay);
              }
            }
          }
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingUserOffDays.value = true;
        },
      );
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      errorWhileLoadingUserOffDays.value = true;
    } finally {
      isLoadingUserOffDays.value = false;
    }
  }

  Future<void> updateAdmin() async {
    try {
      // validate form
      if (selectedDepartment.value == null) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Please select department",
          isError: true,
        );
        return;
      }

      if (selectedDesignation.value == null) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Please select designation",
          isError: true,
        );
        return;
      }

      // validate form
      if (!formKey.currentState!.validate()) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Please fill all fields correctly",
          isError: true,
        );
        return;
      }

      final List<int> selectedRoles = roles
          .where((element) => element.isSelected)
          .map((e) => int.parse(e.id.toString()))
          .toList();

      if (selectedRoles.isEmpty) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: "Please select at least one role.",
          isError: true,
        );
        return;
      }

      final body = {
        "id": userDetails.value?.id,
        "first_name": firstName.text,
        "last_name": lastName.text,
        "email": email.text,
        "phone": phone.text,
        "birth_date": dateOfBirth.text,
        "joining_date": joiningDate.text,
        "off_days_enabled": selectedEnableOffDays.value?.id,
        "off_days": selectedUserOffDays
            .map((e) => int.tryParse(e.id.toString()))
            .whereType<int>()
            .toList(),
        "supervisor_id": selectedSupervisor.value?.id.toString(),
        "employee_number": employNumber.text,
        "address": address.text,
        "timezone": "America/New_York",
        "department_id": selectedDepartment.value?.id.toString(),
        "designation_id": selectedDesignation.value?.id.toString(),
        "country_id": selectedCountry.value?.id.toString(),
        "roles": selectedRoles,
      };
      debugPrint("update admin body $body");
      isSubmitting(true);
      final response = await updateAdminUsecase.call(body);
      response.fold(
        (r) {
          CommonWidgets.showSnackBar(
            title: "Success",
            message: "Account Updated successfully",
            isError: false,
          );
          //todo update the user
          Get.find<AllUserController>().getAllUsers();
          //
          Navigator.pop(Get.context!);
        },
        (r) {
          debugPrint(r.message);
          CommonWidgets.showSnackBar(
            title: "Error",
            message: r.message,
            isError: true,
          );
        },
      );
      isSubmitting(false);
    } catch (e) {
      isSubmitting(false);
      debugPrint('Something went wrong ${e.toString()}');
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Something went wrong, try again later",
        isError: true,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/hr_attachments_manager.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/address_information_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_data_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/document_request_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/driving_license_information_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/inspection_request_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/personal_infomation_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/requested_document_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/statuses_history_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/usecases/get_application_details_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ApplicationDetailViewController extends GetxController
    implements TickerProvider {
  final RxnInt applicationId = RxnInt();

  late TabController personalTabController;

  final Rx<AddressTabs> currentTab = AddressTabs.present.obs;

  //
  //
  // refesh controllers
  RefreshController personalRefreshController = RefreshController();
  RefreshController overViewRefreshController = RefreshController();
  RefreshController licenseRefreshController = RefreshController();
  RefreshController roadTestRefreshController = RefreshController();
  RefreshController formsRefreshController = RefreshController();
  RefreshController documentsRefreshController = RefreshController();

  //
  //
  // usecases
  final getApplicationDetailsUsecase = sl<GetApplicationDetailsUsecase>();

  //
  //
  // data variables
  final Rxn<ApplicationDataEntity> application = Rxn();
  final Rxn<PersonalInformationEntity> personalInformation = Rxn();
  final Rxn<AddressInformationEntity> addressInformation = Rxn();
  final Rxn<DrivingLicenseInformationEntity> drivingLicenseInformation = Rxn();
  final requestedDocuments = RxList<RequestedDocumentEntity>();
  final RxList<StatusesHistoryEntity> statusesHistory = RxList();
  final RxList<RoadTestInspectionEntity> roadTests = RxList();
  final RxList<FormEntity> froms = RxList();
  final RxList<DocumentRequestEntity> documentRequests = RxList();

  final hrAttachmentsManager = Get.find<HrAttachmentsManager>();

  //
  //
  // states
  final RxBool _isLaodingApplicationDetails = false.obs;
  bool get isLaodingApplicationDetails => _isLaodingApplicationDetails.value;

  final RxBool _errorWhileLoadingApplicationDetails = false.obs;
  bool get errorWhileLoadingApplicationDetails =>
      _errorWhileLoadingApplicationDetails.value;

  @override
  void onInit() {
    personalTabController = TabController(length: 2, vsync: this);

    personalTabController.addListener(() {
      if (personalTabController.index == 0) {
        currentTab(AddressTabs.present);
      } else if (personalTabController.index == 1) {
        currentTab(AddressTabs.previous);
      }
    });

    try {
      final args = Get.arguments;
      if ((args != null) && (args is int)) {
        applicationId.value = args;
        _getApplicationDetails();
      }
    } catch (_) {}

    super.onInit();
  }

  handleRefresh() async {
    if (isLaodingApplicationDetails) {
      return;
    }
    _getApplicationDetails();
  }

  _getApplicationDetails() async {
    try {
      _deleteDocumentsRequestsFiles();

      _errorWhileLoadingApplicationDetails.value = false;
      _isLaodingApplicationDetails.value = true;

      debugPrint("Application ID: ${applicationId.value}");

      final response =
          await getApplicationDetailsUsecase.call(applicationId.value!);
      response.fold((BaseResponse<ApplicationDataEntity> data) {
        //
        //
        // if have data then set it to variables
        if (data.data != null) {
          _processData(data.data!);
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message:
                "Something went wrong while loading the application details.",
          );
          _errorWhileLoadingApplicationDetails.value = true;
        }

        _isLaodingApplicationDetails.value = false;
      }, (failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message.isNotEmpty
              ? failure.message
              : "Unable to load application details.",
        );
        _errorWhileLoadingApplicationDetails.value = true;
        _isLaodingApplicationDetails.value = false;
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Unable to load application details.",
      );
      _errorWhileLoadingApplicationDetails.value = true;
      _isLaodingApplicationDetails.value = false;
    }
  }

  _processData(ApplicationDataEntity data) {
    //
    application.value = data;
    personalInformation.value = data.personalInformation;
    addressInformation.value = data.addressInformation;
    drivingLicenseInformation.value = data.drivingLicenseInformation;
    requestedDocuments.value = data.requestedDocuments ?? [];
    statusesHistory.value = data.statusesHistory ?? [];
    roadTests.value = data.inspectionRequests ?? [];
    froms.value = data.applicationForms ?? [];
    documentRequests.value = data.documentRequests ?? [];
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  openFile(ApplicationFileEntity? file) async {
    if (file == null) {
      return;
    }

    if ((file.url ?? "").isEmpty) {
      return;
    }

    try {
      if (file.isDownloading.value) {
        return;
      }

      final fileUrl = file.url!;

      final filePath = await hrAttachmentsManager.getAttachmentFile(
        fileUrl,
        onReceiveProgress: (received, total) {
          file.isDownloading.value = true;
          file.downloadProgress.value = received / total;
        },
        onFailure: (message) {
          CommonWidgets.showSnackBar(title: "Error", message: message);
        },
      );

      //
      //
      // resetting download progress states
      file.isDownloading.value = false;
      file.downloadProgress.value = 0.0;

      //
      // if got file successfully then open it
      if (filePath != null) {
        file.filePath.value = filePath;
        await FileOpener.openFile(filePath);
      }
    } catch (_) {
      file.isDownloading.value = false;
      file.downloadProgress.value = 0.0;
    }
  }

  _deleteDocumentsRequestsFiles() async {
    if (documentRequests.isNotEmpty) {
      for (var item in documentRequests) {
        try {
          if (item.file != null) {
            if (item.file!.filePath.value.isNotEmpty) {
              await hrAttachmentsManager.deleteFile(
                hrAttachmentsManager.getFileName(
                  item.file!.filePath.value,
                  withExtension: true,
                ),
              );
            }
          }
        } catch (_) {}
      }
    }
  }

  @override
  void onClose() {
    _deleteDocumentsRequestsFiles();
    super.onClose();
  }
}

enum AddressTabs { present, previous }

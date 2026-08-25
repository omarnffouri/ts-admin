import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/assets_attachments_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/confirmation_bottom_sheet.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../domain/entities/device_type_entity.dart';
import '../../../domain/entities/vehicle_document.dart';
import '../../../domain/entities/vehicle_file.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/selected_device_entity.dart';
import '../../../domain/entities/teams_entity.dart';
import '../../../domain/entities/vehicle_details_entity.dart';
import '../../../domain/entities/truck_entity.dart';
import '../../../domain/usecases/add_new_note_usecase.dart';
import '../../../domain/usecases/create_new_documents_usecase.dart';
import '../../../domain/usecases/delete_truck_document_usecase.dart';
import '../../../domain/usecases/get_all_teams_usecase.dart';
import '../../../domain/usecases/get_truck_details_usecase.dart';
import '../../../domain/usecases/get_device_types_usecase.dart';
import '../../../domain/usecases/get_device_type_serials_usecase.dart';
import '../../../domain/usecases/install_new_device_usecase.dart';
import '../../../domain/usecases/uninstall_device_usecase.dart';
import '../../../domain/usecases/update_document_expiration_usecase.dart';
import '../../../domain/usecases/update_document_usecase.dart';
import '../../../domain/usecases/update_truck_checklist_usecase.dart';
import '../../../domain/usecases/upload_pictures_usecase.dart';
import '../../buttom_sheets/add_new_note_bottom_sheet.dart';
import '../../buttom_sheets/update_vehicle_documents_bottom_sheet.dart';
import '../../trucks/controllers/trucks_controller.dart';
import '../views/buttom_sheet/install_device_bottom_sheet.dart';
import '../views/buttom_sheet/new_truck_documents_bottom_sheet.dart';
import '../views/buttom_sheet/upload_truck_pictures_bottom_sheet.dart';
import '../views/components/truck_document_item.dart';
import '../../safety/controllers/form_data_builder.dart';

class TruckDetailsController extends GetxController implements TickerProvider {
  // auth
  final AuthController authController = Get.find<AuthController>();
  // helpers
  final attachmentsManager = Get.find<AssetsAttachmentsManager>();
  // final fileExtensionHelper = FileExtensionHelper();

  //use cases
  final getTruckDetailsUsecase = sl<GetTruckDetailsUsecase>();
  final deleteDocumentUsecase = sl<DeleteTruckDocumentUsecase>();
  final updateTruckCheckListUsecase = sl<UpdateTruckCheckListUsecase>();
  final createNewDocumentsUsecase = sl<CreateNewDocumentsUsecase>();
  final updateDocumentUsecase = sl<UpdateDocumentUsecase>();
  final updateDocumentExpirationUsecase = sl<UpdateDocumentExpirationUsecase>();
  final uploadPicturesUsecase = sl<UploadPicturesUsecase>();
  final uninstallDeviceUsecase = sl<UninstallDeviceUsecase>();
  final getAllTeamsUsecase = sl<GetAllTeamsUsecase>();
  final addNewNoteUsecase = sl<AddNewNoteUsecase>();
  final getDeviceTypesUsecase = sl<GetDeviceTypesUsecase>();
  final getDeviceTypeSerialsUsecase = sl<GetDeviceTypeSerialsUsecase>();
  final installDeviceUsecase = sl<InstallDeviceUsecase>();

  // body refresh controllers
  final RefreshController overviewRefreshCtrl = RefreshController();
  final RefreshController informationRefreshCtrl = RefreshController();
  final RefreshController documentsRefreshCtrl = RefreshController();
  final RefreshController deviceRefreshCtrl = RefreshController();

  // animation variables
  Animation<double>? animation;
  AnimationController? animationController;
  final truckDocsKey = GlobalKey<AnimatedListState>();

  final RxBool _fabMenuOpened = false.obs;
  bool get fabMenuOpened => _fabMenuOpened.value;

  // data variables
  final truckId = ''.obs;
  final truckEntity = Rxn<TruckEntity>();
  final isLoading = false.obs;
  final isDeletingDocument = false.obs;
  final isDeviceTypesLoading = false.obs;
  final isSerialNumbersLoading = false.obs;
  final isUploading = false.obs;
  final isAddingNote = false.obs;
  final isAddingDevice = false.obs;
  final RxBool isTeamsLoading = false.obs;
  final RxBool isPrivateSelected = false.obs;
  final RxBool isNotificationSelected = false.obs;
  final RxBool showNotificationTeamsAndToggleButtons = false.obs;
  final RxList<TeamsEntity> teams = RxList();
  final selectedTeamUsers = RxList<TeamsEntity>();
  final truckDetails = Rxn<VehicleDetailsEntity>();
  final currentUpdatingDocument = Rxn<VehicleFile>();
  final uploadTruckPictures = <VehicleFile>[VehicleFile(isAdded: false)].obs;

  final RxList<String> documentTypes = <String>[].obs;
  final deviceTypes = <DeviceTypeEntity>[].obs;
  final selectedDeviceType = Rxn<DeviceTypeEntity>(null);
  final serialNumbers = <SelectedDeviceEntity>[].obs;
  final selectedSerialNumber = Rxn<SelectedDeviceEntity>(null);

  final truckDocuments = RxList<VehicleDocuments>();

  final TextEditingController noteController = TextEditingController();
  final installedDateController = TextEditingController();

  List<String> tabTitles = [
    "Overview",
    "Information",
    "Documents",
    "Devices",
  ];

  @override
  void onInit() {
    super.onInit();

    final dynamic truck = Get.arguments;
    if (truck is TruckEntity) {
      truckEntity.value = truck;
      truckId.value = truck.id.toString();
      debugPrint('Truck ID: ${truckId.value}');
      getTruckDetails();
      showNotificationTeamsAndToggleButtons.value = true;
    }

    getAllTeams();
    getDeviceTypes();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController!,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  Future<void> init() async {
    await Future.wait([
      getTruckDetails(),
      getAllTeams(),
      getDeviceTypes(),
    ]);
  }

  Future<void> getTruckDetails() async {
    try {
      final body = {'truckId': truckId.value};
      isLoading.value = true;
      final response = await getTruckDetailsUsecase(body);
      return response.fold((VehicleDetailsEntity truckFromApi) {
        debugPrint('Truck details: ${truckFromApi.toEntity()}');
        truckDetails.value = truckFromApi;
        documentTypes.value = truckFromApi.documents?.folders
                ?.map((item) => item.collectionType)
                .whereType<String>()
                .toList() ??
            [];
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllTeams() async {
    try {
      isTeamsLoading.value = true;
      final result = await getAllTeamsUsecase.call(const NoParams());
      result.fold((List<TeamsEntity> teamsFromApi) {
        debugPrint('teams length: ${teamsFromApi.length}');
        teams.value = teamsFromApi;
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isTeamsLoading.value = false;
    }
  }

  Future<void> getDeviceTypes() async {
    if (isDeviceTypesLoading.value) {
      return;
    }
    try {
      isDeviceTypesLoading.value = true;
      final result = await getDeviceTypesUsecase.call(const NoParams());
      result.fold((List<DeviceTypeEntity> devicesFromApi) {
        debugPrint('devices length: ${devicesFromApi.length}');
        deviceTypes.value = devicesFromApi;
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isDeviceTypesLoading.value = false;
    }
  }

  Future<void> getSelectedDevice(DeviceTypeEntity device) async {
    if (isSerialNumbersLoading.value) {
      return;
    }

    final Map<String, dynamic> body = {
      "type": device.code ?? "",
    };
    try {
      isSerialNumbersLoading.value = true;
      final result = await getDeviceTypeSerialsUsecase.call(body);
      result.fold((List<SelectedDeviceEntity> serialsFromApi) {
        debugPrint('selected devices length: ${serialsFromApi.length}');
        serialNumbers.value = serialsFromApi;
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isSerialNumbersLoading.value = false;
    }
  }

  Future<void> updateTruckCheckList({
    required String id,
    required String date,
    required String dateType,
  }) async {
    try {
      final body = {
        'id': id,
        'date': date,
        'date_type': dateType,
      };
      debugPrint('Updating checklist with body: $body');
      final response = await updateTruckCheckListUsecase(body);
      return response.fold((success) {
        Get.snackbar('Success', 'Checklist updated successfully');
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> createNewDocument() async {
    final data = await FormDataBuilder.buildDocumentsFormData(
      truckId: truckId.value,
      documents: truckDocuments,
    );

    if (data == null) {
      return;
    }
    try {
      debugPrint('Submitting data: ${data.toString()}');
      isUploading.value = true;
      final response = await createNewDocumentsUsecase(data);
      return response.fold((truckFromApi) {
        Get.snackbar('Success', 'Document Created successfully');
        Get.back(closeOverlays: true);
        clearNewDocumentsButtomSheet();
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> updateDocument() async {
    final data = await FormDataBuilder.buildUpdateDocumentFormData(
      truckId: truckId.value,
      updateTruckDocument: currentUpdatingDocument.value,
    );

    if (data == null) {
      return;
    }

    try {
      debugPrint('Submitting data: ${data.toString()}');
      isUploading.value = true;
      final response = await updateDocumentUsecase(data);
      return response.fold((truckFromApi) {
        Get.snackbar('Success', 'Document Updated successfully');
        Get.back(closeOverlays: true);
        clearUpdateDocumentsButtomSheet();
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> updateDocumentExpiration({
    required String id,
    required String modelType,
    required String date,
    required String collectionType,
  }) async {
    try {
      final body = {
        'model_id': id,
        'model_type': modelType,
        'expiration_date': date,
        'collection_type': collectionType,
      };
      debugPrint('Updating checklist with body: $body');
      final response = await updateDocumentExpirationUsecase(body);
      return response.fold((success) {
        Get.snackbar('Success', 'Checklist updated successfully');
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> unInstallDevice({
    required String id,
    required String date,
  }) async {
    try {
      final body = {
        'id': id,
        'uninstalled_on': date,
      };
      debugPrint('device uninstalled with body: $body');
      final response = await uninstallDeviceUsecase(body);
      return response.fold((success) {
        Get.snackbar('Success', 'device uninstalled successfully');
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> uploadPictures() async {
    final data = await FormDataBuilder.buildPicturesFormData(
      truckId: truckId.value,
      pictures: uploadTruckPictures,
    );
    if (data == null) {
      return;
    }
    try {
      debugPrint('Submitting data: ${data.toString()}');
      isUploading.value = true;
      final response = await uploadPicturesUsecase(data);
      return response.fold((truckFromApi) {
        Get.snackbar('Success', 'pictures uploaded successfully');
        Get.back(closeOverlays: true);
        clearUploadPicturesButtomSheet();
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> onDeleteDocumentCicked(
    DocumentDto document,
    bool isOtherDocument,
  ) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: document.file?.name ?? "",
          title: 'Delete Document?',
          isLoading: isDeletingDocument,
          confirmText: 'Delete',
          confirmTextBtn: 'Delete',
          onConfirm: () {
            deleteDocument(document, isOtherDocument);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> deleteDocument(
      DocumentDto document, bool isOtherDocument) async {
    if (isDeletingDocument.value) {
      return;
    }

    isDeletingDocument.value = true;
    final body = {
      'id': document.id,
      'collection_type': document.collectionType,
      'isOtherDocument': isOtherDocument,
    };

    try {
      final result = await deleteDocumentUsecase.call(body);
      result.fold(
        (bool success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: 'Document deleted successfully',
              isError: false,
            );
            Navigator.pop(Get.context!);
            getTruckDetails();
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to delete the document'.tr,
            );
          }
        },
        (Failure e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isDeletingDocument.value = false;
    }
  }

  Future<void> addNewNote({required String truckId}) async {
    final Map<String, dynamic> body = {
      "id": truckId,
      "note": noteController.text,
      "model": "trucks", //! fix dynamic
      "teams": selectedTeamUsers.map((e) => e.id).toList(),
      "is_private": isPrivateSelected.value,
      "send_notification": isNotificationSelected.value,
    };

    debugPrint(body.toString());
    try {
      isAddingNote.value = true;
      final result = await addNewNoteUsecase.call(body);
      result.fold((bool trucksFromApi) {
        Get.snackbar('Success', 'note added successfully');
        Navigator.pop(Get.context!);

        // Refresh the note list
        refreshNoteList(truckId);

        // Clear the text field
        noteController.clear();
        isPrivateSelected.value = false;
        isNotificationSelected.value = false;
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isAddingNote.value = false;
    }
  }

  void refreshNoteList(String id) {
    final now = DateTime.now();

    final trucksController = Get.find<TrucksController>();
    final index = trucksController.trucks
        .indexWhere((element) => element.id.toString() == id);

    if (index != -1) {
      final formatted =
          '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}.${now.microsecond.toString().padLeft(6, '0')}';
      final recentNote = NoteDataEntity(
        createdAt: DateTime.parse(formatted),
        text: noteController.text,
        user: NoteUserEntity(
          image: authController.user.value?.image,
          firstName: authController.user.value?.firstName,
          lastName: authController.user.value?.lastName,
        ),
      );
      trucksController.trucks[index].truckNotes?.add(recentNote);
      trucksController.trucks.refresh();
      getTruckDetails();
    }
  }

  Future<void> insallDevice() async {
    if (isAddingDevice.value) {
      return;
    }

    // Validate the input fields
    if (selectedDeviceType.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please select a device type'.tr,
      );
      return;
    }

    if (selectedSerialNumber.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please select a serial number'.tr,
      );
      return;
    }

    if (installedDateController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Please select an installation date'.tr,
      );
      return;
    }

    // Prepare the request body
    final Map<String, dynamic> body = {
      "model_id": truckId.value,
      "model_type": "trucks", //! fix dynamic
      "devices": [
        {
          "type": selectedDeviceType.value?.code ?? "",
          "device_id": selectedSerialNumber.value?.id ?? "",
          "installed_on": installedDateController.text,
          "device_note": noteController.text
        }
      ]
    };
    try {
      isAddingDevice.value = true;
      final result = await installDeviceUsecase.call(body);
      result.fold((success) {
        Get.snackbar('Success', 'Device installed successfully');
        Navigator.pop(Get.context!);
        clearInstalledDeviceBottomSheet();
        getTruckDetails();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isAddingDevice.value = false;
    }
  }

  void showNewTruckBottemSheet(BuildContext context) {
    addTruckDocument();
    WoltModalSheet.show(
      context: context,
      useSafeArea: true,
      onModalDismissedWithBarrierTap: () {
        Get.back(closeOverlays: true);
        clearNewDocumentsButtomSheet();
      },
      pageListBuilder: (modalContext) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: true,
            topBarTitle: Text(
              'New Truck Document',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            enableDrag: false,
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Get.back(closeOverlays: true);
                clearNewDocumentsButtomSheet();
              },
            ),
            child: NewTruckDocumentButtomsheet(
              docsKey: truckDocsKey,
              isUploading: isUploading,
              onPressed: () {
                if (isUploading.value) {
                  return;
                }
                createNewDocument();
              },
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
    );
  }

  void showUpdateTruckBottemSheet(BuildContext context, DocumentDto document) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: true,
      onModalDismissedWithBarrierTap: () {
        Get.back(closeOverlays: true);
        clearUpdateDocumentsButtomSheet();
      },
      pageListBuilder: (modalContext) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: true,
            topBarTitle: Text(
              'Update Truck Document',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            enableDrag: false,
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Get.back(closeOverlays: true);
                clearUpdateDocumentsButtomSheet();
              },
            ),
            child: UpdateVehicleDocumentButtomsheet(
              document: document,
              currentUpdatingDocument: currentUpdatingDocument,
              isUploading: isUploading,
              onPressed: () {
                if (isUploading.value) {
                  return;
                }
                updateDocument();
              },
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
    );
  }

  void showUploadPicturesBottemSheet(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: true,
      onModalDismissedWithBarrierTap: () {
        Get.back(closeOverlays: true);
      },
      pageListBuilder: (modalContext) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: true,
            topBarTitle: Text(
              'Upload Truck Pictures',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            enableDrag: false,
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Get.back(closeOverlays: true);
                clearUploadPicturesButtomSheet();
              },
            ),
            child: UploadPicturesButtomsheet(
              uploadTruckPictures: uploadTruckPictures,
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
    );
  }

  void showAddNewNoteBottomSheet({
    required String truckId,
  }) {
    Get.bottomSheet(
      AddNewNoteBottomSheet(
        noteController: noteController,
        isAddingNote: isAddingNote,
        showTeams: true,
        teams: teams,
        onPickedChanged: (items) {
          selectedTeamUsers.value = items;
        },
        isPrivateSelected: isPrivateSelected,
        isNotificationSelected: isNotificationSelected,
        onPressed: () {
          addNewNote(truckId: truckId);
        },
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.scaffoldBackroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    );
  }

  void showAddNewDeviceBottomSheet() {
    Get.bottomSheet(
      const InstallDeviceBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.scaffoldBackroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    );
  }

  openFile(FileEntity? file) async {
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

      final filePath = await attachmentsManager.getAttachmentFile(
        fileUrl,
        onReceiveProgress: (received, total) {
          file.isDownloading.value = true;
          file.downloadProgress.value = received / total;
        },
        onFailure: (message) {
          CommonWidgets.showSnackBar(title: "Error", message: message);
        },
      );

      // resetting download progress states
      file.isDownloading.value = false;
      file.downloadProgress.value = 0.0;

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

  void onFabButtonClicked() {
    if (fabMenuOpened) {
      animationController?.reverse();
    } else {
      animationController?.forward();
    }
    _fabMenuOpened.toggle();
  }

  void addTruckDocument() {
    truckDocuments.insert(0, VehicleDocuments());
    truckDocsKey.currentState?.insertItem(0);
  }

  void removeTruckDocument(int index) {
    truckDocuments.removeAt(index);
    truckDocsKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: TruckDocumentItem(
          index: index,
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  void clearNewDocumentsButtomSheet() {
    truckDocuments.clear();
  }

  void clearUpdateDocumentsButtomSheet() {
    currentUpdatingDocument.value = null;
  }

  void clearUploadPicturesButtomSheet() {
    uploadTruckPictures.clear();
    uploadTruckPictures.add(VehicleFile(isAdded: false));
  }

  void clearInstalledDeviceBottomSheet() {
    selectedDeviceType.value = null;
    selectedSerialNumber.value = null;
    installedDateController.clear();
    noteController.clear();
  }

  @override
  void onClose() {
    debugPrint('TruckDetailsController onClose');
    overviewRefreshCtrl.dispose();
    informationRefreshCtrl.dispose();
    documentsRefreshCtrl.dispose();
    deviceRefreshCtrl.dispose();
    noteController.dispose();
    truckEntity.value = null;
    truckDetails.value = null;
    truckId.value = '';
    super.onClose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

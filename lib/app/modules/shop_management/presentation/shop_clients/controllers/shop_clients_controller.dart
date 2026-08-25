import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/client_entity.dart';
import '../../../domain/usecases/disable_client.dart';
import '../../../domain/usecases/get_all_clients.dart';
import '../../../domain/usecases/used_part/disable_used_client_usecase.dart';
import '../../../domain/usecases/used_part/get_all_used_clients_usecase.dart';
import '../../components/confirmation_bottom_sheet.dart';

class ShopClientsController extends GetxController
    with GetTickerProviderStateMixin {
  // usecase
  final getAllClientsUsecase = sl<GetAllClientsUsecase>();
  final disableClientUsecase = sl<DisableClientUsecase>();
  //- used part
  final getAllUsedClientsUsecase = sl<GetAllUsedClientsUsecase>();
  final disableUsedClientUsecase = sl<DisableUsedClientUsecase>();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();
  late final AnimationController searchExpandedController;
  final TextEditingController txtSearchController = TextEditingController();

  // loading state and variables
  final RxList<ClientEntity> clientsList = RxList();
  final RxBool isLoading = false.obs;
  final RxBool disablingClient = false.obs;
  final RxBool isSearchEnabled = false.obs;
  final txtSearch = ''.obs;

  final isUsedPart = false.obs;
  @override
  void onInit() {
    super.onInit();

    final usedPart = Get.arguments;
    if (usedPart != null && usedPart is bool) {
      isUsedPart.value = usedPart;
    }
    debugPrint('ShopClientsController onInit');
    getAllClients(isUsedPart: isUsedPart.value);
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text;
      debugPrint('Search: ${txtSearchController.text}');
    });
  }

  // load all clients
  Future<List<ClientEntity>> getAllClients({bool isUsedPart = false}) async {
    try {
      isLoading.value = true;
      final result = isUsedPart
          ? await getAllUsedClientsUsecase.call(const NoParams())
          : await getAllClientsUsecase.call({});
      return result.fold(
        (list) {
          debugPrint('clientsList: ${list.length}');
          clientsList.value = list;
          return list;
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
          return [];
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  // handle refresh
  Future<void> handleRefresh() async {
    await getAllClients(isUsedPart: isUsedPart.value);
    refreshController.refreshCompleted();
  }

  RxList<ClientEntity> get filterList {
    //no search
    if (txtSearch.isEmpty) {
      return clientsList;
      // search applied
    } else {
      return clientsList
          .where((element) =>
              element.companyName
                  ?.toLowerCase()
                  .contains(txtSearch.value.toLowerCase()) ??
              false)
          .toList()
          .obs;
    }
  }

  Future<void> onDisableClientCicked(ClientEntity client) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: client.companyName ?? "",
          title:
              client.isActive == true ? 'Disable Client ?' : 'Enable Client ?',
          isLoading: disablingClient,
          confirmText: client.isActive == true ? 'Disable ' : 'Enable ',
          confirmTextBtn: client.isActive == true ? 'Disable' : 'Enable',
          onConfirm: () {
            disableClient(client);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> disableClient(ClientEntity client) async {
    if (disablingClient.value) {
      return;
    }

    disablingClient.value = true;
    final isActive = client.isActive;
    final body = {
      'id': client.id,
      'status': isActive == true ? 'inactive' : 'active',
    };

    try {
      final result = isUsedPart.value
          ? await disableUsedClientUsecase.call(body)
          : await disableClientUsecase.call(body);
      result.fold(
        (success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message:
                  'Client ${isActive == true ? 'Disabled' : 'Enabled'} successfully',
              isError: false,
            );
            Navigator.pop(Get.context!);
            getAllClients(isUsedPart: isUsedPart.value);
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to update the client'.tr,
            );
          }
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
      disablingClient.value = false;
    } catch (e) {
      disablingClient.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    try {
      txtSearchController.dispose();
    } catch (e) {
      debugPrint("Controller already disposed: $e");
    }
    super.onClose();
  }
}

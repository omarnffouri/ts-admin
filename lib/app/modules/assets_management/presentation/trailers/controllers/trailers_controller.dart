import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/enum/assets_management_category.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/trailer_entity.dart';
import '../../../domain/usecases/add_new_note_usecase.dart';
import '../../../domain/usecases/get_all_trailers_usecase.dart';
import '../../buttom_sheets/add_new_note_bottom_sheet.dart';
import '../../buttom_sheets/notes_bottom_sheet.dart';

class TrailersController extends GetxController {
  // auth
  final AuthController authController = Get.find<AuthController>();

  // usecase
  final getAllTrailersUsecase = sl<GetAllTrailersUsecase>();
  final addNewNoteUsecase = sl<AddNewNoteUsecase>();

  // Controllers
  final scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();
  final TextEditingController txtSearchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  //Data
  final RxList<TrailerEntity> trailers = RxList();
  final Rx<AssetsCategory?> assetsCategory = AssetsCategory.trucks.obs;
  final selectedStatus = 'all'.obs;
  RxList<String> statusOptions = <String>[
    'all',
    'pending',
    'active',
    'hold',
    'inactive',
    'future_expired',
    'expired',
    'terminated',
    'sold',
    'out_of_service',
  ].obs;

  // Pagination
  final RxInt page = 1.obs;
  final RxBool hasMoreData = false.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isAddingNote = false.obs;

  // Search text
  final RxString txtSearch = ''.obs;
  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    if (arg != null && arg is AssetsCategory) {
      debugPrint('Received category argument: $arg');
      assetsCategory.value = arg;
    }

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text.trim();
    });
    scrollController.addListener(_scrollListener);

    _loadInitialData();

    selectedStatus.listen((value) {
      debugPrint('Selected status changed: $value');
      _loadInitialData();
    });
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      loadMoreApplications();
    }
  }

  Map<String, dynamic> _getRequestBody() {
    final Map<String, dynamic> body = {};

    if (selectedStatus.value.toLowerCase() != "all") {
      body['status'] = selectedStatus.value.toLowerCase();
    } else {
      body['status'] = null;
    }

    if (txtSearchController.text.isNotEmpty) {
      body['search'] = txtSearchController.text.trim();
    }

    body['page'] = page.value;
    body['perPage'] = 20;

    return body;
  }

  _loadInitialData() async {
    hasMoreData.value = false;
    page.value = 1;

    trailers.clear();

    isLoading.value = true;

    final data = await getAllTrailers(_getRequestBody());

    if (data != null) {
      hasMoreData.value = data.hasMore ?? false;
      trailers.clear();
      trailers.addAll(data.data ?? []);
    }
    isLoading.value = false;
  }

  Future<BaseResponse<List<TrailerEntity>>?> getAllTrailers(
      Map<String, dynamic> body) async {
    BaseResponse<List<TrailerEntity>>? data;
    try {
      final result = await getAllTrailersUsecase.call(body);
      result.fold((BaseResponse<List<TrailerEntity>> respose) {
        debugPrint('trailers length: ${respose.data?.length}');
        data = respose;
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
    }
    return data;
  }

  loadMoreApplications() async {
    if ((!hasMoreData.value) || isLoadingMore.value) {
      return;
    }

    page.value = page.value + 1;

    isLoadingMore.value = true;

    final data = await getAllTrailers(_getRequestBody());

    if (data != null) {
      hasMoreData.value = data.hasMore ?? false;
      trailers.addAll(data.data ?? []);
      debugPrint('Total trailers after loading more: ${trailers.length}');
    } else {
      if (page.value > 1) {
        page.value = page.value - 1;
      }
    }

    isLoadingMore.value = false;
  }

  Future<void> addNewNote({required String trailerId}) async {
    try {
      final Map<String, dynamic> body = {
        "id": trailerId,
        "note": noteController.text,
        "model": assetsCategory.value?.apiValue,
      };
      isAddingNote.value = true;
      final result = await addNewNoteUsecase.call(body);
      result.fold((bool trucksFromApi) {
        Get.snackbar('Success', 'note added successfully');
        Navigator.pop(Get.context!);

        // Refresh the note list
        refreshNoteList(trailerId);

        noteController.clear();
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
    final index = trailers.indexWhere((element) => element.id.toString() == id);

    if (index != -1) {
      final formatted =
          '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}.${now.microsecond.toString().padLeft(6, '0')}';
      trailers[index].trailerNotes?.add(
            NoteDataEntity(
              createdAt: DateTime.parse(formatted),
              text: noteController.text,
              user: NoteUserEntity(
                image: authController.user.value?.image,
                firstName: authController.user.value?.firstName,
                lastName: authController.user.value?.lastName,
              ),
            ),
          );
      trailers.refresh();
    }
  }

  Future<void> handleRefresh() async {
    await _loadInitialData();
    refreshController.refreshCompleted();
  }

  Future<void> onSearch() async {
    EasyDebounce.debounce('search', const Duration(milliseconds: 1000),
        () async {
      debugPrint('Search query: ${txtSearchController.text.trim()}');
      await _loadInitialData();
    });
  }

  void handleStatusChange(String? value) {
    if (value != null) {
      selectedStatus.value = value;
      debugPrint('Selected status: $value');
    }
  }

  void showNotesBottomSheet(String id, List<NoteDataEntity> notes) {
    Get.bottomSheet(
      NotesBottomSheet(
        id: id,
        model: assetsCategory.value!.apiValue.toString(),
        notes: notes,
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

  void showAddNewNoteBottomSheet({required String trailerId}) {
    Get.bottomSheet(
      AddNewNoteBottomSheet(
        noteController: noteController,
        isAddingNote: isAddingNote,
        showTeams: false,
        onPressed: () {
          addNewNote(trailerId: trailerId);
        },
      ),
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

  @override
  void onClose() {
    txtSearchController.dispose();
    refreshController.dispose();
    super.onClose();
  }
}

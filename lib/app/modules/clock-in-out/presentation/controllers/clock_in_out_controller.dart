import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';

import 'package:ts_admin/app/core/values/constants.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/controllers/location_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/modules/annoucments/presentation/announcements/controllers/annoucments_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/controllers/message_notifications_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/check_clock_in_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/clock_in_out_history_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/entities/week_hours_entity.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/check_clock_in_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_in_out_history_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_in_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_out_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/weekly_hours_usscase.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/clock_out_info_dialog.dart';

import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/map_view_bottom_sheet.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/get_all_forms_usecase.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_additional_pays_usecase.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/enums/invoice_payment_actions.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/enums/invoice_payment_statuses.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:uuid/uuid.dart';

import '../../../invoices_management/domain/entities/invoice_payment_request_entity.dart';
import '../../../invoices_management/domain/usecases/invoice_payments_use_case.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ClockInOutController extends GetxController {
  // variables for the clock duration states
  final days = 0.obs;
  final hours = 0.obs;
  final minutes = 0.obs;
  final seconds = 0.obs;
  final RxList<WeekEntity> weekHours = <WeekEntity>[].obs;

  final totalHours = 0.0.obs;

  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  final annoucementController = Get.put(AnnoucmentsController());
  final messagesNotifyController = Get.put(MessageNotificationsController());

  final theme = Theme.of(Get.context!);

  final Rx<HomeTabs> currentTab = HomeTabs.annoucments.obs;
  final Rx<DateTime> calendarViewStart = DateTime.now().obs;

  // body refresh controllers
  // RefreshController timeSheetRefreshController =
  //     RefreshController(initialRefresh: false);

  final annoucementsPageController = PageController();

  final bodyRefeshController = RefreshController();
  // final formsRefeshController = RefreshController();
  // final annoucementsRefeshController = RefreshController();

  // usecases
  final checkClockInUseCase = sl<CheckClockInUsecase>();
  final clockInUseCase = sl<ClockInUsecase>();
  final clockOutUseCase = sl<ClockOutUsecase>();
  final clockInOutHistoryUseCase = sl<ClockInOutHistoryUsecase>();
  final invoicePaymentsUseCase = sl<InvoicePaymentsUseCase>();
  final getAllFormsUsecase = sl<GetAllFormsUsecase>();
  final getWeeklyHoursUseCase = sl<GetWeeklyHoursUseCase>();
  final getAdditionalPaysUsecase = sl<GetAdditionalPaysUsecase>();

  int totalTicks = 0;

  // state variables
  final _isClockedIn = false.obs;
  bool get isClockedIn => _isClockedIn.value;

  final _isCheckingClockInFailed = false.obs;
  bool get isCheckingClockInFailed => _isCheckingClockInFailed.value;

  final _isCheckingClockIn = false.obs;
  bool get isCheckingClockIn => _isCheckingClockIn.value;

  final _isClockingInOut = false.obs;
  bool get isClockingInOut => _isClockingInOut.value;

  final _isShowingAutoClockOutDialog = false.obs;
  bool get isShowingAutoClockOutDialog => _isShowingAutoClockOutDialog.value;

  final _isLoadingClockingInOutHistory = false.obs;
  bool get isLoadingClockingInOutHistory =>
      _isLoadingClockingInOutHistory.value;

  final _isLoadingTimeSheetHours = false.obs;
  bool get isLoadingTimeSheetHours => _isLoadingTimeSheetHours.value;

  final RxBool _isLoadingForms = false.obs;
  bool get isLoadingForms => _isLoadingForms.value;

  // list of invoices
  final RxList<InvoicePaymentEntity> invoicePayments =
      RxList<InvoicePaymentEntity>();

  // list of forms
  final RxList<FormEntity> forms = RxList<FormEntity>();

  // timer for showing live ticks and time in views
  Timer? _timer;

  // preferences from get it
  final preferences = GetStorage();

  // data variables
  final RxList<ClockInOutHistoryDataEntity> clockInOutHistory = RxList();

  /// Pending additional-pay approvals awaiting this admin — null until loaded
  /// (or when the user lacks the resolve permission).
  final Rxn<int> pendingAdditionalPays = Rxn<int>();

  final RxBool _isLoadingPendingPays = false.obs;
  bool get isLoadingPendingPays => _isLoadingPendingPays.value;

  /// Gates both the fetch and the stats tile. One source, so the tile can
  /// never render against a fetch that silently bailed.
  bool get canSeePendingPays =>
      authController.userPermissionHelper.canResolveAdditionalPays();

  Future<void> fetchPendingAdditionalPays() async {
    if (!canSeePendingPays || _isLoadingPendingPays.value) return;
    _isLoadingPendingPays(true);
    try {
      // Minimal page — only the global status_counts block is needed.
      final response = await getAdditionalPaysUsecase.call({
        'page': 1,
        'per_page': 1,
        'status': AdditionalPayStatus.pending.name,
      });
      response.fold(
        (data) =>
            pendingAdditionalPays.value = data.data?.statusCounts?.pending,
        (_) {},
      );
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      _isLoadingPendingPays(false);
    }
  }

  // close button for map bottom sheet
  final RxBool autoClosBtn = true.obs;

  // final RxBool needToShowMapBottomSheet = true.obs;
  final RxBool timesheetHistoryExpanded = false.obs;

  DateTime? selectedDate;
  String get selectedDateFormatted => selectedDate == null
      ? DateFormat('yyyy-MM-dd').format(DateTime.now())
      : DateFormat('yyyy-MM-dd').format(selectedDate!);

  @override
  void onInit() {
    super.onInit();

    _checkClockIn();
    CommonVariables.tracking.write(isClockServiceRunning, false);
    fetchInvoicePayments();
    getAllForms();
    fetchWeeklyHours();
    fetchPendingAdditionalPays();
    annoucementController.getAllAnnoucements();

    ever(calendarViewStart, (date) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedDate = date;
        Future.wait([refreshCalendarData(date: selectedDateFormatted)]);
      });
    });
  }

  void _startTimer() {
    CommonVariables.tracking.write(isClockServiceRunning, true);
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        totalTicks += 1;
        _formatDuration();

        //todo timer is running then after every 10 sec
        // check if service not running then start service
        //  if((totalTicks % 10) == 0){
        //    Get.find<LocationController>().serviceAlreadyRunning().then((running) {
        //     if (!running) {
        //       Get.find<LocationController>().startTrack();
        //     }
        //   }).catchError((_) {});
        //  }
      },
    );
    autoClosBtn.value = true;
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();
    totalTicks = 0;
    days.value = 0;
    hours.value = 0;
    minutes.value = 0;
    seconds.value = 0;
    _isClockedIn(false);
    await CommonVariables.tracking.write(isClockServiceRunning, false);
    Get.find<LocationController>().releaseTracking();
  }

  _formatDuration() {
    var tick = totalTicks;
    // calculating days from tick
    days.value = tick ~/ (24 * 3600);

    // subracting days from the tick
    tick = tick % (24 * 3600);

    // calculating hours
    hours.value = tick ~/ 3600;

    // subracting hours from tick
    tick = tick % 3600;

    // calculating minutes
    minutes.value = tick ~/ 60;

    // removing minutes and getting seconds
    seconds.value = tick % 60;
  }

  onClockInOutClicked() {
    if (isClockedIn) {
      _clockOut();
    } else {
      _clockIn();
    }
  }

  refeshClockInState() {
    _checkClockIn();
    fetchInvoicePayments();
  }

  final RxBool _isRefreshingDashboard = false.obs;

  /// Everything the dashboard shows, in parallel. Each call handles its own
  /// failure, so one bad endpoint can't strand the refresh indicator.
  /// Only `fetchWeeklyHours` of the calendar pair feeds a dashboard surface —
  /// the history list belongs to the timesheet dialog, which refetches on open.
  Future<void> handleDashboardRefresh() async {
    if (_isRefreshingDashboard.value) {
      bodyRefeshController.refreshCompleted();
      return;
    }
    _isRefreshingDashboard(true);
    try {
      await Future.wait([
        _checkClockIn(),
        fetchInvoicePayments(),
        getAllForms(),
        annoucementController.getAllAnnoucements(),
        fetchPendingAdditionalPays(),
        fetchWeeklyHours(),
      ]);
    } finally {
      _isRefreshingDashboard(false);
      bodyRefeshController.refreshCompleted();
    }
  }

  Future<void> fetchWeeklyHours({String? date}) async {
    try {
      final selectedDate = date ?? DateTime.now().toIso8601String();

      _isLoadingTimeSheetHours(true);
      final Either<BaseResponse<WeekHoursEntity>, Failure> result =
          await getWeeklyHoursUseCase.call(selectedDate);

      result.fold((BaseResponse<WeekHoursEntity> data) {
        if (data.data != null) {
          weekHours.clear();
          weekHours.addAll(data.data!.weeks);
          totalHours.value = data.data?.totalHours ?? 0.0;
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: data.message ?? "Something went wrong.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(title: 'Error'.tr, message: r.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      _isLoadingTimeSheetHours(false);
    }
  }

  Future<void> _checkClockIn() async {
    CommonVariables.tracking.write(isClockServiceRunning, false);
    _isClockedIn(false);
    try {
      _isCheckingClockIn(true);
      _isCheckingClockInFailed(false);
      final Either<BaseResponse<CheckClockInDataEntity>, Failure> result =
          await checkClockInUseCase.call(const NoParams());

      result.fold((BaseResponse<CheckClockInDataEntity> clockData) async {
        if (clockData.data != null) {
          _isClockedIn(clockData.data!.clockedIn ?? false);
          CommonVariables.tracking.write(
            isClockServiceRunning,
            clockData.data?.clockedIn ?? false,
          );
          if (isClockedIn) {
            totalTicks = (clockData.data!.startStopWatchFrom ?? 0).toInt();
            _formatDuration();
            _startTimer();

            // showing map bottom sheet
            // if (Platform.isIOS && needToShowMapBottomSheet.value) {
            //   needToShowMapBottomSheet(false);
            //   showMapBottomSheet();
            // }
            final uuid = const Uuid().v1();
            await CommonVariables.tracking.writeIfNull(
              uuId,
              uuid,
            );
            await SharedPrefrencesHelper.storeClockInOutSessionId(uuid, true);
            Get.find<LocationController>().startTrack();

            if (await PermissionHelper.needClockOut()) {
              if (!isShowingAutoClockOutDialog) {
                await showClockOutInfoDialog();
                if (isClockedIn && (await PermissionHelper.needClockOut())) {
                  await _clockOut();
                }
              }
            }
          } else {
            _stopTimer();
            SharedPrefrencesHelper.clearClockInOutSessionId();
          }
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isCheckingClockInFailed(true);
      });

      _isCheckingClockIn(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isCheckingClockIn(false);
      _isCheckingClockInFailed(true);
    }
  }

  showClockOutInfoDialog() async {
    _isShowingAutoClockOutDialog.value = true;
    await showGeneralDialog(
      barrierColor: Colors.black.applyOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 500, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: const ClockOutInfoDialog(),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: Get.context!,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
    );
    _isShowingAutoClockOutDialog.value = false;
  }

  Future<void> _clockIn() async {
    if (isClockingInOut || isClockedIn) {
      return;
    }

    if (!(await PermissionHelper.haveAlwaysLocationPermission(
        "Keep your location set to ${Platform.isIOS ? "Always On" : "Allow all the time"} in the app settings to clock-in. Don't close the location or change its permission to avoid automatic clocking out."))) {
      return;
    }

    try {
      _isClockingInOut(true);

      final Either<BaseResponse<bool>, Failure> result =
          await clockInUseCase.call(const NoParams());

      _isClockingInOut(false);

      result.fold((BaseResponse<bool> clockData) async {
        if (clockData.data == true) {
          _isClockedIn(true);

          CommonVariables.tracking.write(
            isClockServiceRunning,
            true,
          );

          totalTicks = 0;
          _formatDuration();
          _startTimer();

          // showing map bottom sheet
          // if (Platform.isIOS) {
          //   showMapBottomSheet();
          // }
          final uuid = const Uuid().v1();
          await CommonVariables.tracking.write(
            uuId,
            uuid,
          );
          await SharedPrefrencesHelper.storeClockInOutSessionId(uuid, false);
          Get.find<LocationController>().startTrack();

          refreshCalendarData();
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: clockData.message ?? "Something went wrong.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isClockingInOut(false);
    }
  }

  Future<void> _clockOut() async {
    if (isClockingInOut || (!isClockedIn)) {
      return;
    }

    try {
      _isClockingInOut(true);
      final Either<BaseResponse<bool>, Failure> result =
          await clockOutUseCase.call(const NoParams());

      _isClockingInOut(false);

      result.fold((BaseResponse<bool> clockData) async {
        if (clockData.data == true) {
          _isClockedIn(false);
          CommonVariables.tracking.write(
            isClockServiceRunning,
            false,
          );

          _stopTimer();
          SharedPrefrencesHelper.clearClockInOutSessionId();
          refreshCalendarData();
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: clockData.message ?? "Something went wrong.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isClockingInOut(false);
    }
  }

  /// Two independent endpoints — awaited together so the refresh spinner isn't
  /// held up for the sum of both.
  Future<void> refreshCalendarData({String? date}) async {
    await Future.wait([
      fetchWeeklyHours(date: date),
      getClockInOutHistory(date: date),
    ]);
  }

  Future<void> getClockInOutHistory({String? date}) async {
    clockInOutHistory.clear();
    try {
      final selectedDate = date ?? DateTime.now().toIso8601String();
      _isLoadingClockingInOutHistory(true);

      final Either<BaseResponse<List<ClockInOutHistoryDataEntity>>, Failure>
          result = await clockInOutHistoryUseCase.call(selectedDate);

      result.fold((BaseResponse<List<ClockInOutHistoryDataEntity>> clockData) {
        if (clockData.data != null) {
          clockInOutHistory.clear();
          clockInOutHistory.addAll(clockData.data!);
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: clockData.message ?? "Something went wrong.",
          );
        }
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
      _isLoadingClockingInOutHistory(false);
    }
  }

  DataSource getCalendarDataSource() {
    List<Appointment> appointments = getData();
    return DataSource(appointments);
  }

  List<Appointment> getData() {
    final List<Appointment> appoinments = [];
    for (var element in clockInOutHistory) {
      // checking if clock in not null
      if (element.clockin != null) {
        appoinments.add(
          Appointment(
            startTime: element.clockin!,
            endTime: element.clockin!,
            subject: 'Start',
            color: Get.isDarkMode
                ? AppColorsDark.clockInOutGreenColor
                : Colors.green,
          ),
        );
      }

      // checking if clock out not null
      if (element.clockout != null) {
        appoinments.add(
          Appointment(
              startTime: element.clockout!,
              endTime: element.clockout!,
              subject: 'End',
              color: Get.isDarkMode
                  ? AppColorsDark.clockInOutRedColor
                  : Colors.red,
              notes: "(${_getDurationOfClockOut(element.duration)})"),
        );
      }
    }

    return appoinments;
  }

  String _getDurationOfClockOut(String? duration) {
    String data = '';
    if (duration != null) {
      var arr = duration.split(":");
      if (arr.length == 3) {
        var hrs = arr[0];
        var mins = arr[1];
        var sec = arr[2];

        if (hrs != "00") {
          var h = int.parse(hrs);

          // checking if hrs > 24 then calculate the days.
          if (h > 24) {
            var d = h ~/ 24;

            h = h % 24;
            data = "${d}d, ${h}h,";
          } else {
            data = "${h}h,";
          }
        }

        if (mins != "00") {
          data = data.isEmpty ? '${mins}m,' : '$data ${mins}m,';
        }
        data = data.isEmpty ? '${sec}s' : '$data ${sec}s';
      }
    }
    return data;
  }

  showMapBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return const MapBottomSheetView();
      },
    );
  }

  Future<void> fetchInvoicePayments() async {
    if (!(authController.user.value?.isSuperAdmin ?? false)) {
      return;
    }
    try {
      final Either<BaseResponse<List<InvoicePaymentEntity>>, Failure> result =
          await invoicePaymentsUseCase.call(GetInvoicesParams(
        action: InvoicePaymentActions.edit,
        status: InvoicePaymentStatuses.pending,
      ));

      result.fold((BaseResponse<List<InvoicePaymentEntity>> invoiceData) {
        if (invoiceData.data?.isNotEmpty ?? false) {
          invoicePayments.value = invoiceData.data!;
        } else {
          invoicePayments.clear();
        }
      }, (Failure r) {
        invoicePayments.clear();
      });
    } on Exception catch (_) {
      invoicePayments.clear();
    }
  }

  Future<void> getAllForms() async {
    try {
      forms.clear();
      _isLoadingForms(true);
      final result = await getAllFormsUsecase.call(const NoParams());

      result.fold((List<FormEntity> formsFromApi) {
        forms.value = formsFromApi
            .where((element) => (!(element.isSigned ?? false)))
            .toList();

        log('forms list length: ${forms.length}');
        // debugPrint('isFormsCompleted: ${isFormsCompleted.value}');

        _isLoadingForms(false);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isLoadingForms(false);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingForms(false);
    }
  }

  @override
  void dispose() {
    try {
      _timer?.cancel();
    } catch (_) {}
    super.dispose();
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

enum HomeTabs { annoucments, forms }

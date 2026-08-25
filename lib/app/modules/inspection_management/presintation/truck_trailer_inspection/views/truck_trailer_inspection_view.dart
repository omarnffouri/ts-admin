import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/inspection_tab_switcher.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/views/tabs/truck_trailer_pending_inspections_tab.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/views/tabs/truck_trailer_requested_inspections_tab.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/truck_trailer_inspection_controller.dart';

class TruckTrailerInspectionView
    extends GetView<TruckTrailerInspectionController> {
  const TruckTrailerInspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            Routes.CREATE_INSPECTION_REQUEST,
            arguments: controller.type.value,
          );
        },
        backgroundColor: context.floatingButtonColor,
        foregroundColor: Colors.white,
        tooltip: 'Create inspection request',
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          //
          // header
          const _Header(),

          //
          // body
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  //
                  // segmented tab control
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Obx(
                      () => InspectionTabSwitcher(
                        selectedIndex: controller.tabIndex.value,
                        labels: const ['Pending Requests', 'Inspected'],
                        onChanged: (int index) =>
                            controller.tabIndex.value = index,
                      ),
                    ),
                  ),

                  //
                  // tabs — kept mounted so scroll + expansion state survive a
                  // switch, and no data is refetched when toggling.
                  Expanded(
                    child: Obx(
                      () => IndexedStack(
                        index: controller.tabIndex.value,
                        sizing: StackFit.expand,
                        children: const [
                          TruckTrailerPendingInspectionsTab(),
                          TruckTrailerRequestedInspectionsTab(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Brand-gradient header matching the rest of the app (AppRedHeader with a
/// frosted back button and a bold white title). The title reflects the active
/// inspection type ("Truck Inspection" / "Trailer Inspection").
class _Header extends GetView<TruckTrailerInspectionController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          //
          // back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          //
          // heading
          Expanded(
            child: Obx(
              () => Text(
                '${controller.type.value.capitalizeFirst} Inspection',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/app_tab_bar_widget.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/components/title_pill_tab.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/pages/documents_page.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/pages/driving_license_page.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/pages/forms_page.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/pages/personal_details_page.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/pages/road_test_page.dart';

import '../controllers/application_detail_view_controller.dart';
import 'pages/overview_page.dart';

class ApplicationDetailViewView
    extends GetView<ApplicationDetailViewController> {
  const ApplicationDetailViewView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;
    return Container(
      color: primaryColor,
      child: const SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              //
              // header
              _Header(),
              AppTabBarWidget(
                titles: [
                  PillTab(title: "Overview"),
                  PillTab(title: "Personal"),
                  PillTab(title: "Driving License"),
                  PillTab(title: "Road Tests"),
                  PillTab(title: "Forms"),
                  PillTab(title: "Documents"),
                ],
                tabs: [
                  OverViewPage(),
                  PersonalDetailsPage(),
                  DrivingLicensePage(),
                  RoadTestPage(),
                  FormsPage(),
                  DocumentsPage(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<ApplicationDetailViewController> {
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
                  'Application Details',
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          //
        ],
      ),
    );
  }
}

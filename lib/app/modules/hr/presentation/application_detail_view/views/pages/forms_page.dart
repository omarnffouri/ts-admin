import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/core/widgets/pdf_viewer.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class FormsPage extends GetView<ApplicationDetailViewController> {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        controller: controller.formsRefreshController,
        header: const WaterDropMaterialHeader(),
        onRefresh: () {
          controller.formsRefreshController.refreshCompleted();
          controller.handleRefresh();
        },
        child: controller.isLaodingApplicationDetails
            ? _buildLoadingView()
            : controller.froms.isEmpty
                ? const NoDataView()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // heading
                        Text(
                          "Application Forms",
                          style: Get.theme.textTheme.titleLarge,
                        ).marginOnly(left: 14, top: 20),

                        Divider(
                          height: 0,
                          color: Get.isDarkMode ? Colors.grey : null,
                        ).marginSymmetric(horizontal: 14),

                        const SizedBox(height: 20),
                        ListView.separated(
                          itemCount: controller.froms.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final form = controller.froms.elementAt(index);
                            return _FormItemView(
                              form: form,
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Forms',
              style: Get.theme.textTheme.titleLarge,
            ).marginOnly(left: 14, top: 20),
            Divider(
              height: 0,
              color: Get.isDarkMode ? Colors.grey : null,
            ).marginSymmetric(horizontal: 14),
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: index == 0 ? 30 : 10,
                    bottom: index == 9 ? 50 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FormItemView extends GetView<ApplicationDetailViewController> {
  final FormEntity form;
  final int index;
  const _FormItemView({
    required this.form,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    //
    //
    // theme
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if ((form.file?.url ?? "").isNotEmpty) {
          Get.to(
            () => PdfViewer(
              title: form.formName ?? "Form",
              path: form.file?.url ?? "",
              fileLoaded: () {},
              downloadable: true,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.applyOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            //
            //
            // form
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // form signed or not
                Icon(
                  form.signed == true
                      ? Icons.check_circle_rounded
                      : Icons.info_rounded,
                  color: form.signed == true ? Colors.green : Colors.orange,
                ),

                //
                //
                // form name
                const SizedBox(width: 4),
                Expanded(
                  child: Html(
                    data: form.formName ?? "",
                    style: {
                      "html": Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "body": Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "h2": Style(
                        fontSize: FontSize(18.sp),
                        fontWeight: FontWeight.bold,
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "h3": Style(
                        fontSize: FontSize(15.sp),
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "h4": Style(
                        fontSize: FontSize(15.sp),
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "p": Style(
                        fontSize: FontSize(15.sp),
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                    },
                  ),
                ),

                //
                //
                // form type
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: form.signed == true ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    form.type?.capitalizeFirst ?? "",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),

            //
            //
            // modified date, file
            Row(
              children: [
                //
                //
                // modified date heading
                Text(
                  "Last modified: ",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),

                //
                //
                //
                Expanded(
                  child: Text(
                    (form.updatedAt ?? "N/A").replaceFirst(" ", " at "),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                //
                //
                // show file icon if have file
                if ((form.file?.url ?? "").isNotEmpty)
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 25,
                    color: AppColorsLight.mainColor,
                  ),
              ],
            ).marginOnly(top: 10)
          ],
        ),
      ),
    );
  }
}

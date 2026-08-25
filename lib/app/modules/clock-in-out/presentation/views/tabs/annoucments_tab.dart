import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_image_preview.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ts_admin/app/core/widgets/tasks_empty_state.dart';

class AnnoucmentsTab extends GetView<ClockInOutController> {
  const AnnoucmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Obx(
        () => controller.annoucementController.isLoadingAnnoucements
            ? _buildLoadingView()
            : controller.annoucementController.annoucements.isEmpty
                ? const TasksEmptyState(
                    bgColor: Colors.transparent,
                    radius: 0,
                    padding: 0,
                    title: "No announcements for now",
                    descrption:
                        "Keep checking to know if there a new announcements",
                  )
                : Column(
                    children: [
                      //
                      // page builder
                      ExpandablePageView.builder(
                        controller: controller.annoucementsPageController,
                        itemCount: controller
                            .annoucementController.annoucements.length,
                        itemBuilder: (context, index) {
                          final annoucenment = controller
                              .annoucementController.annoucements[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.annoucementController
                                      .updateAnnoucementsReadStatus(
                                          annoucenment, index);
                                  if (annoucenment.image == null) {
                                    return;
                                  }
                                  Get.to(
                                    ChatImagePreview(
                                        title: "Announcement",
                                        previewImages: [
                                          PreviewImage(
                                              url: annoucenment.image,
                                              file: null)
                                        ],
                                        initialIndex: 0),
                                  );
                                },
                                child: ProfileImage.network(
                                  url: annoucenment.image ??
                                      "https://images.pexels.com/photos/312839/pexels-photo-312839.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                  radius: 10,
                                  width: double.infinity,
                                  height: Get.height * 0.20,
                                ),
                              ),

                              //
                              // space
                              const SizedBox(
                                height: 10,
                              ),

                              //
                              // date and read me button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //date
                                  Text(
                                    timeago.format((annoucenment.createdAt ??
                                        DateTime.now())),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  //
                                  // mark as read button
                                  Obx(
                                    () => ((controller
                                                    .annoucementController
                                                    .updatingAnnouncementStatusIndex
                                                    .value ==
                                                index) &&
                                            controller.annoucementController
                                                .isupdatingAnnoucementStatus)
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : AppColorsLight.mainColor,
                                              strokeCap: StrokeCap.round,
                                            ),
                                          ).marginOnly(right: 15)
                                        : annoucenment.read == 1
                                            ? const _ReadRecipt()
                                                .marginOnly(right: 10)
                                            : GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .annoucementController
                                                      .updateAnnoucementsReadStatus(
                                                    annoucenment,
                                                    index,
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : AppColorsLight
                                                            .mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Text(
                                                    "Read me",
                                                    style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? AppColorsLight
                                                              .mainColor
                                                          : Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ).marginOnly(right: 5),
                                  )
                                ],
                              ),
                              Text(
                                annoucenment.title ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   annoucenment.message ?? "",
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //   ),
                              // ),

                              Html(data: annoucenment.message ?? "", style: {
                                "h2": Style(
                                    fontSize: FontSize(18.sp),
                                    fontWeight: FontWeight.bold),
                                "h3": Style(fontSize: FontSize(15.sp)),
                                "h4": Style(fontSize: FontSize(15.sp)),
                                "p": Style(fontSize: FontSize(15.sp)),
                              }),
                              const SizedBox(height: 20),
                            ],
                          ).marginSymmetric(horizontal: 10, vertical: 5);
                        },
                      ),

                      //
                      // dot indicator
                      SmoothPageIndicator(
                        controller: controller.annoucementsPageController,
                        count: controller
                            .annoucementController.annoucements.length,
                        effect: const SwapEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppColorsLight.mainColor,
                          type: SwapType.yRotation,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: Get.isDarkMode
          ? AppColorsDark.shimmerHilightColor
          : Colors.grey.shade300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: Get.height * 0.20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade500,
            ),
          ),

          //
          // space
          const SizedBox(
            height: 10,
          ),

          //
          // date and read me button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //date
              Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade500,
                ),
              ),

              //
              // mark as read button
              Container(
                width: 70,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Container(
            width: 150,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade500,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 200,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade500,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 150,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade500,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade500,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade500,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ).marginOnly(top: 15)
        ],
      ).marginSymmetric(horizontal: 10, vertical: 5),
    );
  }
}

class _ReadRecipt extends StatelessWidget {
  const _ReadRecipt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          left: 4,
          child: Icon(
            Icons.check,
            size: 12,
            color: Colors.grey.shade500,
          ),
        ),
        Icon(
          Icons.check,
          size: 12,
          color: Colors.grey.shade500,
        ),
      ],
    );
  }
}

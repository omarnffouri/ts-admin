import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

// class ProfileImage extends StatelessWidget {
//   const ProfileImage(
//       {super.key,
//       this.url,
//       this.height = 50,
//       this.width = 50,
//       this.radius = 999,
//       this.fit = BoxFit.cover,
//       this.showLetterOnError = false,
//       this.letter});
//   final String? url;
//   final double height;
//   final double width;
//   final double radius;
//   final BoxFit fit;
//   final bool showLetterOnError;
//   final String? letter;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(radius.r),
//         child: CachedNetworkImage(
//           imageUrl: url ??
//               "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
//           fit: fit,
//           errorWidget: (context, url, error) {
//             if (showLetterOnError) {
//               return Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Get.isDarkMode
//                       ? Colors.white.applyOpacity(0.1)
//                       : Colors.white.applyOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     letter ?? "",
//                     style: Get.theme.textTheme.titleLarge
//                         ?.copyWith(color: Colors.white),
//                   ),
//                 ),
//               );
//             }
//             return FadeInImage.assetNetwork(
//               placeholder: 'assets/images/person.png',
//               image:
//                   "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
//               fit: fit,
//             );
//           },
//           placeholder: (_, __) => Shimmer.fromColors(
//             baseColor: Colors.grey[850]!,
//             highlightColor: Colors.grey[800]!,
//             child: Container(
//               height: width,
//               width: width,
//               color: Get.isDarkMode
//                   ? AppColorsDark.mainColor
//                   : AppColorsLight.mainColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ProfileImage {
  const ProfileImage(
      {this.url,
      this.height = 50,
      this.width = 50,
      this.radius = 999,
      this.fit = BoxFit.cover,
      this.showLetterOnError = false,
      this.letter});

  final String? url;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;
  final bool showLetterOnError;
  final String? letter;

  static Widget network({
    String? url,
    double height = 50,
    double width = 50,
    double radius = 999,
    BoxFit fit = BoxFit.cover,
    bool showLetterOnError = false,
    String? letter,
    Color? letterBackgroundColor,
    Color? letterColor,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.r),
        child: CachedNetworkImage(
          imageUrl: url ??
              "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
          fit: fit,
          errorWidget: (context, url, error) {
            if (showLetterOnError) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: (letterBackgroundColor ?? AppColors.mainColor)
                      .applyOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter ?? "",
                    style: Get.theme.textTheme.titleLarge
                        ?.copyWith(color: (letterColor ?? AppColors.mainColor)),
                  ),
                ),
              );
            }
            return FadeInImage.assetNetwork(
              placeholder: 'assets/images/person.png',
              image:
                  "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
              fit: fit,
            );
          },
          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey[850]!,
            highlightColor: Colors.grey[800]!,
            child: Container(
              height: width,
              width: width,
              color: Get.isDarkMode
                  ? AppColorsDark.mainColor
                  : AppColorsLight.mainColor,
            ),
          ),
        ),
      ),
    );
  }

  static Widget file(
      {required File file,
      double height = 50,
      double width = 50,
      double radius = 999,
      BoxFit fit = BoxFit.cover,
      bool showLetterOnError = false,
      String? letter}) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.r),
        child: Image.file(
          file,
          fit: fit,
          errorBuilder: (context, url, error) {
            if (showLetterOnError) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.white.applyOpacity(0.1)
                      : Colors.white.applyOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter ?? "",
                    style: Get.theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              );
            }
            return FadeInImage.assetNetwork(
              placeholder: 'assets/images/person.png',
              image:
                  "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
              fit: fit,
            );
          },
          // placeholder: (_, __) => Shimmer.fromColors(
          //   baseColor: Colors.grey[850]!,
          //   highlightColor: Colors.grey[800]!,
          //   child: Container(
          //     height: width,
          //     width: width,
          //     color: Get.isDarkMode
          //         ? AppColorsDark.mainColor
          //         : AppColorsLight.mainColor,
          //   ),
          // ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     height: height,
  //     width: width,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(radius.r),
  //       child: CachedNetworkImage(
  //         imageUrl: url ??
  //             "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
  //         fit: fit,
  //         errorWidget: (context, url, error) {
  //           if (showLetterOnError) {
  //             return Container(
  //               height: height,
  //               width: width,
  //               decoration: BoxDecoration(
  //                 color: Get.isDarkMode
  //                     ? Colors.white.applyOpacity(0.1)
  //                     : Colors.white.applyOpacity(0.3),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   letter ?? "",
  //                   style: Get.theme.textTheme.titleLarge
  //                       ?.copyWith(color: Colors.white),
  //                 ),
  //               ),
  //             );
  //           }
  //           return FadeInImage.assetNetwork(
  //             placeholder: 'assets/images/person.png',
  //             image:
  //                 "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
  //             fit: fit,
  //           );
  //         },
  //         placeholder: (_, __) => Shimmer.fromColors(
  //           baseColor: Colors.grey[850]!,
  //           highlightColor: Colors.grey[800]!,
  //           child: Container(
  //             height: width,
  //             width: width,
  //             color: Get.isDarkMode
  //                 ? AppColorsDark.mainColor
  //                 : AppColorsLight.mainColor,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

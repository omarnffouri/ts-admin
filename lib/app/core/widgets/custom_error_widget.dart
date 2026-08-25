import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorDetails});
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.icons.error404,
                height: Get.height * 0.35,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                kDebugMode
                    ? errorDetails.summary.toString()
                    : 'Oups! Something went wrong!',
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: kDebugMode ? AppColorsLight.mainColor : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "We encountered an error and we've notified our engineering team about it. Sorry for the inconvenience caused.",
                textAlign: TextAlign.center,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_theme.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_theme.dart';
import 'package:ts_admin/app/core/widgets/custom_error_widget.dart';

import 'app/core/resources/app_colors.dart';
import 'app/routes/app_pages.dart';
import 'app/services/injection_service.dart' as di;

/// Enables DevicePreview (device-frame preview) in debug builds. Ignored in release.
const bool enablePreview = false;

/// starter function
/// initalizing local db [GetStorage]
/// initalizing  usecases, repositories, datasorces, network configs, pusher manager.
void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // debugPrint is NOT stripped in release — silence it app-wide there.
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }

    /// init localDB [GetStorage].
    await di.initLocalDb();

    /// init DI, This will initialize the all the usecases, repositories, datasorces, network configs, pusher manager.
    await di.init();

    /// init FCM services for listening message in foreground and background mode
    await di.initFirebase();

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    runApp(
      kReleaseMode
          ? Application(key: UniqueKey())
          : MediaQuery.fromView(
              view: WidgetsBinding.instance.platformDispatcher.implicitView!,
              child: SafeArea(
                top: false,
                child: DevicePreview(
                  enabled: enablePreview,
                  builder: (_) => Application(key: UniqueKey()),
                ),
              ),
            ),
    );
  }, (e, st) {
    FirebaseCrashlytics.instance.recordError(e, st, fatal: true);
    debugPrint('Error: ${e.toString()}\nStackTrace: ${st.toString()}');
  });
}

/// Main application widget which contains a [GetMaterialApp]
class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomErrorWidget(errorDetails: errorDetails);
        };
        return Obx(
          () => GetMaterialApp(
            title: "TS Admin",
            useInheritedMediaQuery: true,
            builder: (context, child) {
              Widget app = GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child ?? const SizedBox.shrink(),
              );
              if (!kReleaseMode) {
                app = DevicePreview.appBuilder(context, app);
              }
              return app;
            },
            color: AppColorsLight.mainColor,
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: appTheme,
            darkTheme: darkTheme,
            themeMode: themeController.isDarkMode == true
                ? ThemeMode.dark
                : themeController.isDarkMode == false
                    ? ThemeMode.light
                    : ThemeMode.system,
            fallbackLocale: const Locale('en', 'US'),
            localizationsDelegates: const [
              FlutterQuillLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }
}

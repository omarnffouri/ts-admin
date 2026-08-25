import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';

class BiometricHelper {
  //
  //
  // function that will check biometric is available or not
  static Future<bool> isBiometricAvailable() async {
    try {
      final LocalAuthentication localAuth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics =
          await localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics && await localAuth.isDeviceSupported();

      if (canAuthenticate) {
        final List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.face) ||
            availableBiometrics.contains(BiometricType.strong)) {
          return true;
        }
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  //
  //
  // function will request for authentication and return true if auth is successful
  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to proceed further.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == "LockedOut") {
        CommonWidgets.showSnackBar(
          title: "Biometric Error",
          message: "Too many wrong attempts. Please try after few minutes.",
          isError: Get.isDarkMode,
        );
      } else {
        CommonWidgets.showSnackBar(
          title: "Biometric Error",
          message:
              "Something went wrong with biometric. Please try after few minutes.",
          isError: Get.isDarkMode,
        );
      }
      return false;
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Biometric Error",
        message:
            "Something went wrong with biometric. Please try after few minutes.",
        isError: Get.isDarkMode,
      );
      return false;
    }
  }
}

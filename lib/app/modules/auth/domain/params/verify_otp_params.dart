class VerifyOtpParams {
  String otp;
  final String email;
  final String password;
  final String fcm;
  final String platform;
  final String deviceId;
  final String deviceName;
  final bool rememberMe;
  final bool fromBiometric;

  VerifyOtpParams({
    required this.otp,
    required this.email,
    required this.password,
    required this.fcm,
    required this.platform,
    required this.deviceId,
    required this.deviceName,
    this.rememberMe = false,
    this.fromBiometric = false,
  });

  Map<String, String> toJson() {
    return {
      "code": otp,
      "email": email,
      "password": password,
      "fcm": fcm,
      "platform": platform,
      "device_name": deviceName,
      "device_id": deviceId,
    };
  }
}

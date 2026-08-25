// ignore_for_file: constant_identifier_names

// server base url
import 'package:get_storage/get_storage.dart';

const String SERVER_FAILURE_MESSAGE = 'Please try again later .';
const String EMPTY_CACHE_FAILURE_MESSAGE = 'No Data';
const String OFFLINE_FAILURE_MESSAGE = 'Please Check your Internet Connection';

const String USER_DATA = "userData";
const String SSN = "userName";
const String MOBILE = "mobileNumber";
const String REMEMBERME = "rememberMe";
const String LANG_CODE = "langCode";
const String IS_AUTHENTICATED = "is_authenticated";
const String isClockServiceRunning = 'isClockTrackServiceRunning';
const String uuId = 'uuId';

typedef MapBody = Map<String, dynamic>;

class CommonVariables {
  static GetStorage userData = GetStorage();
  static GetStorage settings = GetStorage();
  static GetStorage tracking = GetStorage();
}

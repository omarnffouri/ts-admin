// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';

dio.Response<dynamic> responseHandler(
  dio.Response<dynamic> response,
) {
  final authController = Get.find<AuthController>();
  switch (response.statusCode) {
    case 200:
    case 201:
    case 202:
      // Backend also signals failures in-band: HTTP 200 whose envelope
      // carries a non-2xx `code`. Surface those as failures too so
      // controllers never mistake them for empty data.
      final dynamic body = response.data;
      final dynamic bodyCode = body is Map ? body['code'] : null;
      if (bodyCode is int && (bodyCode < 200 || bodyCode > 299)) {
        throw ServerException(
            message: (body['message'] as String?) ??
                'Something went wrong, try again $bodyCode');
      }
      return response;
    case 400:
      return throw ServerException(
          message: response.data?["message"] ??
              response.data['data']['errors'][0]['message'] ??
              "Something Went wrong, try again 400");
    case 401:
      debugPrint('401');
      authController.logout(callApi: false);
      return throw ServerException(
          message: 'Autherization problem, Please login agian');
    case 422:
      return throw ServerException(
          message: response.data?["message"] ??
              response.data['data']['errors'][0]['message'] ??
              "Something Went wrong, try again 422");
    case 403:
      return throw ServerException(
        message: response.data?["message"] ??
            'Error occurred please check internet and retry.',
      );
    case 404:
      return throw ServerException(message: 'Url not found');
    case 500:
      return throw ServerException(message: "Server Error please retry later");
    default:
      return throw ServerException(
          message: 'Something Went wrong, try again ${response.statusCode}');
  }
}

import 'dart:developer';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';

import '../../enum/http_request_type.dart';
import '../error/failures.dart';
import '../../values/constants.dart';
import 'api_constants.dart';
import 'http_handler.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClient {
  // The singleton instance
  static final DioClient _instance = DioClient._internal();

  /// Routes sent without an Authorization header. Matched against
  /// `options.path` verbatim, so call sites must pass these constants as-is.
  static const Set<String> _publicPaths = {
    ApiConstants.login,
    ApiConstants.verifyOtp,
  };

  // Private constructor
  DioClient._internal();

  // Factory constructor to return the singleton instance
  factory DioClient() {
    return _instance;
  }
  // Single instance so requests reuse one connection pool (keep-alive).
  // ignore: non_constant_identifier_names
  late final Dio DIO_CLIENT = _buildDio();

  Dio _buildDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.kServerURL,
        contentType: ApiConstants.jsonContentType,
        headers: {
          ApiConstants.acceptHeader: ApiConstants.jsonContentType,
          ApiConstants.platformHeader: ApiConstants.platformHeaderValue,
        },
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) {
          final String? token = CommonVariables.settings
              .read<String>(AuthenticationPrefKeys.token);
          if (!_publicPaths.contains(options.path) &&
              token != null &&
              token.isNotEmpty) {
            options.headers[ApiConstants.authorizationHeader] =
                ApiConstants.bearer(token);
          }
          return handler.next(options);
        },
        onResponse: (
          Response<dynamic> e,
          ResponseInterceptorHandler handler,
        ) {
          try {
            final Response<dynamic> result = responseHandler(e);
            return handler.next(result);
          } catch (e) {
            final DioException error = DioException(
                requestOptions: RequestOptions(path: ''), error: e);
            return handler.reject(error);
          }
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.response != null) {
            responseHandler(e.response!);
          }
          return handler.reject(e);
        },
      ),
    );
    // Debug-only request logger — uncomment the debugPrint below to enable.
    if (kDebugMode) {
      dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
          logger: (log) {
            // debugPrint(log);
          },
        ),
      );
    }
    return dio;
  }

  Future<Either<T, Failure>> makeRequest<T>({
    required String url,
    RequestType method = RequestType.GET,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options,
    required ResponseConverter<T> converter,
    bool isIsolate = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      Stopwatch stopwatch = Stopwatch();
      stopwatch.start();

      Response<dynamic> response;
      switch (method) {
        case RequestType.POST:
          response = await DIO_CLIENT.post(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.PUT:
          response = await DIO_CLIENT.put(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.PATCH:
          response = await DIO_CLIENT.patch(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.DELETE:
          response = await DIO_CLIENT.delete(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          );
          break;
        default:
          response = await DIO_CLIENT.get(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          );
      }

      stopwatch.stop();
      if (kDebugMode) {
        log('$url request time >>> ${stopwatch.elapsedMilliseconds / 1000.0}');
      }
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Left(converter(response.data));
      }

      final result = await compute(converter, response.data);
      return Left(result);
    } on ServerException catch (e) {
      return Right(ServerFailure(title: "Error", message: e.message));
    } on DioException catch (e) {
      // if response have data then check if it contains a
      //message field in resposne so dislpay message
      if (e.response?.data != null) {
        final errorBody = e.response!.data;
        // if error body have a message then return a error message else
        // default error message
        if (errorBody['message'] != null) {
          return Right(
            ServerFailure(
              title: "",
              message: (errorBody['message'] as String?) ??
                  "Unknown error occurred.",
            ),
          );
        }
        return const Right(
          ServerFailure(
            title: '',
            message: "Something went wrong.",
          ),
        );
      } else {
        if (e.error is ServerException) {
          return Right(ServerFailure(
              title: "Error", message: (e.error as ServerException).message));
        }
        return const Right(
          ServerFailure(
            title: '',
            message: "Something went wrong.",
          ),
        );
      }
    }
  }
}

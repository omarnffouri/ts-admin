import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/call_event_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/edit_message_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/forward_message_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/message_mark_as_read_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/message_sent_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/call_event_param.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/edit_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/forward_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/react_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_files_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_text_message_params.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' as media_parser;

abstract class ISendMessageRemoteDataSource {
  Future<Either<MessageSentModel, Failure>> sendTextMessage(
      SendTextMessageParams params);
  Future<Either<MessageSentModel, Failure>> sendFileMessage(
      SendFilesMessageParams params);
  Future<Either<MessageMarkAsReadModel, Failure>> markMessageAsRead(
      String messageId);
  Future<Either<ForwardMessageModel, Failure>> forwardMessage(
      ForwardMessageParams params);
  Future<Either<EditMessageModel, Failure>> editTextMessage(
      EditTextMessageParams params);
  Future<Either<BaseResponse<bool>, Failure>> reactOnMessage(
      ReactMessageParams params);
  Future<Either<BaseResponse<bool>, Failure>> deleteMessage(int params);
  Future<Either<CallEventModel, Failure>> emitEvent(CallEventParam params);
}

class SendMessageRemoteDataSourceImpl implements ISendMessageRemoteDataSource {
  final DioClient dioClient;
  SendMessageRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<MessageSentModel, Failure>> sendTextMessage(
      SendTextMessageParams params) async {
    try {
      Map<String, dynamic> toApis = {
        'message': params.message,
        'type': params.type,
        'temp_id': params.tempId
      };
      //
      if (params.replyOnMessageId != null) {
        toApis['reply_on_id'] = params.replyOnMessageId;
      }
      if (params.latitude != null && params.longitude != null) {
        toApis['location'] = {
          'lat': params.latitude,
          'lng': params.longitude,
        };
      }
      if (params.type == MessageTypes.gif && params.gifInfo != null) {
        toApis['gif_info'] = params.gifInfo;
      }
      //
      // addmin mentions
      if (params.mentions?.isNotEmpty ?? false) {
        // convert to json string and add them in request data body
        try {
          final mentions =
              jsonEncode(params.mentions?.map((e) => e.toJson()).toList());
          toApis['mentions'] = mentions;
        } catch (_) {}
      }

      // api call
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.postMessage}/${params.conversationId}',
        method: RequestType.POST,
        data: toApis,
        converter: (response) {
          try {
            return MessageSentModel.fromJson(response);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<MessageSentModel, Failure>> sendFileMessage(
      SendFilesMessageParams params) async {
    try {
      if (params.type != MessageTypes.audio &&
          params.type != MessageTypes.video &&
          params.type != MessageTypes.image &&
          params.type != MessageTypes.attachment &&
          params.type != MessageTypes.recorded) {
        throw Exception("Message invalid type provide for file message.");
      }
      if (params.files?.isEmpty ?? true) {
        throw Exception("No file provide for file message.");
      }

      // declaring variables
      Map<String, dynamic> dataMap = {};

      // converting files to base64 string and adding them to list
      for (int i = 0; i < params.files!.length; i++) {
        final multipartFile = MultipartFile.fromFileSync(params.files![i].path,
            filename: getFileNameWithExtenshion(params.files![i].path));

        // checking types and adding data to dataMap
        if (params.type == MessageTypes.image) {
          dataMap['messageImages[$i][file]'] = multipartFile;
        } else if (params.type == MessageTypes.recorded) {
          final filePath = params.files![i].path;
          final fileName = getFileNameWithExtenshion(filePath);

          // Determine content type based on file extension
          media_parser.MediaType contentType;
          if (filePath.endsWith('.mp3')) {
            contentType = media_parser.MediaType('audio', 'mpeg');
          } else if (filePath.endsWith('.wav')) {
            contentType = media_parser.MediaType('audio', 'wav');
          } else if (filePath.endsWith('.m4a') || filePath.endsWith('.aac')) {
            contentType = media_parser.MediaType('audio', 'mpeg');
          } else {
            // Default fallback
            contentType = media_parser.MediaType('audio', 'mpeg');
          }

          final multipartAudioFile = MultipartFile.fromFileSync(
            filePath,
            filename: fileName,
            contentType: contentType,
          );

          dataMap['messageFiles[$i][file]'] = multipartAudioFile;
        } else {
          dataMap['messageFiles[$i][file]'] = multipartFile;
        }
      }

      // adding required things
      dataMap['message'] = params.message;
      dataMap['type'] = params.type;
      dataMap['temp_id'] = params.tempId;

      if (params.replyOnMessageId != null) {
        dataMap['reply_on_id'] = params.replyOnMessageId;
      }

      //
      // addmin mentions
      if (params.mentions?.isNotEmpty ?? false) {
        // convert to json string and add them in request data body
        try {
          final mentions =
              jsonEncode(params.mentions?.map((e) => e.toJson()).toList());
          dataMap['mentions'] = mentions;
        } catch (_) {}
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dioClient.DIO_CLIENT.post(
        '${ApiConstants.postMessage}/${params.conversationId}',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        onSendProgress: (count, total) {
          if (params.progressListener != null) {
            params.progressListener!(((count / total) * 100).toInt());
          }
        },
      );

      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      try {
        return Left(MessageSentModel.fromJson(response.data));
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<Either<MessageMarkAsReadModel, Failure>> markMessageAsRead(
      String messageId) async {
    try {
      final response = await dioClient.makeRequest(
          url: ApiConstants.markMessageAsRead,
          method: RequestType.POST,
          data: {"id": messageId},
          converter: (response) {
            try {
              return MessageMarkAsReadModel.fromJson(response);
            } catch (e) {
              throw Exception(e);
            }
          });

      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<Either<ForwardMessageModel, Failure>> forwardMessage(
      ForwardMessageParams params) async {
    try {
      // api call
      final response = await dioClient.makeRequest(
        url: ApiConstants.forwardMessage,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          try {
            return ForwardMessageModel.fromJson(response);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<EditMessageModel, Failure>> editTextMessage(
      EditTextMessageParams params) async {
    try {
      // api call
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.editMessage}/${params.messageId}",
        method: RequestType.POST,
        data: {"message": params.message},
        converter: (response) {
          try {
            return EditMessageModel.fromJson(response);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> reactOnMessage(
      ReactMessageParams params) async {
    try {
      // api call
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.reactMessage}/${params.messageId}",
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          try {
            return BaseResponse.fromJson(response, (data) {
              return (response['error'] == false);
            });
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> deleteMessage(int params) async {
    try {
      // api call
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.deleteMessage}/$params/delete",
        method: RequestType.DELETE,
        converter: (response) {
          try {
            return BaseResponse.fromJson(response, (data) {
              return (response['error'] == false);
            });
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<CallEventModel, Failure>> emitEvent(
      CallEventParam params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.callEvent,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          try {
            return CallEventModel.fromJson(response);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

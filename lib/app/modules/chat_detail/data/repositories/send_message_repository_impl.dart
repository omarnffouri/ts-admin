import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/call_event_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/datasources/send_message_remote_data_source.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/edit_message_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/forward_message_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/call_event_param.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/edit_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/forward_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/react_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_files_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/message_mark_as_read_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/message_sent_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/send_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/send_message_repository.dart';

import '../../../../services/injection_service.dart';

class SendMessageRepositoryImpl extends ISendMessageRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  final ISendMessageRemoteDataSource sendMessageRemoteDataSource;

  SendMessageRepositoryImpl({required this.sendMessageRemoteDataSource});

  @override
  Future<Either<MessageSentEntity, Failure>> sendTextMessage(
      SendTextMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final sendMessageResponse =
            await sendMessageRemoteDataSource.sendTextMessage(params);
        return sendMessageResponse.fold(
          (messageSent) => Left(messageSent),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<MessageSentEntity, Failure>> sendFileMessage(
      SendFilesMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final sendMessageResponse =
            await sendMessageRemoteDataSource.sendFileMessage(params);
        return sendMessageResponse.fold(
          (messageSent) => Left(messageSent),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<MessageMarkAsReadEntity, Failure>> markMessageAsRead(
      String messageId) async {
    if (await networkInfo.isConnected) {
      try {
        final messageMarkAsReadResponse =
            await sendMessageRemoteDataSource.markMessageAsRead(messageId);
        return messageMarkAsReadResponse.fold(
          (messageRead) => Left(messageRead),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<ForwardMessageEntity, Failure>> forwardMessage(
      ForwardMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final forwardMessageResponse =
            await sendMessageRemoteDataSource.forwardMessage(params);
        return forwardMessageResponse.fold(
          (messageForward) => Left(messageForward),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<EditMessageEntity, Failure>> editTextMessage(
      EditTextMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final editMessageResponse =
            await sendMessageRemoteDataSource.editTextMessage(params);
        return editMessageResponse.fold(
          (messageForward) => Left(messageForward),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> reactOnMessage(
      ReactMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final reactMessageResponse =
            await sendMessageRemoteDataSource.reactOnMessage(params);
        return reactMessageResponse.fold(
          (reactMessage) => Left(reactMessage),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> deleteMessage(int params) async {
    if (await networkInfo.isConnected) {
      try {
        final deleteMessageResponse =
            await sendMessageRemoteDataSource.deleteMessage(params);
        return deleteMessageResponse.fold(
          (deleteMessage) => Left(deleteMessage),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<CallEventModel, Failure>> emitEvent(
      CallEventParam params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await sendMessageRemoteDataSource.emitEvent(params);
        return response.fold(
          (callEvent) => Left(callEvent),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}

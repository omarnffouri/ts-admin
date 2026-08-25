import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/chat_info_tags_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/get_previous_messages_params.dart';

import '../../../../services/injection_service.dart';
import '../../domain/repositories/conversation_details_repository.dart';
import '../datasources/conversation_details_remote_data_source.dart';

class ConversationDetailsRepositoryImpl extends IConversationDetailsRepository {
  ConversationDetailsRepositoryImpl(
      {required this.conversationDetailsRemoteDataSource});

  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());
  final IConversationDetailsRemoteDataSource
      conversationDetailsRemoteDataSource;

  @override
  Future<Either<ConversationDetailsEntity, Failure>> getConversationDetails(
      String conversationId) async {
    if (await networkInfo.isConnected) {
      try {
        final conversationDetailsResponse =
            await conversationDetailsRemoteDataSource
                .getConversationDetails(conversationId);
        return conversationDetailsResponse.fold(
          (conversationDeatils) => Left(conversationDeatils),
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
  Future<Either<List<ConversationMessageEntity>, Failure>> getPreviousMessages(
      GetPreviousMessagesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final previousMessagesResponse =
            await conversationDetailsRemoteDataSource
                .getPreviousMessages(params);
        return previousMessagesResponse.fold(
          (previousMessages) => Left(previousMessages),
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
  Future<Either<ChatInfoTagsEntity, Failure>> getChatInfoTags(
      String tagType) async {
    if (await networkInfo.isConnected) {
      try {
        final infoTagsResponse =
            await conversationDetailsRemoteDataSource.getChatInfoTags(tagType);
        return infoTagsResponse.fold(
          (tags) => Left(tags),
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

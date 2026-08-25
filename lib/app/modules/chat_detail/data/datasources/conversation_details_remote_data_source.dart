import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/chat_info_tags_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/get_previous_messages_params.dart';

abstract class IConversationDetailsRemoteDataSource {
  Future<Either<ConversationDetailsEntity, Failure>> getConversationDetails(
      String conversationId);

  Future<Either<List<ConversationMessageEntity>, Failure>> getPreviousMessages(
      GetPreviousMessagesParams params);

  Future<Either<ChatInfoTagsModel, Failure>> getChatInfoTags(String tagType);
}

class ConversationDetailsRemoteDataSourceImpl
    implements IConversationDetailsRemoteDataSource {
  final DioClient dioClient;
  ConversationDetailsRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<ConversationDetailsEntity, Failure>> getConversationDetails(
      String conversationId) async {
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.getConversationDetails}/$conversationId',
        method: RequestType.GET,
        converter: (response) {
          try {
            return ConversationDetailsModel.fromJson(response);
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
  Future<Either<List<ConversationMessageEntity>, Failure>> getPreviousMessages(
      GetPreviousMessagesParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.getConversationDetails}/${params.conversationId}',
        method: RequestType.GET,
        queryParams: {
          'lastMessageId': params.lastMessageId,
          'perPage': params.perPage,
        },
        converter: (response) {
          try {
            return ConversationDetailsModel.fromJson(response).messages ?? [];
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
  Future<Either<ChatInfoTagsModel, Failure>> getChatInfoTags(
      String tagType) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.chatInfoTags,
        method: RequestType.GET,
        queryParams: {'tagType': tagType},
        converter: (response) {
          try {
            return ChatInfoTagsModel.fromJson(response);
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

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/modules/chat/data/models/add_participants_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/archive_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/contact_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/create_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/create_group_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/group_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/message_notification_response_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/remove_participants_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/update_group_logo_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/update_group_name_model.dart';
import 'package:ts_admin/app/modules/chat/domain/params/add_participants_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/archive_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/buzz_message_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_group_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_logo_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_name_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_participant_params.dart';

import '../../../../core/enum/http_request_type.dart';

abstract class IConversationRemoteDataSource {
  Future<Either<List<ConversationModel>, Failure>> getAllConversations();
  Future<Either<List<ContactModel>, Failure>> getAllContacts();
  Future<Either<GroupContactsModel, Failure>> getGroupContacts();
  Future<Either<CreateConversationModel, Failure>> createNewConversation(
      CreateConversationParams params);
  Future<Either<CreateGroupModel, Failure>> createGroup(
      CreateGroupParams params);
  Future<Either<AddParticipantsModel, Failure>> addParticipants(
      AddParticipantsParams params);
  Future<Either<RemoveParticipantsModel, Failure>> removeParticipants(
      int participantId);
  Future<Either<List<GroupConversationModel>, Failure>>
      getAllGroupConversations();

  Future<Either<List<GroupConversationModel>, Failure>> getGroupHeads();
  Future<Either<GroupConversationModel, Failure>> getGroupConversationDetails(
      int id);
  Future<Either<ArchiveConversationModel, Failure>> archiveConversation(
      ArchiveConversationParams params);
  Future<Either<UpdateGroupNameModel, Failure>> updateGroupName(
      UpdateGroupNameParams params);

  Future<Either<UpdateGroupLogoModel, Failure>> updateGroupLogo(
      UpdateGroupLogoParams params);

  Future<Either<BaseResponse<bool>, Failure>> updateParticipant(
      UpdateParticipantParams params);

  Future<Either<BaseResponse<bool>, Failure>> muteConversation(
      MuteConversationParams params);

  Future<Either<BaseResponse<bool>, Failure>> buzzMessage(
      BuzzMessageParams params);

  Future<Either<MessageNotificationResponseModel, Failure>>
      getMessageNotifications(Map<String, dynamic> params);
}

class ConversationRemoteDataSourceImpl
    implements IConversationRemoteDataSource {
  final DioClient dioClient;
  ConversationRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<List<ConversationModel>, Failure>> getAllConversations() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getConversations,
        method: RequestType.GET,
        converter: (response) {
          try {
            return (response as List)
                .map((e) => ConversationModel.fromJson(e))
                .toList();
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
  Future<Either<List<ContactModel>, Failure>> getAllContacts() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getContacts,
        method: RequestType.GET,
        converter: (response) {
          try {
            return (response as List)
                .map((e) => ContactModel.fromJson(e))
                .toList();
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
  Future<Either<GroupContactsModel, Failure>> getGroupContacts() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getContacts,
        method: RequestType.GET,
        queryParams: {'type': 'group_by_head'},
        converter: (response) {
          try {
            return GroupContactsModel.fromJson(response);
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
  Future<Either<CreateConversationModel, Failure>> createNewConversation(
      CreateConversationParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url:
            '${ApiConstants.createConversation}/${params.userType}/${params.userId}',
        method: RequestType.GET,
        converter: (response) {
          try {
            return CreateConversationModel.fromJson(response);
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
  Future<Either<List<GroupConversationModel>, Failure>>
      getAllGroupConversations() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getGroupConversations,
        queryParams: {'type': 'group_by_head'},
        method: RequestType.GET,
        converter: (response) {
          try {
            return (response as List)
                .map((e) => GroupConversationModel.fromJson(e))
                .toList();
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
  Future<Either<List<GroupConversationModel>, Failure>> getGroupHeads() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getGroupHeads,
        queryParams: {'type': 'group_by_head', 'with_cursor': 1},
        method: RequestType.GET,
        converter: (response) {
          try {
            return (response as List)
                .map((e) => GroupConversationModel.fromJson(e))
                .toList();
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
  Future<Either<GroupConversationModel, Failure>> getGroupConversationDetails(
      int id) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getSubGroup,
        queryParams: {'id': id},
        method: RequestType.GET,
        converter: (response) {
          try {
            return GroupConversationModel.fromJson(response);
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
  Future<Either<CreateGroupModel, Failure>> createGroup(
      CreateGroupParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createGroup,
        data: params.toMap(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return CreateGroupModel.fromJson(response);
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
  Future<Either<AddParticipantsModel, Failure>> addParticipants(
      AddParticipantsParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.addParticipant,
        data: params.toMap(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return AddParticipantsModel.fromJson(response);
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
  Future<Either<RemoveParticipantsModel, Failure>> removeParticipants(
      int participantId) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.removeParticipant,
        data: {'participant_id': participantId},
        method: RequestType.POST,
        converter: (response) {
          try {
            return RemoveParticipantsModel.fromJson(response);
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
  Future<Either<ArchiveConversationModel, Failure>> archiveConversation(
      ArchiveConversationParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: '${ApiConstants.archiveConversation}/${params.conversationId}',
        data: {'status': params.type},
        method: RequestType.POST,
        converter: (response) {
          try {
            return ArchiveConversationModel.fromJson(response);
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
  Future<Either<UpdateGroupNameModel, Failure>> updateGroupName(
      UpdateGroupNameParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateGroupName,
        data: params.toJson(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return UpdateGroupNameModel.fromJson(response);
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
  Future<Either<UpdateGroupLogoModel, Failure>> updateGroupLogo(
      UpdateGroupLogoParams params) async {
    try {
      Map<String, dynamic> dataMap = {};

      // adding required things
      dataMap['group_head_id'] = params.groupId;

      final multipartAudioFile = MultipartFile.fromFileSync(params.file.path,
          filename: getFileNameWithExtenshion(params.file.path));

      dataMap['file'] = multipartAudioFile;

      final formData = FormData.fromMap(dataMap);

      final response = await dioClient.makeRequest(
        url: ApiConstants.updateGroupLogo,
        data: formData,
        method: RequestType.POST,
        converter: (response) {
          try {
            return UpdateGroupLogoModel.fromJson(response);
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
  Future<Either<BaseResponse<bool>, Failure>> updateParticipant(
      UpdateParticipantParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateParticipant,
        data: params.toJson(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return BaseResponse.fromJson(response, (json) {
              return response['code'] == 200;
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
  Future<Either<BaseResponse<bool>, Failure>> muteConversation(
      MuteConversationParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.muteConversations,
        data: params.toJson(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return BaseResponse.fromJson(response, (json) {
              return response['code'] == 200;
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
  Future<Either<BaseResponse<bool>, Failure>> buzzMessage(
      BuzzMessageParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.buzzMessage}/${params.converstionId}",
        data: params.toMap(),
        method: RequestType.POST,
        converter: (response) {
          try {
            return BaseResponse.fromJson(response, (json) {
              return response['code'] == 200;
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
  Future<Either<MessageNotificationResponseModel, Failure>>
      getMessageNotifications(Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getMessageNotifications,
        data: params,
        method: RequestType.POST,
        converter: (response) {
          try {
            return MessageNotificationResponseModel.fromJson(response);
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

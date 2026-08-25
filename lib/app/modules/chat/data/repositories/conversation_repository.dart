import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/data/data_sources/conversation_remote_data_source.dart';
import 'package:ts_admin/app/modules/chat/data/models/add_participants_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/contact_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/create_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/create_group_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/group_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/message_notification_response_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/remove_participants_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_logo_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_name_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/add_participants_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/archive_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/buzz_message_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_group_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_logo_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_name_params.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_participant_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

import '../../../../services/injection_service.dart';

class ConversationRepositoryImpl implements IConversationRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  IConversationRemoteDataSource conversationDataSource;

  ConversationRepositoryImpl({required this.conversationDataSource});

  @override
  Future<Either<List<ConversationModel>, Failure>> getAllConversations() async {
    if (await networkInfo.isConnected) {
      try {
        final documentsResponse =
            await conversationDataSource.getAllConversations();
        return documentsResponse.fold(
          (conversations) => Left(conversations),
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
  Future<Either<List<ContactModel>, Failure>> getAllContacts() async {
    if (await networkInfo.isConnected) {
      try {
        final contactsResponse = await conversationDataSource.getAllContacts();
        return contactsResponse.fold(
          (contacts) => Left(contacts),
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
  Future<Either<GroupContactsModel, Failure>> getGroupContacts() async {
    if (await networkInfo.isConnected) {
      try {
        final contactsResponse =
            await conversationDataSource.getGroupContacts();
        return contactsResponse.fold(
          (contacts) => Left(contacts),
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
  Future<Either<CreateConversationModel, Failure>> createNewConversation(
      CreateConversationParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final newConversationResponse =
            await conversationDataSource.createNewConversation(params);
        return newConversationResponse.fold(
          (newConversation) => Left(newConversation),
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
  Future<Either<List<GroupConversationModel>, Failure>>
      getAllGroupConversations() async {
    if (await networkInfo.isConnected) {
      try {
        final groupConversationsResponse =
            await conversationDataSource.getAllGroupConversations();
        return groupConversationsResponse.fold(
          (groupConversations) => Left(groupConversations),
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
  Future<Either<CreateGroupModel, Failure>> createGroup(
      CreateGroupParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final newGroupResponse =
            await conversationDataSource.createGroup(params);
        return newGroupResponse.fold(
          (newGroup) => Left(newGroup),
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
  Future<Either<AddParticipantsModel, Failure>> addParticipants(
      AddParticipantsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final addPartcipantsResponse =
            await conversationDataSource.addParticipants(params);
        return addPartcipantsResponse.fold(
          (participants) => Left(participants),
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
  Future<Either<RemoveParticipantsModel, Failure>> removeParticipants(
      int participantId) async {
    if (await networkInfo.isConnected) {
      try {
        final removeParticipantsResponse =
            await conversationDataSource.removeParticipants(participantId);
        return removeParticipantsResponse.fold(
          (removePartcipants) => Left(removePartcipants),
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
  Future<Either<ArchiveConversationEntity, Failure>> archiveConversation(
      ArchiveConversationParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await conversationDataSource.archiveConversation(params);
        return response.fold(
          (status) => Left(status),
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
  Future<Either<UpdateGroupNameEntity, Failure>> updateGroupName(
      UpdateGroupNameParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await conversationDataSource.updateGroupName(params);
        return response.fold(
          (status) => Left(status),
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
  Future<Either<List<GroupConversationEntity>, Failure>> getGroupHeads() async {
    if (await networkInfo.isConnected) {
      try {
        final groupConversationsResponse =
            await conversationDataSource.getGroupHeads();
        return groupConversationsResponse.fold(
          (groupConversations) => Left(groupConversations),
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
  Future<Either<GroupConversationEntity, Failure>> getGroupConversationDetails(
      int id) async {
    if (await networkInfo.isConnected) {
      try {
        final groupConversationResponse =
            await conversationDataSource.getGroupConversationDetails(id);
        return groupConversationResponse.fold(
          (groupConversation) => Left(groupConversation),
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
  Future<Either<UpdateGroupLogoEntity, Failure>> updateGroupLogo(
      UpdateGroupLogoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final groupLogoResponse =
            await conversationDataSource.updateGroupLogo(params);
        return groupLogoResponse.fold(
          (groupLogo) => Left(groupLogo),
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
  Future<Either<BaseResponse<bool>, Failure>> updateParticipant(
      UpdateParticipantParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final updateParticipantResponse =
            await conversationDataSource.updateParticipant(params);
        return updateParticipantResponse.fold(
          (updateParticipant) => Left(updateParticipant),
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
  Future<Either<BaseResponse<bool>, Failure>> muteConversation(
      MuteConversationParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await conversationDataSource.muteConversation(params);
        return response.fold(
          (data) => Left(data),
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
  Future<Either<BaseResponse<bool>, Failure>> buzzMessage(
      BuzzMessageParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await conversationDataSource.buzzMessage(params);
        return response.fold(
          (data) => Left(data),
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
  Future<Either<MessageNotificationResponseModel, Failure>>
      getMesssageNotifications(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await conversationDataSource.getMessageNotifications(params);
        return response.fold(
          (data) => Left(data),
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

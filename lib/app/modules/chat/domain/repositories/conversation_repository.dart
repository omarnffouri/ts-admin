import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/add_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_group_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/remove_participants_entity.dart';
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

abstract class IConversationRepository {
  Future<Either<List<ConversationEntity>, Failure>> getAllConversations();
  Future<Either<List<ContactEntity>, Failure>> getAllContacts();
  Future<Either<GroupContactsEntity, Failure>> getGroupContacts();
  Future<Either<CreateConversationEntity, Failure>> createNewConversation(
      CreateConversationParams params);
  Future<Either<CreateGroupEntity, Failure>> createGroup(
      CreateGroupParams params);
  Future<Either<List<GroupConversationEntity>, Failure>>
      getAllGroupConversations();
  Future<Either<List<GroupConversationEntity>, Failure>> getGroupHeads();
  Future<Either<GroupConversationEntity, Failure>> getGroupConversationDetails(
      int id);
  Future<Either<AddParticipantsEntity, Failure>> addParticipants(
      AddParticipantsParams params);
  Future<Either<RemoveParticipantsEntity, Failure>> removeParticipants(
      int participantId);
  Future<Either<ArchiveConversationEntity, Failure>> archiveConversation(
      ArchiveConversationParams params);
  Future<Either<UpdateGroupNameEntity, Failure>> updateGroupName(
      UpdateGroupNameParams params);

  Future<Either<UpdateGroupLogoEntity, Failure>> updateGroupLogo(
      UpdateGroupLogoParams params);

  Future<Either<BaseResponse<bool>, Failure>> updateParticipant(
      UpdateParticipantParams params);

  Future<Either<BaseResponse<bool>, Failure>> muteConversation(
      MuteConversationParams params);

  Future<Either<BaseResponse<bool>, Failure>> buzzMessage(
      BuzzMessageParams params);

  Future<Either<MessageNotificationResponseEntity, Failure>>
      getMesssageNotifications(Map<String, dynamic> params);
}

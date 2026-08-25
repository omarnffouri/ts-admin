// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendTextMessageParams {
  String conversationId;
  String message;
  String tempId;
  int? replyOnMessageId;
  String? type;
  List<MessageMention>? mentions;
  double? latitude;
  double? longitude;
  final Map<String, dynamic>? gifInfo;

  SendTextMessageParams({
    required this.conversationId,
    required this.message,
    required this.tempId,
    this.replyOnMessageId,
    this.mentions,
    this.latitude,
    this.type,
    this.longitude,
    this.gifInfo,
  });
}

class MessageMention {
  int pid;
  String modelType;
  int modelId;
  MessageMention(
      {required this.pid, required this.modelType, required this.modelId});

  Map<String, dynamic> toJson() {
    return {
      'id': pid,
      'model_id': modelId,
      'model_type': modelType,
    };
  }
}

class MessagesNotificationsDbModel {
  final int? id;
  final int? conversationId;
  final int? messageId;
  final bool viewed;
  final bool read;

  MessagesNotificationsDbModel({
    this.id,
    required this.conversationId,
    required this.messageId,
    required this.viewed,
    required this.read,
  });

  // Deserialize from DB or JSON map
  factory MessagesNotificationsDbModel.fromJson(Map<String, dynamic> json) {
    return MessagesNotificationsDbModel(
      id: json['id'] as int?,
      conversationId: json['conversation_id'] as int?,
      messageId: json['message_id'] as int?,
      viewed: (json['viewed'] ?? 0) == 1,
      read: (json['read'] ?? 0) == 1,
    );
  }

  // Serialize to DB or JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'message_id': messageId,
      'viewed': viewed ? 1 : 0,
      'read': read ? 1 : 0,
    };
  }
}

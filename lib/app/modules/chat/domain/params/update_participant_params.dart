class UpdateParticipantParams {
  final int pid;
  final int conversationId;
  final bool isGroupAdmin;
  UpdateParticipantParams({
    required this.conversationId,
    required this.pid,
    required this.isGroupAdmin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': pid,
      'conversation_id': conversationId,
      'is_group_admin': isGroupAdmin,
    };
  }
}

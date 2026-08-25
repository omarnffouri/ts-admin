class MuteConversationParams {
  String? muteDuration;
  List<int> conversations;
  MuteConversationParams({
    required this.muteDuration,
    required this.conversations,
  });

  Map<String, dynamic> toJson() {
    return {
      'mute_duration': muteDuration,
      'conversations': conversations,
    };
  }
}

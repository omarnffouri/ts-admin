class GetPreviousMessagesParams {
  String conversationId;
  String lastMessageId;
  int perPage;
  GetPreviousMessagesParams({
    required this.conversationId,
    required this.lastMessageId,
    this.perPage = 30,
  });
}

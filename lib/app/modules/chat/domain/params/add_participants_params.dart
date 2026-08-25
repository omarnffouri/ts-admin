class AddParticipantsParams {
  int groupId;
  String participantType;
  List<AddParticipantsPartcipantParams> participants;
  AddParticipantsParams({
    required this.groupId,
    required this.participantType,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'group_head_id': groupId,
      'participantType': participantType,
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }
}

class AddParticipantsPartcipantParams {
  int id;
  String modelType;
  AddParticipantsPartcipantParams({
    required this.id,
    required this.modelType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'model_type': modelType,
    };
  }
}

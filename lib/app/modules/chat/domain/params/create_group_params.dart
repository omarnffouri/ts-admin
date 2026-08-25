class CreateGroupParams {
  String groupName;
  bool autoAddDrivers;
  List<CreateGroupParticipantParams> adminParticipants;
  List<CreateGroupParticipantParams> applicantParticipants;
  CreateGroupParams({
    required this.groupName,
    required this.autoAddDrivers,
    required this.adminParticipants,
    required this.applicantParticipants,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'group_name': groupName,
      'auto_add_drivers': autoAddDrivers,
      'admin_participants': adminParticipants.map((x) => x.toMap()).toList(),
      'applicant_participants':
          applicantParticipants.map((x) => x.toMap()).toList(),
    };
  }
}

class CreateGroupParticipantParams {
  int modelId;
  String modelType;
  CreateGroupParticipantParams({
    required this.modelId,
    required this.modelType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model_id': modelId,
      'model_type': modelType,
    };
  }
}

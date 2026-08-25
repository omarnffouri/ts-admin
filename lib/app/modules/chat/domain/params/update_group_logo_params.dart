// To parse this JSON data, do
//

import 'dart:io';

class UpdateGroupLogoParams {
  final int groupId;
  final File file;

  const UpdateGroupLogoParams({
    required this.groupId,
    required this.file,
  });
}

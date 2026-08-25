import 'dart:convert';

import 'package:ts_admin/app/modules/storage/domain/entities/download_resource_entity.dart';

DownloadResourceModel downloadResourceModelFromJson(String str) =>
    DownloadResourceModel.fromJson(json.decode(str));

String downloadResourceModelToJson(DownloadResourceModel data) =>
    json.encode(data.toJson());

class DownloadResourceModel extends DownloadResourceEntity {
  const DownloadResourceModel({
    super.link,
  });

  factory DownloadResourceModel.fromJson(Map<String, dynamic> json) =>
      DownloadResourceModel(
        link: json["link"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "link": link,
      };
}

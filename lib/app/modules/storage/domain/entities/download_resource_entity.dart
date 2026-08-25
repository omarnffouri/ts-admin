import 'dart:convert';

import 'package:equatable/equatable.dart';

DownloadResourceEntity downloadResourceEntityFromJson(String str) =>
    DownloadResourceEntity.fromJson(json.decode(str));

String downloadResourceEntityToJson(DownloadResourceEntity data) =>
    json.encode(data.toJson());

class DownloadResourceEntity extends Equatable {
  final String? link;

  const DownloadResourceEntity({
    this.link,
  });

  factory DownloadResourceEntity.fromJson(Map<String, dynamic> json) =>
      DownloadResourceEntity(
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
      };

  @override
  List<Object?> get props => [link];
}

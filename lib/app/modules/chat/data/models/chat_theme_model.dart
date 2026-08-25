import 'dart:convert';

import '../../../../core/helpers/enum_values.dart';

ChatThemeModel chatThemeModelFromJson(String str) =>
    ChatThemeModel.fromJson(json.decode(str));

String chatThemeModelToJson(ChatThemeModel data) => json.encode(data.toJson());

class ChatThemeModel {
  final ChatThemeType? type;
  final String? image;
  final int? color;
  final bool? patternEnabled;
  final double? brightness;

  ChatThemeModel({
    this.type,
    this.image,
    this.color,
    this.patternEnabled,
    this.brightness,
  });

  factory ChatThemeModel.fromJson(Map<String, dynamic> json) => ChatThemeModel(
        type: chatThemeTypeValue.map[json["type"]],
        image: json["image"],
        color: json["color"],
        patternEnabled: json["patternEnabled"],
        brightness: json["brightness"],
      );

  Map<String, dynamic> toJson() => {
        "type": chatThemeTypeValue.reverse[type],
        "image": image,
        "color": color,
        "patternEnabled": patternEnabled,
        "brightness": brightness,
      };
}

enum ChatThemeType { image, color }

final chatThemeTypeValue = EnumValues({
  "image": ChatThemeType.image,
  "color": ChatThemeType.color,
});

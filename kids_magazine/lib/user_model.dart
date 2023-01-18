// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.language,
    required this.transliteratedText,
  });

  String language;
  String transliteratedText;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        language: json["language"],
        transliteratedText: json["transliterated_text"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "transliterated_text": transliteratedText,
      };
}

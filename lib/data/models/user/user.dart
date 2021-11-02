// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'package:equatable/equatable.dart';
import 'dart:convert';

User userFromMap(Map<String, dynamic> str) => User.fromMap(str);

String userToMap(User data) => json.encode(data.toMap());

class User extends Equatable {
  User({
    required this.id,
    required this.givenName,
    required this.familyName,
    required this.nickname,
    required this.name,
    required this.picture,
    required this.locale,
    required this.updatedAt,
  });

  String id;
  String givenName;
  String familyName;
  String nickname;
  String name;
  String picture;
  String locale;
  DateTime updatedAt;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["sub"],
        givenName: json["given_name"],
        familyName: json["family_name"],
        nickname: json["nickname"],
        name: json["name"],
        picture: json["picture"],
        locale: json["locale"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "given_name": givenName,
        "family_name": familyName,
        "nickname": nickname,
        "name": name,
        "picture": picture,
        "locale": locale,
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  List<Object> get props => [
        id,
        givenName,
        familyName,
        nickname,
        name,
        picture,
        locale,
        updatedAt,
      ];
}

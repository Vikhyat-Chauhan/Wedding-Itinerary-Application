// To parse this JSON data, do
//
//     final locations = locationsFromMap(jsonString);

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

Locations locationsFromMap(Map<String, dynamic> str) => Locations.fromMap(str);

String locationsToMap(Locations data) => json.encode(data.toMap());

class Locations extends Equatable {
  Locations({
    required this.id,
    required this.userid,
    required this.name,
    required this.image,
    required this.location,
    required this.nickname,
  });

  M.ObjectId id;
  String userid;
  String name;
  String image;
  String location;
  String nickname;

  factory Locations.fromMap(Map<String, dynamic> json) => Locations(
    id: json["_id"] as M.ObjectId,
    userid: json["userid"],
    name: json["name"],
    image: json["image"],
    location: json["location"],
    nickname: json["nickname"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userid": userid,
    "name": name,
    "image": image,
    "location": location,
    "nickname": nickname,
  };

  @override
  List<Object> get props => [id, userid, name, image, location, nickname];
}

// To parse this JSON data, do
//
//     final event = eventFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as M;

Event eventFromMap(Map<String, dynamic> str) => Event.fromMap(str);

String eventToMap(Event data) => json.encode(data.toMap());

class Event {
  Event({
    required this.id,
    required this.userid,
    required this.image,
    required this.name,
    required this.timestamp,
    required this.location,
  });

  M.ObjectId id;
  String userid;
  String image;
  String name;
  String timestamp;
  String location;

  factory Event.fromMap(Map<String, dynamic> json) => Event(
    id: json["_id"] as M.ObjectId,
    userid: json["userid"],
    image: json["image"],
    name: json["name"],
    timestamp: json["timestamp"],
    location: json["location"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userid": userid,
    "image": image,
    "name": name,
    "timestamp": timestamp,
    "location": location,
  };
}

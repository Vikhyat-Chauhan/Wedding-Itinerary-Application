// To parse this JSON data, do
//
//     final bookings = bookingsFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as M;

Bookings bookingsFromMap(Map<String, dynamic> str) => Bookings.fromMap(str);

String bookingsToMap(Bookings data) => json.encode(data.toMap());

class Bookings {
  Bookings({
    required this.id,
    required this.userid,
    required this.name,
    required this.email,
    required this.location,
    required this.roomNo,
  });

  M.ObjectId id;
  String userid;
  String name;
  String email;
  String location;
  String roomNo;

  factory Bookings.fromMap(Map<String, dynamic> json) => Bookings(
    id: json["_id"] as M.ObjectId,
    userid: json["userid"],
    name: json["name"],
    email: json["email"],
    location: json["location"],
    roomNo: json["room_no"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userid": userid,
    "name": name,
    "email": email,
    "location": location,
    "room_no": roomNo,
  };
}

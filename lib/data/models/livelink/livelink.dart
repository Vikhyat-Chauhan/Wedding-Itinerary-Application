// To parse this JSON data, do
//
//     final bookings = bookingsFromMap(jsonString);

import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as M;

Livelink livelinkFromMap(Map<String, dynamic> str) => Livelink.fromMap(str);

String livelinkToMap(Livelink data) => json.encode(data.toMap());

class Livelink extends Equatable{
  Livelink({
    required this.id,
    required this.link,
    required this.type,
  });

  M.ObjectId id;
  String link;
  String type;

  factory Livelink.fromMap(Map<String, dynamic> json) => Livelink(
    id: json["_id"] as M.ObjectId,
    link: json["link"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userid": link,
    "name": type,
  };

  @override
  List<Object> get props => [
    link,
    type,
  ];
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';
import 'package:marquee/marquee.dart';

class Events_Card_Wide extends StatelessWidget {
  final String name;
  final String timestamp;
  final String location;
  final String imageiurl;
  final bool scroll;
  const Events_Card_Wide({Key? key, required this.name, required this.timestamp, required this.location, required this.imageiurl, required this.scroll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            print('Card tapped.');
          },
          child: SizedBox(
            height: 283,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageiurl,
                        height: 180.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              SizedBox(height: 7),
                              Text(
                                returntime(timestamp) + ' on ' + returnDay(timestamp),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                              SizedBox(height: 7),
                              SizedBox(
                                width: 260,
                                height: 20,
                                child: scroll? Marquee(
                                  text: location,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,),
                                  blankSpace: 20.0,
                                  velocity: 35.0,
                                ):Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Palette.kToDark,
                        size: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String returnDay(String timestamp){
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp),isUtc: false);
    var day = DateFormat('d MMM').format(dt); // 12/31/2000, 10:00 PM
    return day;
  }

  String returntime(String timestamp){
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp),isUtc: false);
    var day = DateFormat('hh:mm a').format(dt); // 12/31/2000, 10:00 PM
    return day;
  }
}

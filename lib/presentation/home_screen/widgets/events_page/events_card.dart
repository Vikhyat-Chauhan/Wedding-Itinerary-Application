import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:weddingitinerary/presentation/event_screen/event_screen.dart';

class Events_Card extends StatelessWidget {
  final String name;
  final String timestamp;
  final String location;
  final String imageiurl;
  final bool scroll;
  const Events_Card({Key? key, required this.name, required this.timestamp, required this.location, required this.imageiurl, required this.scroll}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Event_Screen(name: name, timestamp: timestamp, location: BlocProvider.of<LocationsBloc>(context).state.locations.firstWhere((element) => element.id.toHexString() == location).name , imageiurl: imageiurl, gmaps_address: BlocProvider.of<LocationsBloc>(context).state.locations.firstWhere((element) => element.id.toHexString() == location).location,)));
          },
          child: SizedBox(
            width: 250,
            height: 255,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageiurl,
                        height: 160.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
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
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(height: 7),
                                Text(
                                    returntime(timestamp) + ' on ' + returnDay(timestamp),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 7),
                                SizedBox(
                                  width: 170,
                                  height: 20,
                                  child: scroll? Marquee(
                                    text: BlocProvider.of<LocationsBloc>(context).state.locations.firstWhere((element) => element.id.toHexString() == location).name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,),
                                    blankSpace: 20.0,
                                    velocity: 35.0,
                                  ):Text(
                                    BlocProvider.of<LocationsBloc>(context).state.locations.firstWhere((element) => element.id.toHexString() == location).name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.alarm,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
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

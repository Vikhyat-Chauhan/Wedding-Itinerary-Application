import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/bookings_bloc/bookings_bloc.dart';

import 'bookings_card.dart';

class Bookings_Card_Column extends StatelessWidget {
  const Bookings_Card_Column({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        children: [
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Bookings",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Arial narrow'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<BookingsBloc,BookingsBlocState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i=0; i<state.bookings.length; i++)
                        Bookings_Card(location: state.bookings[i].location, name: state.bookings[i].name, room_no: state.bookings[i].roomNo, email: state.bookings[i].email,),
                    ],
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}

/*
for(int i=0;i<onlineevents.length;i++){
var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(onlineevents[i].timestamp),isUtc: true);
var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(state.events[i].timestamp),isUtc: true)); // 12/31/2000, 10:00 PM
print(d12);
}
 */
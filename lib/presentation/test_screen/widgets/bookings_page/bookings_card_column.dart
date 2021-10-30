import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/logic/bloc/bookings_bloc/bookings_bloc.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';

import 'bookings_card.dart';

class Bookings_Card_Column extends StatefulWidget {
  const Bookings_Card_Column({Key? key}) : super(key: key);

  @override
  State<Bookings_Card_Column> createState() => _Bookings_Card_ColumnState();
}

class _Bookings_Card_ColumnState extends State<Bookings_Card_Column> {
  String textfielddata = "";
  List<Bookings> bookings = [];
  List<Bookings> bookingscopy = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingsBloc, BookingsBlocState>(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  const Text(
                    "Bookings",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Arial narrow'),
                  ),
                  Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 25, 0),
                    child: Container(
                      width: 150,
                      height: 60,
                      child: TextField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          label: Text("Search Name"),
                          filled: true,
                          fillColor: Palette.kToDark.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (typed_item) {
                          print(typed_item);
                          setState(() {
                            textfielddata = typed_item;
                            bookings.clear();
                            for (int i = 0;
                                i <
                                    BlocProvider.of<BookingsBloc>(context)
                                        .state
                                        .bookings
                                        .length;
                                i++) {
                              if (textfielddata.toLowerCase() ==
                                  BlocProvider.of<BookingsBloc>(context)
                                      .state
                                      .bookings[i]
                                      .name
                                      .substring(0, textfielddata.length)
                                      .toLowerCase()) {
                                bookings.add(
                                    BlocProvider.of<BookingsBloc>(context)
                                        .state
                                        .bookings[i]);
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: (MediaQuery.of(context).size.height) / 3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (context, i) {
                  return Bookings_Card(
                    location: BlocProvider.of<LocationsBloc>(context)
                        .state
                        .locations
                        .firstWhere((element) =>
                            element.id.toHexString() == bookings[i].location)
                        .nickname,
                    name: bookings[i].name,
                    room_no: bookings[i].roomNo,
                    email: bookings[i].email,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      listener: (context, state) {
        if(!listEquals(bookingscopy, state.bookings)){
          if(textfielddata.length==0) {
            bookings.clear();
            for (int i = 0;
            i <
                BlocProvider.of<BookingsBloc>(context)
                    .state
                    .bookings
                    .length;
            i++) {
              if (textfielddata.toLowerCase() ==
                  BlocProvider.of<BookingsBloc>(context)
                      .state
                      .bookings[i]
                      .name
                      .substring(0, textfielddata.length)
                      .toLowerCase()) {
                bookings.add(
                    BlocProvider.of<BookingsBloc>(context)
                        .state
                        .bookings[i]);
              }
            }
            bookingscopy = state.bookings;
            setState(() {
              textfielddata = "";
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    bookings = BlocProvider.of<BookingsBloc>(context).state.bookings;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/*
for(int i=0;i<onlineevents.length;i++){
var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(onlineevents[i].timestamp),isUtc: true);
var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(state.events[i].timestamp),isUtc: true)); // 12/31/2000, 10:00 PM
print(d12);
}
 */

/*
Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < state.bookings.length; i++)
                  if(textfielddata.toLowerCase() == state.bookings[i].name.substring(0,textfielddata.length).toLowerCase())
                  Bookings_Card(
                    location: BlocProvider.of<LocationsBloc>(context)
                        .state
                        .locations
                        .firstWhere((element) =>
                            element.id.toHexString() ==
                            state.bookings[i].location)
                        .nickname,
                    name: state.bookings[i].name,
                    room_no: state.bookings[i].roomNo,
                    email: state.bookings[i].email,
                  ),
              ],
            );
 */

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';

import 'bookings_card.dart';

class Bookings_Card_Column extends StatelessWidget {
  List<Bookings> bookings = [];
  Bookings_Card_Column({Key? key, required this.bookings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        children: [
          for(int i=0;i<bookings.length;i++)
          Bookings_Card(
                  location: BlocProvider.of<LocationsBloc>(context)
                      .state
                      .locations
                      .firstWhere((element) =>
                  element.id.toHexString() == bookings[i].location)
                      .nickname,
                  name: bookings[i].name,
                  room_no: bookings[i].roomNo,
                  email: bookings[i].email,
                ),
        ],
      ),
    );
  }
}
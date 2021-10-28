import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';

import 'locations_card.dart';

class Locations_Card_Column extends StatelessWidget {
  const Locations_Card_Column({Key? key}) : super(key: key);
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
                  "Locations",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Arial narrow'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BlocBuilder<LocationsBloc,LocationsBlocState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i=0; i<state.locations.length; i++)
                      Locations_Card(location: state.locations[i].location, name: state.locations[i].name, imageiurl: state.locations[i].image, nickname: state.locations[i].nickname, scroll: (state.locations[i].name.length>15)? true:false,),
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
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/models/event/event.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/events_page/events_card.dart';

class Events_Card_Row extends StatelessWidget {
  const Events_Card_Row({Key? key}) : super(key: key);
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
                  "Upcoming",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Arial narrow'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<EventBloc,EventBlocState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i=0; i<state.events.length; i++)
                      if((DateTime.now().millisecondsSinceEpoch) < int.parse(state.events[i].timestamp)) Events_Card(location: state.events[i].location, name: state.events[i].name, imageiurl: state.events[i].image, timestamp: state.events[i].timestamp, scroll: (state.events[i].name.length>15)? true:false,),
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

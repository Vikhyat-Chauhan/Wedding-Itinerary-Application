import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/events_page/events_card.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/events_page/events_card_wide.dart';

class Events_Card_Column extends StatelessWidget {
  const Events_Card_Column({Key? key}) : super(key: key);
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
                  "Events",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Arial'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<EventBloc,EventBlocState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i=0; i<state.events.length; i++)
                        Events_Card_Wide(location: state.events[i].location, name: state.events[i].name, imageiurl: state.events[i].image, timestamp: state.events[i].timestamp, scroll: (state.events[i].name.length>15)? true:false,),
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
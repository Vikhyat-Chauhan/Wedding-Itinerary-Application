import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/events_page/events_card.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/discover_page/shortcuts_card.dart';

class Shortcut_Card_Row extends StatelessWidget {
  const Shortcut_Card_Row({Key? key}) : super(key: key);
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
              children: [
                Text(
                  "Shortcuts",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Arial narrow'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Shortcuts_Card(iconData: Icons.hotel, title :'Hotel'),
                Shortcuts_Card(iconData: Icons.add_a_photo, title :'Upload'),
                Shortcuts_Card(iconData: Icons.contact_support, title :'Support'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

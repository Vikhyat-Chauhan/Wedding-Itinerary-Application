import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weddingitinerary/logic/bloc/bottomnavbar_bloc/bottomnavbar_bloc.dart';
import 'package:weddingitinerary/logic/bloc/livelink_bloc/livelink_bloc.dart';
import 'package:weddingitinerary/presentation/contact_screen/contact_screen.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/discover_page/shortcuts_card.dart';

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
                GestureDetector(
                  child: Shortcuts_Card(iconData: Icons.voice_chat, title: 'LiveVideo'),
                  onTap: () async {
                    String x = BlocProvider.of<LivelinkBloc>(context).state.livelinks[0].link;// e.g. mailto:smith@example.org?subject=News&body=New%20plugin";
                    await _makeUrl(x);
                  },
                ),
                GestureDetector(
                  child: Shortcuts_Card(iconData: Icons.hotel, title: 'Hotel'),
                  onTap: () {
                    print("hotel");
                    BlocProvider.of<BottomnavbarBloc>(context)
                        .add(Bottomnavbarsetindex(pageindex: 3));
                  },
                ),
                GestureDetector(
                  child: Shortcuts_Card(
                      iconData: Icons.add_a_photo, title: 'Upload'),
                  onTap: () {
                    print("upload");
                    BlocProvider.of<BottomnavbarBloc>(context)
                        .add(Bottomnavbarsetindex(pageindex: 2));
                  },
                ),
                GestureDetector(
                  child: Shortcuts_Card(
                      iconData: Icons.contact_support, title: 'Support'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Contact_Screen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

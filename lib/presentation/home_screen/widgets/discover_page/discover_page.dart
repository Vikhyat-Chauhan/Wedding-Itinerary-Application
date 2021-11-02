import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/events_page/events_card_row.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/discover_page/shortcuts_card_row.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/top_bar.dart';

class Discover_Page extends StatelessWidget {
  const Discover_Page({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top_Bar(pagename: 'Discover',),
        SizedBox(height: 40),
        Shortcut_Card_Row(),
        SizedBox(height: 40),
        Events_Card_Row(),
        //SizedBox(height: 24),
        /*
            Center(
              child: ElevatedButton(
                  child: const Text(
                    " Get Started ",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            side: BorderSide(color: Colors.transparent))),
                  ),
                  onPressed: () async {}),
            ), */
      ],
    );
  }
}
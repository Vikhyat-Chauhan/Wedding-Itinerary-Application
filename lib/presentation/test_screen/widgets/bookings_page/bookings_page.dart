import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/bookings_card_column.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/locations_card_column.dart';

import '../top_bar.dart';

import 'dart:async';

late StreamSubscription<bool> keyboardSubscription;

class Bookings_Page extends StatefulWidget {
  @override
  State<Bookings_Page> createState() => _Bookings_PageState();
}

class _Bookings_PageState extends State<Bookings_Page> {
  bool hideWidget = false;
  @override
  Widget build(BuildContext context) {
    bool moveWidgets = false;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Top_Bar(pagename: 'Bookings',),
          if(!hideWidget)
          const SizedBox(height: 40),
          if(!hideWidget)
          Locations_Card_Column(),
          if(hideWidget)
          const SizedBox(height: 10),
          if(!hideWidget)
          const SizedBox(height: 40),
          Bookings_Card_Column(),
        ],
      ),
    );
  }

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      setState(() {
        hideWidget = visible;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}

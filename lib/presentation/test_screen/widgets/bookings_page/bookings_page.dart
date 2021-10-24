import 'package:flutter/material.dart';

import '../top_bar.dart';

class Bookings_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top_Bar(pagename: 'Bookings',),
        const SizedBox(height: 10),
        Text('yolo'),
      ],
    );
  }
}

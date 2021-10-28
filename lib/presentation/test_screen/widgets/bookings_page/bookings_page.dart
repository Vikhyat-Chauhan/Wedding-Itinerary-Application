import 'package:flutter/material.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/bookings_card_column.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/locations_card_column.dart';

import '../top_bar.dart';

class Bookings_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Top_Bar(pagename: 'Bookings',),
          const SizedBox(height: 40),
          Locations_Card_Column(),
          const SizedBox(height: 40),
          Bookings_Card_Column(),
        ],
      ),
    );
  }
}

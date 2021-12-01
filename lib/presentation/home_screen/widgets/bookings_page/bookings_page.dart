import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/logic/bloc/bookings_bloc/bookings_bloc.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/bookings_page/bookings_card_column.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/bookings_page/locations_card_column.dart';

import '../top_bar.dart';

import 'dart:async';

late StreamSubscription<bool> keyboardSubscription;

class Bookings_Page extends StatefulWidget {
  @override
  State<Bookings_Page> createState() => _Bookings_PageState();
}

class _Bookings_PageState extends State<Bookings_Page> {
  late dynamic keyboardVisibilityController;
  String textfielddata = "";
  List<Bookings> bookingscopy = [];
  bool hideWidget = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Top_Bar(
                pagename: 'Bookings',
              ),
              if (!hideWidget) const SizedBox(height: 40),
              if (!hideWidget) Locations_Card_Column(),
              if (hideWidget) const SizedBox(height: 10),
              if (!hideWidget) const SizedBox(height: 40),
              if (!hideWidget)
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Bookings",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Arial narrow'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                      child: FloatingActionButton(
                        onPressed: () {
                          hideWidget = true;
                          setState(() {});
                        },
                        child: const Icon(Icons.search),
                        tooltip: 'Search',
                      ),
                    ),
                  ),
                ],
              ),
              if (!hideWidget) const SizedBox(height: 15),
              if (hideWidget)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
                  child: Container(
                    height: 60,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        contentPadding: EdgeInsets.all(8.0),
                        fillColor: Palette.kToDark.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (typed_item) {
                        setState(() {
                          textfielddata = typed_item;
                          bookingscopy.clear();
                          for (int i = 0;
                              i <
                                  BlocProvider.of<BookingsBloc>(context)
                                      .state
                                      .bookings
                                      .length;
                              i++) {
                            /*if (textfielddata.toLowerCase() ==
                                BlocProvider.of<BookingsBloc>(context)
                                    .state
                                    .bookings[i]
                                    .name
                                    .substring(0, textfielddata.length)
                                    .toLowerCase()) */
                              if (BlocProvider.of<BookingsBloc>(context)
                                      .state
                                      .bookings[i]
                                      .name
                                      .toLowerCase().contains(textfielddata.toLowerCase())){
                              bookingscopy.add(
                                  BlocProvider.of<BookingsBloc>(context)
                                      .state
                                      .bookings[i]);
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 5),
              if (!hideWidget)
                BlocBuilder<BookingsBloc, BookingsBlocState>(
                    buildWhen: (previous, current) {
                  if (current.status == BookingsStatus.normal) {
                    if (current.bookings.length != 0) {
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    return false;
                  }
                }, builder: (context, state) {
                  return Bookings_Card_Column(
                    bookings: state.bookings,
                  );
                }),
              if (hideWidget)
                Bookings_Card_Column(
                  bookings: bookingscopy,
                ),
              if (hideWidget)
                SizedBox(height: MediaQuery.of(context).size.height),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
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

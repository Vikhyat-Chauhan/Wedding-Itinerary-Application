import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/bookings_page.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/discover_page/discover_page.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/events_page/events_page.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/images_page/images_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool selected = true;
  int _currentIndex = 0; //Page Selector
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: (_currentIndex == 0)
            ? Discover_Page()
            : ((_currentIndex == 1)
                ? Events_Page()
                : ((_currentIndex == 2)
                    ? Images_Page()
                    : ((_currentIndex == 3) ? Bookings_Page() : Text('NULL')))),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            title: Text("Discover"),
            icon: Icon(Icons.favorite),
            selectedColor: Colors.purple,
            unselectedColor: Colors.white,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.wc),
            title: Text("Events"),
            selectedColor: Colors.pink,
            unselectedColor: Colors.white,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.photo_camera),
            title: Text("Images"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.white,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.location_on),
            title: Text("Bookings"),
            selectedColor: Colors.orange,
            unselectedColor: Colors.white,
          ),
        ],
      ),
    );
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //Do nothing here
    return true;
  }

  @override
  void initState() {
    const thirtySec = Duration(seconds: 1);
    //Timer.periodic(thirtySec,
    //    (Timer t) => BlocProvider.of<UserBloc>(context).add(UserRefresh()));
    //Timer.periodic(thirtySec,
    //        (Timer t) => BlocProvider.of<GroupBloc>(context).add(GroupRefresh()));
    //Timer.periodic(thirtySec, (Timer t) => BlocProvider.of<AuthenticationCubit>(context).add(UserRefresh()));
    BackButtonInterceptor.add(backInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }
}

@override
void initState() {}

@override
void close() {}

/*
BottomNavigationBar(
type: BottomNavigationBarType.fixed,
currentIndex: _currentIndex,
onTap: (value) {
// Respond to item press.
setState(
() {
_currentIndex = value;
},
);
},
items: const [
BottomNavigationBarItem(
label: 'discover_page',
icon: Icon(Icons.favorite),
),
BottomNavigationBarItem(
label: 'Events',
icon: Icon(Icons.wc),
),
BottomNavigationBarItem(
label: 'Bookings',
icon: Icon(Icons.location_on),
),
BottomNavigationBarItem(
label: 'Profile',
icon: Icon(Icons.account_box),
),
],
)*/

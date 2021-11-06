import 'dart:async';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/bookings_bloc/bookings_bloc.dart';
import 'package:weddingitinerary/logic/bloc/bottomnavbar_bloc/bottomnavbar_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/bookings_page/bookings_page.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/discover_page/discover_page.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/events_page/events_page.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/images_page/images_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//Added Filter
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  double _sigmaX = 2.0; // from 0-10
  double _sigmaY = 2.0; // from 0-10
  double _opacity = 0.4; // from 0-1.0
  bool selected = true;
  int backpress_count = 0;
  late final InternetBloc _internetBloc;
  late final StreamSubscription _internetStream;
  var mongodbautoconnectTimer,
      eventrefreshTimer,
      bookingrefreshTimer,
      locationrefreshTimer;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomnavbarBloc, BottomnavbarBlocState>(
        builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("lib/core/assets/images/background_image_4.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
            child: Container(
              color: Colors.black.withOpacity(_opacity),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: (state.pageindex == 0)
                    ? Discover_Page()
                    : ((state.pageindex == 1)
                        ? Events_Page()
                        : ((state.pageindex == 2)
                            ? Images_Page()
                            : ((state.pageindex == 3)
                                ? Bookings_Page()
                                : Text('NULL')))),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: state.pageindex,
          onTap: (i) {
            BlocProvider.of<BottomnavbarBloc>(context)
                .add(Bottomnavbarsetindex(pageindex: i));
          },
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
              icon: Icon(Icons.hotel),
              title: Text("Bookings"),
              selectedColor: Colors.orange,
              unselectedColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }

  Future<bool> backInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    //Do nothing here
    return true;
  }

  @override
  void initState() {
    const thirtySec = Duration(seconds: 30);
    mongodbautoconnectTimer = Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<MongodbBloc>(context).state.status;
      if ((state != MongodbStatus.connected) &
          (state != MongodbStatus.initial) &
          (state != MongodbStatus.working)) {
        BlocProvider.of<MongodbBloc>(context).add(Connect());
      }
    });
    eventrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<EventBloc>(context).state.status;
      if ((state == EventStatus.normal)) {
        BlocProvider.of<EventBloc>(context).add(EventRefresh());
      }
    });
    bookingrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<BookingsBloc>(context).state.status;
      if ((state == BookingsStatus.normal)) {
        BlocProvider.of<BookingsBloc>(context).add(BookingsRefresh());
      }
    });

    locationrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<LocationsBloc>(context).state.status;
      if ((state == LocationsStatus.normal)) {
        BlocProvider.of<LocationsBloc>(context).add(LocationsRefresh());
      }
    });

    BlocProvider.of<ImagesBloc>(context).add(ImageBlocInitial());

    WidgetsBinding.instance!.addObserver(this);
    BackButtonInterceptor.add(backInterceptor);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      const thirtySec = Duration(seconds: 30);
      mongodbautoconnectTimer = Timer.periodic(thirtySec, (Timer t) {
        var state = BlocProvider.of<MongodbBloc>(context).state.status;
        if ((state != MongodbStatus.connected) &
            (state != MongodbStatus.initial) &
            (state != MongodbStatus.working)) {
          BlocProvider.of<MongodbBloc>(context).add(Connect());
        }
      });
      eventrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
        var state = BlocProvider.of<EventBloc>(context).state.status;
        if ((state == EventStatus.normal)) {
          BlocProvider.of<EventBloc>(context).add(EventRefresh());
        }
      });
      bookingrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
        var state = BlocProvider.of<BookingsBloc>(context).state.status;
        if ((state == BookingsStatus.normal)) {
          BlocProvider.of<BookingsBloc>(context).add(BookingsRefresh());
        }
      });
      locationrefreshTimer = Timer.periodic(thirtySec, (Timer t) {
        var state = BlocProvider.of<LocationsBloc>(context).state.status;
        if ((state == LocationsStatus.normal)) {
          BlocProvider.of<LocationsBloc>(context).add(LocationsRefresh());
        }
      });
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.paused) { print("Pasued State");
      mongodbautoconnectTimer.cancel();
      eventrefreshTimer.cancel();
      bookingrefreshTimer.cancel();
      locationrefreshTimer.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }
}

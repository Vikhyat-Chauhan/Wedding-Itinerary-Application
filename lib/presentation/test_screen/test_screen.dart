import 'dart:async';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/logic/bloc/bottomnavbar_bloc/bottomnavbar_bloc.dart';
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
//Added Filter
class _TestScreenState extends State<TestScreen> {
  double _sigmaX = 2.0; // from 0-10
  double _sigmaY = 2.0; // from 0-10
  double _opacity = 0.6; // from 0-1.0
  bool selected = true;
  int backpress_count = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomnavbarBloc, BottomnavbarBlocState>(
        builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/core/assets/images/background_image_2.jpeg"),
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
                              : ((state.pageindex == 3) ? Bookings_Page() : Text('NULL')))),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: state.pageindex,
            onTap: (i) { BlocProvider.of<BottomnavbarBloc>(context)
                .add(Bottomnavbarsetindex(pageindex: i));},
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
    );
  }

  Future<bool> backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) async {
    //final GcloudApi gcloud = GcloudApi();
    //await gcloud.spawnclient().whenComplete(() async {
    //  await gcloud.returnAllFilename();
    //});
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

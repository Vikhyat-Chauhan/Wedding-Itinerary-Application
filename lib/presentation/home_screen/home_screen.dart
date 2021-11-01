import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/bookings_bloc/bookings_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/logic/bloc/locations_bloc/locations_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'widgets/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'lib/core/assets/images/background_image_2.jpeg',
    'lib/core/assets/images/background_image_4.jpeg',
    'lib/core/assets/images/background_image_7.jpeg',
    'lib/core/assets/images/background_image_8.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc,AuthenticationBlocState>(
        builder: (context,state) {
          return Stack(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayInterval: Duration(seconds: 3),
                ),
                items: imgList
                    .map((item) => Container(
                          child: Center(
                              child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                          )),
                        ))
                    .toList(),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.black.withOpacity(0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.lerp(
                      Alignment.bottomCenter, Alignment.center, 0.23),
                  height: 191,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                          'lib/core/assets/images/Durgesh_Weds_Ritika.png'),
                    ),
                  ),
                  child: Container(
                    child: (state.status == AuthenticationStatus.unauthenticated)? ElevatedButton(
                      child: const Text(" Get Started ",
                          style: TextStyle(fontSize: 14, fontFamily: 'Playfair Display')),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(HexColor("#ebce87")),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(color: Colors.transparent)))),
                      onPressed: () async {
                        BlocProvider.of<AuthenticationBloc>(context).add(Login());
                      },
                    ): null,
                  ),
                ),
              ),
              if(state.status == AuthenticationStatus.working)
                Center(child: CircularProgressIndicator()),
            ],
          );
        },
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            Navigator.pushNamed(context, '/test');
          }
        },
      ),
    );
  }

  @override
  void initState() {
    const thirtySec = Duration(seconds: 30);
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<MongodbBloc>(context).state.status;
      if ((state != MongodbStatus.connected) &
          (state != MongodbStatus.initial) &
          (state != MongodbStatus.working)) {
        BlocProvider.of<MongodbBloc>(context).add(Connect());
      }
    });
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<EventBloc>(context).state.status;
      if ((state == EventStatus.normal)) {
       BlocProvider.of<EventBloc>(context).add(EventRefresh());
      }
    });
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<BookingsBloc>(context).state.status;
      if ((state == BookingsStatus.normal)) {
        BlocProvider.of<BookingsBloc>(context).add(BookingsRefresh());
      }
    });
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<LocationsBloc>(context).state.status;
      if ((state == LocationsStatus.normal)) {
        BlocProvider.of<LocationsBloc>(context).add(LocationsRefresh());
      }
    });
    BlocProvider.of<ImagesBloc>(context).add(ImageFetch(directory: 'Wedding Ceremony/',readmax: 12));
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<ImagesBloc>(context).state.status;
      var hasreachedmax = BlocProvider.of<ImagesBloc>(context).state.hasReachedMax;
      if ((state != ImagesStatus.serviceunavailable)) {
        if(hasreachedmax != true) {
          //BlocProvider.of<ImagesBloc>(context).add(ImageFetch(directory: 'Wedding Ceremony/'));
        }
      }
    });

    //Timer.periodic(thirtySec, (Timer t) => BlocProvider.of<AuthenticationCubit>(context).add(UserRefresh()));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

@override
void initState() {}

@override
void close() {}

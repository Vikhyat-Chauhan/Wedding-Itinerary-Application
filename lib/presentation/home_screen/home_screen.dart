import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'widgets/login_widget.dart';
import 'widgets/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'lib/core/assets/images/background_image_1.jpeg',
    'lib/core/assets/images/background_image_2.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
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
                      Colors.blue[900]!.withOpacity(0.1),
                      Colors.black.withOpacity(0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                ),
              ),
            ],
          ),
          Center(
            child: BlocConsumer<AuthenticationBloc, AuthenticationBlocState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.unauthenticated) {
                  return const Login_Widget();
                } else {
                  return CircularProgressIndicator();
                }
              },
              listener: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  User user = userFromMap(state.profile);
                  Navigator.pushNamed(context, '/test');
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                alignment: Alignment.bottomCenter,
                height: 172,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image:
                    AssetImage('lib/core/assets/images/Durgesh_Weds_Ritika.png'),
                  ),
                ),
              ),]
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    const thirtySec = Duration(seconds: 1);
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<MongodbBloc>(context).state.status;
      if ((state != MongodbStatus.connected) &
          (state != MongodbStatus.initial) &
          (state != MongodbStatus.working)) {
        //BlocProvider.of<MongodbBloc>(context).add(Connect());
      }
    });
    Timer.periodic(thirtySec, (Timer t) {
      var state = BlocProvider.of<EventBloc>(context).state.status;
      if ((state == EventStatus.normal)) {
        //BlocProvider.of<EventBloc>(context).add(EventRefresh());
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

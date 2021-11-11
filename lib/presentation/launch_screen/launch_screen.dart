import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with WidgetsBindingObserver {
  final List<String> imgList = [
    'lib/core/assets/images/background_image_2.jpeg',
    'lib/core/assets/images/background_image_4.jpeg',
    'lib/core/assets/images/background_image_7.jpeg',
    'lib/core/assets/images/background_image_8.jpeg'
  ];

  late final InternetBloc _internetBloc;
  late final StreamSubscription _internetStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationBlocState>(
        builder: (context, state) {
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
                    child:
                        (state.status == AuthenticationStatus.unauthenticated)
                            ? ElevatedButton(
                                child: const Text(" Get Started ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Playfair Display')),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            HexColor("#ebce87")),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            side: BorderSide(
                                                color: Colors.transparent)))),
                                onPressed: () async {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(Login());
                                },
                              )
                            : null,
                  ),
                ),
              ),
              if (state.status == AuthenticationStatus.working)
                Center(child: CircularProgressIndicator()),
            ],
          );
        },
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            Navigator.pushNamed(context, '/home_screen');
          }
        },
      ),
    );
  }

  @override
  void initState() {
    _internetBloc = BlocProvider.of<InternetBloc>(context);
    _internetStream = _internetBloc.stream.listen((state) {
      if(state.status == InternetStatus.connected){
        if ((BlocProvider.of<MongodbBloc>(context).state.status !=
            MongodbStatus.connected) &
        (BlocProvider.of<MongodbBloc>(context).state.status !=
            MongodbStatus.initial) &
        (BlocProvider.of<MongodbBloc>(context).state.status !=
            MongodbStatus.working)) {
          BlocProvider.of<MongodbBloc>(context).add(Connect());
        }

        BlocProvider.of<ImagesBloc>(context).add(ImageBlocInitial());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Back Online'),
          ),
        );
      }
      else if(state.status == InternetStatus.disconnected){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Internet Unavailable'),
          ),
        );
      }
    });

    //Timer.periodic(thirtySec, (Timer t) => BlocProvider.of<AuthenticationCubit>(context).add(UserRefresh()));
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      if ((BlocProvider.of<MongodbBloc>(context).state.status !=
              MongodbStatus.connected) &
          (BlocProvider.of<MongodbBloc>(context).state.status !=
              MongodbStatus.initial) &
          (BlocProvider.of<MongodbBloc>(context).state.status !=
              MongodbStatus.working)) {
        BlocProvider.of<MongodbBloc>(context).add(Connect());
      }

      BlocProvider.of<ImagesBloc>(context).add(ImageBlocInitial());
    } else if (state == AppLifecycleState.inactive) {

    } else if (state == AppLifecycleState.paused) {

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _internetStream.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}

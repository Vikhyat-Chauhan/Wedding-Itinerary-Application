import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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

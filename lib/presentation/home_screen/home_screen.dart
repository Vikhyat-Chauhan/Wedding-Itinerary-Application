import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
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
              BlocProvider.of<UserBloc>(context).state.copyWith(users: []);
              return const Login_Widget();
            } else {
              return CircularProgressIndicator();
            }
          },
          listener:(context, state) {
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
    const thirtySec = Duration(seconds: 1);
    //Timer.periodic(thirtySec,
    //    (Timer t) => BlocProvider.of<UserBloc>(context).add(UserRefresh()));
    //Timer.periodic(thirtySec,
    //        (Timer t) => BlocProvider.of<GroupBloc>(context).add(GroupRefresh()));
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

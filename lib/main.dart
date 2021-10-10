import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';
import 'package:weddingitinerary/presentation/router/app_router.dart';
import 'package:weddingitinerary/core/themes/app_theme.dart';

import 'logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'logic/debug/app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(weddingitinerary());
}

class weddingitinerary extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => MongodbBloc()..add(Connect()),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              UserBloc(BlocProvider.of<MongodbBloc>(context)),
        ),
        BlocProvider(
          create: (BuildContext context) => AuthenticationBloc(
              BlocProvider.of<UserBloc>(context),
              BlocProvider.of<MongodbBloc>(context))
            ..add(Login()),
        ),
      ],
      child: MaterialApp(
        title: "Wedding Itinerary Application",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}

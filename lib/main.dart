import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/bottomnavbar_bloc/bottomnavbar_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';
import 'package:weddingitinerary/presentation/router/app_router.dart';
import 'package:weddingitinerary/core/themes/app_theme.dart';

import 'logic/bloc/bookings_bloc/bookings_bloc.dart';
import 'logic/bloc/event_bloc/event_bloc.dart';
import 'logic/bloc/images_bloc/images_bloc.dart';
import 'logic/bloc/locations_bloc/locations_bloc.dart';
import 'logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'logic/cubit/internet_bloc/internet_bloc.dart';
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
          create: (BuildContext context) => BottomnavbarBloc()..add(Bottomnavbarsetindex(pageindex: 0)),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              InternetBloc(),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) => MongodbBloc(BlocProvider.of<InternetBloc>(context))..add(Connect()),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) => AuthenticationBloc(BlocProvider.of<InternetBloc>(context),
              BlocProvider.of<MongodbBloc>(context))
            ..add(Login()),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              EventBloc(BlocProvider.of<MongodbBloc>(context),BlocProvider.of<AuthenticationBloc>(context)),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              BookingsBloc(BlocProvider.of<MongodbBloc>(context),BlocProvider.of<AuthenticationBloc>(context),),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              LocationsBloc(BlocProvider.of<MongodbBloc>(context),BlocProvider.of<AuthenticationBloc>(context)),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) =>
              ImagesBloc(BlocProvider.of<InternetBloc>(context))..add(ImageBlocInitial()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: "Wedding Itinerary Application",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.advancedTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}

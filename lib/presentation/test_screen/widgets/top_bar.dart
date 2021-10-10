import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';

class Top_Bar extends StatelessWidget {
  const Top_Bar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              alignment: AlignmentDirectional.topStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Discover",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Arial narrow'),
                  ),
                  Text(
                    "Wedding Itinerary",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arial narrow'),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationBlocState>(
            builder: (context, state) {
              return PopupMenuButton(
                offset: const Offset(-10, 40),
                color: Palette.kToDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      state.profile["picture"],
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
                itemBuilder: (context) {
                  return List.generate(1, (index) {
                    return PopupMenuItem(
                      child: GestureDetector(
                        child: const Text(
                          '  Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: 'Arial narrow'),
                        ),
                        onTap: () {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(Logout());
                          Navigator.popAndPushNamed(context, '/');
                        },
                      ),
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

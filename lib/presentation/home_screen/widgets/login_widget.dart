import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';

class Login_Widget extends StatelessWidget {
  const Login_Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: const Text(" Get Started ",
              style: TextStyle(fontSize: 14, fontFamily: 'Raleway')),
          style: ButtonStyle(
              //foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              //backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(color: Colors.transparent)))),
          onPressed: () async {
            BlocProvider.of<AuthenticationBloc>(context).add(Login());
          },
        ),
      ],
    );
  }
}

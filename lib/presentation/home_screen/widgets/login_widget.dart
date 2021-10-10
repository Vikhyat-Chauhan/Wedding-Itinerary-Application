import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';

class Login_Widget extends StatelessWidget {
  const Login_Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const SizedBox(width: 10,height: 200,),
        Container(
          width: 200,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('lib/core/assets/logo_white.png'),
            ),
          ),
        ),
        Container(
          width: 250,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage('lib/core/assets/thenextmove.png'),
            ),
          ),
        ),
        const SizedBox(width: 10,height: 70,),
        ElevatedButton(
            child:
                const Text(" Get Started ", style: TextStyle(fontSize: 14,fontFamily: 'Raleway')),
            style: ButtonStyle(
                //foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                //backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: Colors.transparent)))),
            onPressed: () async {
              BlocProvider.of<AuthenticationBloc>(context).add(Login());
            },),
        const SizedBox(width: 10,height: 200,),
        Container(
          width: 250,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage('lib/core/assets/Automate your home using TNM Devices.png'),
            ),
          ),
        )],
    );
  }
}

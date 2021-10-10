import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';

class Profile extends StatelessWidget {
  final String name;
  final String picture;

  const Profile(this.name, this.picture, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            Navigator.pushNamed(context, "/test");
          },
          child: const Text('Device Page'),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            BlocProvider.of<AuthenticationBloc>(context).add(Logout());
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

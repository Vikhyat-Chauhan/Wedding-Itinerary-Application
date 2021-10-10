import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/top_bar.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool selected = true;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: [
            Top_Bar(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  child: const Text(
                    " Get Started ",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            side: BorderSide(color: Colors.transparent))),
                  ),
                  onPressed: () async {}),
            ),
            const SizedBox(height: 24),
            Card(
              color: Palette.kToDark,
              child: InkWell(
                onTap: () {
                  print('Card tapped.');
                },
                child: const SizedBox(
                  width: 100,
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('A card that can be tapped', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Discover',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Events',
            icon: Icon(Icons.wc),
          ),
          BottomNavigationBarItem(
            label: 'Places',
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_box),
          ),
        ],
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

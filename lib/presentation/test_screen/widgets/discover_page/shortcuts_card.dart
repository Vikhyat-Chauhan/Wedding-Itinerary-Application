import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';

class Shortcuts_Card extends StatelessWidget {
  final IconData iconData;
  final String title;
  Shortcuts_Card({Key? key, required this.iconData, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Palette.kToDark,
        child: SizedBox(
          width: 120,
          height: 155,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 55,
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7),
                Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                  size: 37,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

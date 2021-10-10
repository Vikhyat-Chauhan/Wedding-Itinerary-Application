import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/logic/cubit/authentication_cubit.dart';

class Top_Bar extends StatelessWidget {
  const Top_Bar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              alignment: AlignmentDirectional.topStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Arial narrow'),
                  ),
                  Text(
                    "Wedding Itinerary",
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arial narrow'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://lh3.googleusercontent.com/a-/AOh14Gj2saf7l_2JjT-9M3XTFY1lzKeA8XVGdtGgCdzSoFQ=s96-c',
                  height: 50.0,
                  width: 50.0,
                ),
              ),
              padding: EdgeInsets.all(5),
          ),
        ],
      ),
    );
  }
}

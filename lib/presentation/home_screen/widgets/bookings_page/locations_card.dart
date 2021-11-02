import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:weddingitinerary/core/themes/palette.dart';

class Locations_Card extends StatelessWidget {
  final String name;
  final String nickname;
  final String location;
  final String imageiurl;
  final bool scroll;
  const Locations_Card(
      {Key? key,
      required this.name,
      required this.nickname,
      required this.location,
      required this.imageiurl,
      required this.scroll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
          child: InkWell(
            onTap: () {
              MapsLauncher.launchQuery(location);
            },
            child: SizedBox(
              width: 120,
              height: 155,
              child: Column(
                children: [
                  ClipRect(
                    child: Container(
                      child: Text(
                        nickname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                imageiurl,
                                height: 137.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 7,
                          left: 1,
                          right:
                              1, //give the values according to your requirement
                          child: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                            size: 37,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

/*
Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            print('Card tapped.');
            MapsLauncher.launchQuery(location);
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageiurl,
                        height: 180.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              SizedBox(height: 7),
                              Text(
                                ' on ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                              SizedBox(height: 7),
                              SizedBox(
                                width: 260,
                                height: 20,
                                child: scroll? Marquee(
                                  text: location,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,),
                                  blankSpace: 20.0,
                                  velocity: 35.0,
                                ):Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Palette.kToDark,
                        size: 50,
                      ),
                    ],
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[900]!.withOpacity(0.1),
                              Colors.black.withOpacity(0.8)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
*/

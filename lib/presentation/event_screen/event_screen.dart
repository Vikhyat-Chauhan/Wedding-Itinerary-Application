import 'dart:ui';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/top_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Event_Screen extends StatefulWidget {
  final String name;
  final String timestamp;
  final String location;
  final String imageiurl;
  final String gmaps_address;
  const Event_Screen({
    Key? key,
    required this.name,
    required this.timestamp,
    required this.location,
    required this.imageiurl,
    required this.gmaps_address,
  }) : super(key: key);

  @override
  State<Event_Screen> createState() => _Event_ScreenState();
}
//Added Filter
class _Event_ScreenState extends State<Event_Screen> {
  double _sigmaX = 2.0; // from 0-10
  double _sigmaY = 2.0; // from 0-10
  double _opacity = 0.4; // from 0-1
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/core/assets/images/background_image_4.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Container(
          color: Colors.black.withOpacity(_opacity),
          child: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  children: [
                    Top_Bar(
                      pagename: 'Event',
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                widget.imageiurl,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Arial narrow'),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Palette.kToDark,
                            size: 35,
                          ),
                          const SizedBox(width: 25),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Starts at",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Arial narrow',
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  returntime(widget.timestamp),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Arial narrow',
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Palette.kToDark,
                            size: 35,
                          ),
                          const SizedBox(width: 25),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Event Date",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Arial narrow',
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  returnWeekDay(widget.timestamp) +
                                      ", " +
                                      returnDay(widget.timestamp),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Arial narrow',
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_city,
                              color: Palette.kToDark,
                              size: 35,
                            ),
                            const SizedBox(width: 25),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Venue is",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Arial narrow',
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.location,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Arial narrow',
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        MapsLauncher.launchQuery(widget.gmaps_address);
                      },
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Palette.kToDark,
                              size: 35,
                            ),
                            const SizedBox(width: 25),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Venue Address",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Arial narrow',
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 2),
                                  (widget.gmaps_address.length < 25)
                                      ? Text(
                                          widget.gmaps_address,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Arial narrow',
                                              fontSize: 15),
                                        )
                                      : Text(
                                          widget.gmaps_address.substring(0, 24),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Arial narrow',
                                              fontSize: 15),
                                        ),
                                  ((widget.gmaps_address.substring(24)).length < 24)
                                      ? Text(
                                          widget.gmaps_address.substring(24).trimLeft(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Arial narrow',
                                              fontSize: 15),
                                        )
                                      : Text(
                                          widget.gmaps_address
                                              .substring(24, 48)
                                              .trimLeft(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Arial narrow',
                                              fontSize: 15),
                                        ),
                                  Text(
                                    widget.gmaps_address.substring(48).trimLeft(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Arial narrow',
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        MapsLauncher.launchQuery(widget.gmaps_address);
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              _uploadImages();
                            },
                            child: Text('Upload'),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
              backgroundColor: Palette.kToDark.shade50,
              tooltip: 'BACK',
            ),
          ),
        ),
      ),
    );
  }

  void _uploadImages() async {
    final GcloudApi gcloud = GcloudApi();
    await ImagePicker().pickMultiImage().then((images) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 400),
          content: Text('Uploading'),
        ),
      );
      if (images != null) {
        await gcloud.spawnclient().whenComplete(() async {
          await gcloud.saveMany(images, widget.name+'/').whenComplete(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 800),
                content: Text('Done'),
              ),
            );
          });
        });
      }
    });
  }

  String returnDay(String timestamp) {
    var dt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp), isUtc: false);
    var day = DateFormat('MMMM d').format(dt); // 12/31/2000, 10:00 PM
    return day;
  }

  String returnWeekDay(String timestamp) {
    var dt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp), isUtc: false);
    var day = DateFormat('EEEE ').format(dt); // 12/31/2000, 10:00 PM
    return day;
  }

  String returntime(String timestamp) {
    var dt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp), isUtc: false);
    var day = DateFormat('hh:mm a').format(dt); // 12/31/2000, 10:00 PM
    return day;
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    print(widget.gmaps_address.substring(24).length);
    const thirtySec = Duration(seconds: 1);
    //Timer.periodic(thirtySec,
    //    (Timer t) => BlocProvider.of<UserBloc>(context).add(UserRefresh()));
    //Timer.periodic(thirtySec,
    //        (Timer t) => BlocProvider.of<GroupBloc>(context).add(GroupRefresh()));
    //Timer.periodic(thirtySec, (Timer t) => BlocProvider.of<AuthenticationCubit>(context).add(UserRefresh()));
    BackButtonInterceptor.add(backInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }
}

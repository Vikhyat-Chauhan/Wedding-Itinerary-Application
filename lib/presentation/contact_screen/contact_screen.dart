import 'dart:ui';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/top_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Contact_Screen extends StatefulWidget {
  const Contact_Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<Contact_Screen> createState() => _Contact_ScreenState();
}
//Added Filter
class _Contact_ScreenState extends State<Contact_Screen> {
  double _sigmaX = 2.0; // from 0-10
  double _sigmaY = 2.0; // from 0-10
  double _opacity = 0.8; // from 0-1
  final String banner_imageurl = "https://cdn.ttgtmedia.com/visuals/German/article/IT-help-desk-adobe.jpg";
  final List<Contact> contacts = [ Contact(name: "Shashank Pirtani", phoneno: 8826518114), Contact(name: "Ritesh Pirtani", phoneno: 7399373150)];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/core/assets/images/background_image_2.jpeg"),
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
                      pagename: 'Contacts',
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
                                banner_imageurl,
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
                          "Contacts",
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Arial narrow'),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        for(int i=0; i<contacts.length;i++)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.call,
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
                                          contacts[i].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Arial narrow',
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                            contacts[i].phoneno.toString(),
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
                            SizedBox(height: 10),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _makePhoneCall('tel:' + contacts[i].phoneno.toString());
                                    },
                                    child: Text('Call Phone',),
                                  ),
                                )),
                            SizedBox(height: 25),
                          ],
                        ),
                      ],
                    ),
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



  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    BackButtonInterceptor.add(backInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }
}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Contact{
  String name;
  int phoneno;
  Contact({
    required this.name,
    required this.phoneno,
});
}
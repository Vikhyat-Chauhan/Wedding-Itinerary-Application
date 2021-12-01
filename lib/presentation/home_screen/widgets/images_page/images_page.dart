import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/images_page/post_list_item.dart';
import 'package:weddingitinerary/presentation/home_screen/widgets/top_bar.dart';

import 'bottom_loader.dart';

class Images_Page extends StatefulWidget {
  const Images_Page({Key? key}) : super(key: key);

  @override
  State<Images_Page> createState() => _Images_PageState();
}

class _Images_PageState extends State<Images_Page> {
  late ScrollController _scrollController;
  bool viewingimage = false;
  late XFile viewingimagefile;
  bool permissionGranted = false;
  //event view related variables
  int eventindex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top_Bar(
          pagename: 'Images',
        ),
        //const SizedBox(height: 40),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              (BlocProvider.of<EventBloc>(context)
                      .state
                      .events[eventindex]
                      .name) +
                  " Images",
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Arial narrow'),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0;
                    i < BlocProvider.of<EventBloc>(context).state.events.length;
                    i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        String eventdirectory = 'compressed' +
                            (BlocProvider.of<EventBloc>(context)
                                .state
                                .events[i]
                                .name) +
                            '/';
                        BlocProvider.of<ImagesBloc>(context).add(
                            ImageFetch(directory: eventdirectory, readmax: 12));
                        setState(() {
                          eventindex = i;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            BlocProvider.of<EventBloc>(context)
                                .state
                                .events[i]
                                .name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        (!viewingimage)
            ? Expanded(
                child: BlocBuilder<ImagesBloc, ImagesBlocState>(
                    builder: (context, state) {
                  if (state.hasReachedMax == false) {
                    if (state.images.length > 12) {
                      if (_scrollController.hasClients) {
                        if (state.status == ImagesStatus.success)
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent + 400);
                      }
                    }
                  }
                  return Stack(
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 3,
                        ),
                        itemCount: state.images.length,
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                viewingimage = true;
                                viewingimagefile = state.images[index];
                              });
                            },
                            child: PostListItem(
                              image: state.images[index],
                            ),
                          );
                        },
                      ),
                      if (state.status == ImagesStatus.loading) BottomLoader(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: FloatingActionButton(
                            onPressed: () {
                              _showDialog(BlocProvider.of<EventBloc>(context)
                                      .state
                                      .events[eventindex]
                                      .name +
                                  '/');
                            },
                            child: const Icon(Icons.file_upload_outlined),
                            tooltip: 'Upload',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              )
            : Expanded(
                child: Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Image.memory(
                          File(viewingimagefile.path).readAsBytesSync()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            viewingimage = false;
                          });
                        },
                        child: const Icon(Icons.arrow_back),
                        tooltip: 'BACK',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _writeToDownloads(
                              File(viewingimagefile.path).readAsBytesSync(),
                              viewingimagefile.path);
                        },
                        child: const Icon(Icons.download),
                        tooltip: 'Download',
                      ),
                    ),
                  ),
                ]),
              ),
      ],
    );
  }

  Future<void> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  Future<void> _writeToDownloads(Uint8List data, String webpath) async {
    // storage permission ask
    Directory downloadsfolder = Directory("/storage/emulated/0/Download");
    if (permissionGranted) {
      final buffer = data.buffer;
      File newfile = File(downloadsfolder.path + '/' + webpath.split('/').last);
      newfile.writeAsBytesSync(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    } else {
      await _getStoragePermission().whenComplete(() {
        final buffer = data.buffer;
        File newfile =
            File(downloadsfolder.path + '/' + webpath.split('/').last);
        newfile.writeAsBytesSync(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Saved to Downloads'),
          ),
        );
      });
    }
  }

  Future<void> _uploadImages(String directory) async {
    final GcloudApi gcloud = GcloudApi();
    await gcloud.spawnclient();
    await ImagePicker().pickMultiImage().then((images) async {
      if (images != null) {
        if (images.length <= 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 400),
              content: Text('Uploading'),
            ),
          );
          try {
            await gcloud.spawnclient().whenComplete(() async {
              await gcloud.saveMany(images, directory).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(milliseconds: 800),
                    content: Text('Done'),
                  ),
                );
              });
            });
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 800),
                content: Text('Error, select less photos.'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 800),
              content: Text('Error, Max 30 files allowed'),
            ),
          );
        }
      }
    });
  }

  Future<void> _uploadVideo(String directory) async {
    final GcloudApi gcloud = GcloudApi();
    await gcloud.spawnclient();
    List<XFile> videolist = [];
    await ImagePicker()
        .pickVideo(
      source: ImageSource.gallery,
    )
        .then((video) async {
      videolist.add(video!);
      if (videolist != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 400),
            content: Text('Uploading'),
          ),
        );
        try {
          await gcloud.spawnclient().whenComplete(() async {
            await gcloud.saveMany(videolist, directory).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 800),
                  content: Text('Done'),
                ),
              );
            });
          });
        } catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 800),
              content: Text('Error Uploading, file too large'),
            ),
          );
        }
      }
    });
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!BlocProvider.of<ImagesBloc>(context).state.hasReachedMax) {
        String eventdirectory = 'compressed' +
            (BlocProvider.of<EventBloc>(context)
                .state
                .events[eventindex]
                .name) +
            '/';
        BlocProvider.of<ImagesBloc>(context)
            .add(ImageFetch(directory: eventdirectory, readmax: 12));
      }
    }
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (viewingimage) {
      setState(() {
        viewingimage = false;
      });
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backInterceptor);
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    ////LOADING FIRST  DATA
    String eventdirectory = 'compressed' +
        (BlocProvider.of<EventBloc>(context).state.events[eventindex].name) +
        '/';
    if (BlocProvider.of<ImagesBloc>(context).state.images.isEmpty) {
      BlocProvider.of<ImagesBloc>(context)
          .add(ImageFetch(directory: eventdirectory, readmax: 12));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }

  void _showDialog(String path) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: const Text(
            "What do you want to Upload?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          contentPadding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _uploadImages(path);
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Images",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _uploadVideo(path);
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Video",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

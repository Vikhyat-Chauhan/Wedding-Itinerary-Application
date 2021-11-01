import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/logic/bloc/event_bloc/event_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/logic/bloc/images_bloc/images_bloc.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/bookings_page/images_gridview.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/images_page/post_list_item.dart';
import 'package:weddingitinerary/presentation/test_screen/widgets/top_bar.dart';

import 'bottom_loader.dart';

class Images_Page extends StatefulWidget {
  const Images_Page({Key? key}) : super(key: key);

  @override
  State<Images_Page> createState() => _Images_PageState();
}

class _Images_PageState extends State<Images_Page> {
  late final ImagesBloc imagesBloc;
  late final StreamSubscription ImagesBlocSubscription;
  final List<XFile> _items = [];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;
  bool viewingimage = false;
  late XFile viewingimagefile;
  bool permissionGranted = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagesBloc, ImagesBlocState>(
      listener: (context, state) {
        if (state.hasReachedMax == true) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Column(
        children: [
          Top_Bar(
            pagename: 'Images',
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Upload Images",
                style: TextStyle(
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
                      i <
                          BlocProvider.of<EventBloc>(context)
                              .state
                              .events
                              .length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showDialog(BlocProvider.of<EventBloc>(context)
                                  .state
                                  .events[i]
                                  .name +
                              '/');
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
                  child: Stack(
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 3,
                        ),
                        itemCount: _items.length,
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                viewingimage = true;
                                viewingimagefile = _items[index];
                              });
                            },
                            child: PostListItem(
                              image: _items[index],
                            ),
                          );
                        },
                      ),
                      if (isLoading) BottomLoader(),
                    ],
                  ),
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
                          backgroundColor: Palette.kToDark.shade50,
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
                          backgroundColor: Palette.kToDark.shade50,
                          tooltip: 'Download',
                        ),
                      ),
                    ),
                  ]),
                ),
        ],
      ),
    );
  }

  Future _getStoragePermission() async {
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

  void _uploadImages(String directory) async {
    final GcloudApi gcloud = GcloudApi();
    await ImagePicker().pickMultiImage().then((images) async {
      if (images != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 400),
            content: Text('Uploading'),
          ),
        );
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
      }
    });
  }

  void _uploadVideo(String directory) async {
    final GcloudApi gcloud = GcloudApi();
    List<XFile> videolist = [];
    await ImagePicker()
        .pickVideo(source: ImageSource.gallery)
        .then((video) async {
      videolist.add(video!);
      if (videolist != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 400),
            content: Text('Uploading'),
          ),
        );
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
      }
    });
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("RUNNING LOAD MORE");
      if (!imagesBloc.state.hasReachedMax) {
        BlocProvider.of<ImagesBloc>(context)
            .add(const ImageFetch(directory: 'Wedding Ceremony/', readmax: 12));
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
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
    imagesBloc = BlocProvider.of<ImagesBloc>(context);
    ImagesBlocSubscription = imagesBloc.stream.listen((state) {
      if (!state.hasReachedMax) {
        if (isLoading) {
          if (_items.isEmpty) {
            _items.addAll(state.images);
          } else {
            state.images.forEach((element) {
              if (!_items.contains(element)) {
                _items.add(element);
              }
            });
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    });
    ////LOADING FIRST  DATA
    if (BlocProvider.of<ImagesBloc>(context).state.images.isEmpty) {
      BlocProvider.of<ImagesBloc>(context)
          .add(const ImageFetch(directory: 'Wedding Ceremony/', readmax: 12));
    } else {
      _items.addAll(BlocProvider.of<ImagesBloc>(context).state.images);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ImagesBlocSubscription.cancel();
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
          content: const Text("What do you want to Upload?",textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
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
                      padding: const EdgeInsets.fromLTRB(5,0,0,0),
                      child: ElevatedButton(
                        onPressed: () {
                          _uploadImages(path);
                          Navigator.of(context).pop();
                        },
                        child:  const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                              "Images",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,5,0),
                      child: ElevatedButton(
                        onPressed: () {
                          _uploadVideo(path);
                          Navigator.of(context).pop();
                        },
                        child:  const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                              "Video",
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

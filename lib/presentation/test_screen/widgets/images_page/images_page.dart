import 'dart:async';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weddingitinerary/core/themes/palette.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top_Bar(pagename: 'Images',),
        const SizedBox(height: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: FloatingActionButton(
                            onPressed: () {
                              _uploadImages();
                            },
                            child: const Icon(Icons.upload_outlined),
                            backgroundColor: Palette.kToDark.shade50,
                            tooltip: 'Upload Images',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Expanded(
                child: Stack(children: [
                  Container(
                    child: Image.memory(
                        File(viewingimagefile.path).readAsBytesSync()),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        viewingimage = false;
                      });
                    },
                    child: const Icon(Icons.arrow_back),
                    backgroundColor: Palette.kToDark.shade50,
                    tooltip: 'BACK',
                  ),
                ]),
              ),
      ],
    );
  }

  void _uploadImages() async {
    setState(() {
      isLoading = true;
    });
    final GcloudApi gcloud = GcloudApi();
    await ImagePicker().pickMultiImage().then((images) async {
      if (images != null) {
        await gcloud.spawnclient().whenComplete(() async {
          await gcloud.saveMany(images, 'Wedding Ceremony/').whenComplete(() {
            setState(() {
              isLoading = false;
            });
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
            .add(ImageFetch(directory: 'Wedding Ceremony/'));
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
    if(viewingimage){
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
    if(BlocProvider.of<ImagesBloc>(context).state.images.isEmpty) {
      BlocProvider.of<ImagesBloc>(context)
          .add(ImageFetch(directory: 'Wedding Ceremony/'));
    }
    else{
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
}

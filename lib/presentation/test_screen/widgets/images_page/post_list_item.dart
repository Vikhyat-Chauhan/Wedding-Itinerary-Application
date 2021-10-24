import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weddingitinerary/data/dataproviders/cacheimageprovider.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.image}) : super(key: key);

  final XFile image;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CacheImageProvider(image.path,File(image.path).readAsBytesSync()),
          ),
        ),
      ),//Image(image: CacheImageProvider(image.path,File(image.path).readAsBytesSync()),),//Image.memory(File(image.path).readAsBytesSync()),
    );
  }
}

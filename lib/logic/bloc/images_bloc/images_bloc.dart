import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';

part 'images_bloc_event.dart';
part 'images_bloc_state.dart';

class ImagesBloc extends Bloc<ImagesBlocEvent, ImagesBlocState> {
  //final MongoDbCubit MongoDbBloc;
  //late final StreamSubscription MongoDbBlocSubscription;
  final GcloudApi gcloud = GcloudApi();
  ImagesBloc(/*this.MongoDbBloc*/) : super(const ImagesBlocState()) {
    on<ImagesBlocEvent>(_imagesEventHandler, transformer: droppable());
  }

  Future<void> _imagesEventHandler(
      ImagesBlocEvent event, Emitter<ImagesBlocState> emit) async {
    if (event is ImageBlocInitial) {
      await gcloud.spawnclient();
    } else if (event is ImageFetch) {
      if (state.status == ImagesStatus.initial) {
        await _fetchImages(
                currentIndex: 0, readmax: 18,)
            .then((value) {
          emit(state.copyWith(
            status: ImagesStatus.success,
            images: value,
          ));
        });
      } else {
        await _fetchImages(
                currentIndex: state.images.length,
                readmax: 18,)
            .then((value) {
          List<XFile> imagelist = value;
          imagelist.addAll(state.images);
          emit(state.copyWith(
            status: ImagesStatus.success,
            images: imagelist,
          ));
        });
      }
    }
  }

  Future<List<XFile>> _fetchImages(
      {required int currentIndex,
      required int readmax,}) async {
    await gcloud.returnallFilename().then((value) {
      if (value.length <= state.images.length) {
        emit(state.copyWith(hasReachedMax: true));
      }
    });
    return await gcloud.readallSave(
      readsize: currentIndex + readmax,
      startIndex: currentIndex,
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weddingitinerary/data/repositories/gcloud/gcloud.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'images_bloc_event.dart';
part 'images_bloc_state.dart';

class ImagesBloc extends Bloc<ImagesBlocEvent, ImagesBlocState> {
  final InternetBloc _internetBloc;
  late final StreamSubscription _internetBlocSubscription;

  final GcloudApi gcloud = GcloudApi();

  ImagesBloc(this._internetBloc,) : super(const ImagesBlocState()) {
    on<ImagesBlocEvent>(_imagesEventHandler, transformer: droppable());

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        await gcloud.spawnclient();
        emit(ImagesBlocState(status: ImagesStatus.success,));
      }
      else if(state.status == InternetStatus.disconnected) {
        emit(ImagesBlocState(status: ImagesStatus.serviceunavailable));
      }
    });

  }

  Future<void> _imagesEventHandler(
      ImagesBlocEvent event, Emitter<ImagesBlocState> emit) async {
    if (event is ImageBlocInitial) {
      await gcloud.spawnclient();
    } else if (event is ImageFetch) {

      if(state.directory != event.directory){
        emit(state.copyWith(
          status: ImagesStatus.loading,
          hasReachedMax: false,
          directory: event.directory,
          images: [],
        ));
      }
      if (state.status == ImagesStatus.initial) {
        emit(state.copyWith(status: ImagesStatus.loading));
        await _fetchImages(
                currentIndex: 0, readmax: 12,directory: event.directory)
            .then((value) {
          emit(state.copyWith(
            status: ImagesStatus.success,
            directory: event.directory,
            images: value,
          ));
        });
      } else {
        emit(state.copyWith(status: ImagesStatus.loading));
        await _fetchImages(
                currentIndex: state.images.length,
                readmax: event.readmax,directory: event.directory)
            .then((value) {
          List<XFile> imagelist = value;
          state.images.addAll(imagelist);
          emit(state.copyWith(
            status: ImagesStatus.success,
            directory: event.directory,
            images: state.images,
          ));
        });
      }
    }
  }
  /* original
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
  } */


  Future<List<XFile>> _fetchImages(
      {required int currentIndex,
      required int readmax,required directory}) async {
    await gcloud.returnFilename(directory).then((value) {
      if (value.length <= state.images.length) {
        emit(state.copyWith(hasReachedMax: true));
      }
    });
    return await gcloud.readSave(
      readsize: currentIndex + readmax,
      startIndex: currentIndex,
      directory: directory,
    );
  }

  @override
  Future<void> close() {
    _internetBlocSubscription.cancel();
    return super.close();
  }
}

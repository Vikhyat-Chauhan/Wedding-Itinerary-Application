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
      if (state.status == ImagesStatus.initial) {
        await _fetchImages(
                currentIndex: 0, readmax: 12,)
            .then((value) {
          emit(state.copyWith(
            status: ImagesStatus.success,
            images: value,
          ));
        });
      } else {
        await _fetchImages(
                currentIndex: state.images.length,
                readmax: event.readmax,)
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
  /*
  Future<List<XFile>> _fetcheventImages(
      {required int currentIndex,
        required int readmax,required String eventname}) async {
    await gcloud.returnFilename('compressed'+eventname +'/').then((value) {
      if (value.length <= state.images.length) {
        emit(state.copyWith(hasReachedMax: true));
      }
    });
    return await gcloud.readallSave(
      readsize: currentIndex + readmax,
      startIndex: currentIndex,
    );
  } */

  @override
  Future<void> close() {
    _internetBlocSubscription.cancel();
    return super.close();
  }
}

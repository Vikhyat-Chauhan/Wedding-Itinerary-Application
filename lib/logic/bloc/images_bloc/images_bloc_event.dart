part of 'images_bloc.dart';

abstract class ImagesBlocEvent extends Equatable {
  const ImagesBlocEvent();

  @override
  List<Object> get props => [];
}

class ImageFetch extends ImagesBlocEvent {
  const ImageFetch({required this.directory, required this.readmax});
  final String directory;
  final int readmax;
}

class ImageBlocInitial extends ImagesBlocEvent {}


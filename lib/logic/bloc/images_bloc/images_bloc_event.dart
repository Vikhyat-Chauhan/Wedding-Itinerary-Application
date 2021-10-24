part of 'images_bloc.dart';

abstract class ImagesBlocEvent extends Equatable {
  const ImagesBlocEvent();

  @override
  List<Object> get props => [];
}

class ImageFetch extends ImagesBlocEvent {
  const ImageFetch({required this.directory});
  final String directory;

  String get getDirectory{
    return directory;
  }
}

class ImageBlocInitial extends ImagesBlocEvent {}


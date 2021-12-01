part of 'images_bloc.dart';

enum ImagesStatus {
  initial,
  loading,
  success,
  serviceunavailable,
}

class ImagesBlocState extends Equatable {
  const ImagesBlocState({
    this.status = ImagesStatus.initial,
    this.images = const <XFile>[],
    this.directory = '/',
    this.hasReachedMax = false,
  });

  final ImagesStatus status;
  final List<XFile> images;
  final String directory;
  final bool hasReachedMax;

  ImagesBlocState copyWith({
    ImagesStatus? status,
    List<XFile>? images,
    String? directory,
    bool? hasReachedMax,
  }) {
    return ImagesBlocState(
      status: status ?? this.status,
      images: images ?? this.images,
      directory: directory ?? this.directory,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ImagesBlocState { status: $status, directory: $directory, hasReachedMax: $hasReachedMax, images: ${images} }''';
  }

  @override
  List<Object> get props => [status, images, hasReachedMax];
}

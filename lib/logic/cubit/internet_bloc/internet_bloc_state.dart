part of 'internet_bloc.dart';

enum InternetStatus{initial, connected, disconnected,}

class InternetBlocState extends Equatable {
  const InternetBlocState({
    this.status = InternetStatus.initial,
  });

  final InternetStatus status;

  InternetBlocState copyWith({
    required InternetStatus? status,
  }) {
    return InternetBlocState(
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''InternetBlocState { status: $status, }''';
  }

  @override
  List<Object> get props => [status,];
}

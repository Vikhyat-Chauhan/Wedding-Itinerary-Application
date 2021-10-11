part of 'mongodb_bloc.dart';

enum MongodbStatus{initial, connected, disconnected, serviceunavailable, working, undefined}

class MongodbBlocState extends Equatable {
  const MongodbBlocState({
    this.status = MongodbStatus.initial,
  });

  final MongodbStatus status;

  MongodbBlocState copyWith({
    MongodbStatus? status,
  }) {
    return MongodbBlocState(
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''MongodbBlocState { status: $status, }''';
  }

  @override
  List<Object> get props => [status,];
}
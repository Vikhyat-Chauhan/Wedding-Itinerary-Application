part of 'mongodb_bloc.dart';

abstract class MongodbBlocEvent extends Equatable {
  const MongodbBlocEvent();

  @override
  List<Object> get props => [];
}

class Connect extends MongodbBlocEvent {
}

class Disconnect extends MongodbBlocEvent {
}
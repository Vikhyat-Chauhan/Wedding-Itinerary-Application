part of 'internet_bloc.dart';

abstract class InternetBlocEvent extends Equatable {
  const InternetBlocEvent();

  @override
  List<Object> get props => [];
}

class InitialInternetBlocEvent extends InternetBlocEvent {
}
part of 'bottomnavbar_bloc.dart';

abstract class BottomnavbarBlocEvent extends Equatable {
  const BottomnavbarBlocEvent();

  @override
  List<Object> get props => [];
}

class Bottomnavbarsetindex extends BottomnavbarBlocEvent {
  const Bottomnavbarsetindex({required this.pageindex});
  final int pageindex;

  int get getindexpage{
    return pageindex;
  }
}

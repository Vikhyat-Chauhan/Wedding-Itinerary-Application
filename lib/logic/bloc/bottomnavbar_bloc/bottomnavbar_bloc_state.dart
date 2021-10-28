part of 'bottomnavbar_bloc.dart';

class BottomnavbarBlocState extends Equatable {
  const BottomnavbarBlocState({
    this.pageindex = 0,
  });

  final int pageindex;

  BottomnavbarBlocState copyWith({
    int? pageindex,
  }) {
    return BottomnavbarBlocState(
      pageindex: pageindex ?? this.pageindex,
    );
  }

  @override
  String toString() {
    return '''BottomnavbarBlocState { pageindex: $pageindex, }''';
  }

  @override
  List<Object> get props => [pageindex,];
}
import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LoadNextPageEvent extends SplashEvent {
  @override
  String toString() => 'LoadNextPageEvent';
}

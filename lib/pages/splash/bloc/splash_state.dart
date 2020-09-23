import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SplashInitState extends SplashState{
  @override
  String toString() => 'SplashInitState';
}

class GoToHomePageState extends SplashState{
  @override
  String toString() => 'GoToHomePageState';
}

class GotoOnBoardingState extends SplashState{
  @override
  String toString() => 'GotoOnBoardingState';
}



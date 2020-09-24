import 'package:equatable/equatable.dart';

abstract class ContentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialContentState extends ContentState {
  @override
  String toString() => 'InitialContentState';
}

class ContentErrorState extends ContentState{
  final String message;

  ContentErrorState(this.message);
  @override
  String toString() => 'ContentErrorState';
}

class ReadContentState extends ContentState{
  @override
  String toString() => 'ReadContentState';
}

class CreateContentState extends ContentState{
  @override
  String toString() => 'CreateContentState';
}

class LoadingState extends ContentState{}

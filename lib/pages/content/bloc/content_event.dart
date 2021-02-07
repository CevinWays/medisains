import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateContentEvent extends ContentEvent{
  final String title;
  final String desc;
  final String category;

  CreateContentEvent({this.category, this.title, this.desc});
  @override
  String toString() => 'CreateContentEvent';
}

class ReadContentEvent extends ContentEvent{
  final String category;
  final String uid;

  ReadContentEvent({this.category,this.uid});
  @override
  String toString() => 'ReadContentEvent';
}


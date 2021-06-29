import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateCategoryEvent extends CategoryEvent {
  final String title;
  final String desc;

  CreateCategoryEvent({this.title, this.desc});

  @override
  String toString() => 'CreateCategoryEvent';
}

class ReadCategoryEvent extends CategoryEvent {
  @override
  String toString() => 'ReadCategoryEvent';
}

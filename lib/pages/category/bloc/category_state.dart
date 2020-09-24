import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialCategoryState extends CategoryState {
  @override
  String toString() => 'InitialCategoryState';
}

class CategoryErrorState extends CategoryState{
  final String message;

  CategoryErrorState(this.message);
  @override
  String toString() => 'CategoryErrorState';
}

class CreateCategoryState extends CategoryState{
  @override
  String toString() => 'CreateCategoryState';
}

class ReadCategoryState extends CategoryState{
  @override
  String toString() => 'ReadCategoryState';
}

class LoadingState extends CategoryState{}

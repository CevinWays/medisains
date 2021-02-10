import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateContentEvent extends ContentEvent{
  final String title;
  final String desc;
  final String category;
  final File fileImage;
  final File fileDoc;

  CreateContentEvent({this.fileImage,this.category, this.title, this.desc, this.fileDoc});
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

class SearchContentEvent extends ContentEvent{
  final String searchText;

  SearchContentEvent({this.searchText});

  @override
  String toString() => 'SearchContentEvent';
}

class UpdateContentEvent extends ContentEvent{
  final String title;
  final String desc;
  final String category;
  final File fileImage;
  final File fileDoc;

  UpdateContentEvent({this.title, this.desc, this.category, this.fileImage, this.fileDoc});

  @override
  String toString() =>'UpdateContentEvent';

}


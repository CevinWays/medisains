import 'package:equatable/equatable.dart';
import 'package:medisains/pages/content/model/content_model.dart';

abstract class ContentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialContentState extends ContentState {
  @override
  String toString() => 'InitialContentState';
}

class ContentErrorState extends ContentState {
  final String message;

  ContentErrorState(this.message);

  @override
  String toString() => 'ContentErrorState';
}

class ReadContentState extends ContentState {
  final List<ContentModel> listContentModel;

  ReadContentState({this.listContentModel});

  @override
  String toString() => 'ReadContentState';
}

class CreateContentState extends ContentState {
  @override
  String toString() => 'CreateContentState';
}

class LoadingState extends ContentState {}

class SearchContentState extends ContentState {
  final List<ContentModel> listContentSearchResult;

  SearchContentState({this.listContentSearchResult});

  @override
  String toString() => 'SearchContentState';
}

class UpdateContentState extends ContentState {
  @override
  String toString() => 'UpdateContentState';
}

class DeleteContentState extends ContentState {
  @override
  String toString() => 'DeleteContentState';
}

class RecommendationInDetailState extends ContentState {
  final List<ContentModel> listRecommContentDetail;

  RecommendationInDetailState({this.listRecommContentDetail});

  @override
  String toString() => 'RecommendationInDetailState';
}

class CommonDataState extends ContentState {
  final List<ContentModel> listCommon;
  final List<ContentModel> listUnusual;

  CommonDataState({this.listCommon, this.listUnusual});

  @override
  String toString() => 'CommonDataState';
}

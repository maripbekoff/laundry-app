part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchedItems extends SearchState {
  final List<Catalog> catalog;

  SearchedItems({@required this.catalog});
}

class NotSearching extends SearchState {}

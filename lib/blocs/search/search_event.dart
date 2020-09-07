part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchItem extends SearchEvent {
  final String query;
  final List<Catalog> catalog;

  SearchItem({@required this.query, @required this.catalog});
}

class CloseSearchBar extends SearchEvent {}

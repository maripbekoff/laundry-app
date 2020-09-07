import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:laundry/models/catalog.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial());

  List<Catalog> _filteredList = List<Catalog>();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchItem) {
      event.catalog.forEach((item) {
        if (item.name.toLowerCase().contains(event.query.toLowerCase())) {
          _filteredList.add(item);
        }
      });
      yield SearchedItems(catalog: _filteredList);
      _filteredList = [];
    } else if (event is CloseSearchBar) yield NotSearching();
  }
}

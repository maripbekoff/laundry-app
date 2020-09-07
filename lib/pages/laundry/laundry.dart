import 'package:flutter/cupertino.dart';
import 'package:laundry/blocs/search/search_bloc.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/widgets/category.dart';
import 'package:laundry/pages/laundry/widgets/search_bar.dart';
import 'package:laundry/repository/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaundryPage extends StatefulWidget {
  LaundryPage({@required this.catalog});

  List<Catalog> catalog = List<Catalog>();

  @override
  _LaundryPageState createState() => _LaundryPageState();
}

class _LaundryPageState extends State<LaundryPage>
    with SingleTickerProviderStateMixin {
  final LaundryRepo laundryRepo = LaundryRepo();
  TextEditingController _searchTextController = new TextEditingController();
  FocusNode _searchFocusNode = new FocusNode();
  Animation _animation;
  AnimationController _animationController;

  SearchBloc _searchBloc;

  @override
  void initState() {
    _animationController = new AnimationController(
      duration: new Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = new CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _searchFocusNode.addListener(() {
      if (!_animationController.isAnimating) {
        _animationController.forward();
      }
    });
    super.initState();
  }

  void _cancelSearch() {
    _searchTextController.clear();
    _searchFocusNode.unfocus();
    _animationController.reverse();
    _searchBloc.add(CloseSearchBar());
  }

  _search() {
    _searchBloc.add(
        SearchItem(catalog: widget.catalog, query: _searchTextController.text));
  }

  void _clearSearch() {
    _searchTextController.clear();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchBloc = context.bloc<SearchBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: CupertinoPageScaffold(
        child: Column(
          children: [
            IOSSearchBar(
              controller: _searchTextController,
              focusNode: _searchFocusNode,
              animation: _animation,
              onCancel: _cancelSearch,
              onClear: _clearSearch,
              onUpdate: _search(),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTapUp: (TapUpDetails _) {
                  _searchFocusNode.unfocus();
                  _searchBloc.add(CloseSearchBar());
                  if (_searchTextController.text == '') {
                    _animationController.reverse();
                  }
                },
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial)
                      return _buildListView(widget.catalog);
                    else if (state is NotSearching)
                      return _buildListView(widget.catalog);
                    else if (state is SearchedItems)
                      return _buildListView(state.catalog);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildListView(List<Catalog> catalog) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: catalog.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return CategoryWidget(catalog: catalog[index]);
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/widgets/category.dart';
import 'package:laundry/pages/laundry/widgets/search_bar.dart';
import 'package:laundry/repository/api.dart';

class LaundryPage extends StatefulWidget {
  LaundryPage({@required this.catalog});

  List<Catalog> catalog = List<Catalog>();

  @override
  _LaundryPageState createState() => _LaundryPageState();
}

class _LaundryPageState extends State<LaundryPage>
    with TickerProviderStateMixin {
  final LaundryRepo laundryRepo = LaundryRepo();
  TextEditingController _searchTextController = new TextEditingController();
  FocusNode _searchFocusNode = new FocusNode();
  Animation _animation;
  AnimationController _animationController;

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
  }

  void _clearSearch() {
    _searchTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.catalog.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 16);
                },
                itemBuilder: (BuildContext context, int index) {
                  return CategoryWidget(catalog: widget.catalog[index]);
                },
              ),
            ),
            // GestureDetector(
            //   onTapUp: (TapUpDetails _) {
            //     _searchFocusNode.unfocus();
            //     if (_searchTextController.text == '') {
            //       _animationController.reverse();
            //     }
            //   },
            //   child: new Container(
            //     height: 50,
            //     color: CupertinoColors.destructiveRed,
            //   ), // Add search body here
            // ),
          ],
        ),
      ),
    );
  }
}

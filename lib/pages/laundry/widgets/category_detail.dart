import 'package:flutter/cupertino.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/widgets/item.dart';

class CategoryDetailPage extends StatelessWidget {
  CategoryDetailPage({Key key, @required this.catalog}) : super(key: key);

  Catalog catalog = Catalog();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${catalog.category['name']}'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: 1,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16);
          },
          itemBuilder: (BuildContext context, int index) {
            return ItemWidget(catalog: catalog);
          },
        ),
      ),
    );
  }
}

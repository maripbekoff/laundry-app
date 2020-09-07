import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/widgets/category_detail.dart';
import 'package:laundry/utils/theme/theme.dart';

class CategoryWidget extends StatelessWidget {
  final CustomThemeData customThemeData = CustomThemeData();

  CategoryWidget({Key key, @required this.catalog}) : super(key: key);
  Catalog catalog = Catalog();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) =>
                CategoryDetailPage(catalog: catalog),
          )),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 110,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${catalog.category['name']}',
                        style: customThemeData.title),
                    SizedBox(height: 10),
                    Flexible(
                      child: Container(
                        height: 50,
                        child: Text(
                          '${catalog.category['description']}',
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: customThemeData.description,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 120,
              child: CachedNetworkImage(
                imageUrl: '${catalog.category['image']}',
                fit: BoxFit.cover,
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(CupertinoIcons.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

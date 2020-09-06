import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/laundry.dart';

class LaundryIntercessor extends StatelessWidget {
  LaundryIntercessor({Key key, @required this.catalog}) : super(key: key);
  Future<List<Catalog>> catalog;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: catalog,
      builder: (BuildContext context, AsyncSnapshot<List<Catalog>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: CupertinoActivityIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Offstage();
            else
              return LaundryPage(catalog: snapshot.data);
        }
      },
    );
  }
}

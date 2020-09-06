import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs/cart/cart_bloc.dart';
import 'package:laundry/models/catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemWidget extends StatelessWidget {
  ItemWidget({Key key, @required this.catalog}) : super(key: key);

  Catalog catalog = Catalog();
  CartBloc cartBloc;

  @override
  Widget build(BuildContext context) {
    cartBloc = context.bloc<CartBloc>();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 110,
      child: Stack(
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: CupertinoButton(
              onPressed: () {
                return buildDescription(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEFF6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Color(0xFFB0B3BC),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: '${catalog.image}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) =>
                      Icon(CupertinoIcons.ellipsis),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${catalog.name}'),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'Срок чистки / ',
                          style: TextStyle(color: CupertinoColors.inactiveGray),
                          children: [
                            TextSpan(
                              text: '${catalog.unit_time} дня',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.add_circled,
                                  color: CupertinoColors.black,
                                ),
                                onPressed: () {
                                  cartBloc.add(AddItem(catalog: catalog));
                                },
                              ),
                              SizedBox(width: 5),
                              Text('1'),
                              SizedBox(width: 5),
                              CupertinoButton(
                                minSize: 0,
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.minus_circled,
                                  color: CupertinoColors.black,
                                ),
                                onPressed: () {
                                  cartBloc.add(RemoveItem(catalog: catalog));
                                },
                              ),
                            ],
                          ),
                          Text(
                            '${catalog.unit_price} тг',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future buildDescription(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: CupertinoColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${catalog.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEDEFF6),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.clear,
                            size: 26,
                            color: CupertinoColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${catalog.description}',
                  ),
                ],
              ),
            ),
          );
        });
  }
}

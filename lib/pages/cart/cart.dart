import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/cart/cart_bloc.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/pages/laundry/widgets/item.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Catalog> catalog = [];
  double amount = 0.0;
  CartBloc _cartBloc;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    _cartBloc = context.bloc<CartBloc>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Корзина'),
        trailing: CupertinoButton(
          padding: const EdgeInsets.only(left: 8.0),
          onPressed: () {},
          child: new CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _cartBloc.add(ClearCart()),
            child: Text(
              'Очистить',
              softWrap: false,
              style: new TextStyle(
                inherit: false,
                color: CupertinoColors.destructiveRed,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemUpdated) {
            catalog = state.catalog;
            amount = state.amount;
          } else if (state is CartEmpty) {
            catalog = state.catalog;
            amount = state.amount;
          } else if (state is CartInit) {
            catalog = state.catalog;
            amount = state.amount;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartInitial)
                        return _buildEmptyCart();
                      else if (state is CartInit)
                        return _buildCartItems();
                      else if (state is CartEmpty)
                        return _buildEmptyCart();
                      else if (state is CartItemUpdated)
                        return _buildCartItems();
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: CupertinoColors.white),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Общая сумма $amount тг',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('${catalog.length} вещи'),
                      ],
                    ),
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text(
                        'Оформить',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      disabledColor: CupertinoColors.inactiveGray,
                      onPressed: catalog.length != 0
                          ? () {
                              _cartBloc.add(ClearCart());
                              
                              print(
                                  '---------------------------------------------');
                              print(
                                  'Вы оформили заказ ($count вещей на сумму $amount тг):');
                              catalog.forEach((item) {
                                print(
                                    'Название: ${item.name}\nЦена: ${item.unit_price} тг\nUUID: ${item.uuid}');
                                print('');
                              });
                              print(
                                  '---------------------------------------------');
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text('Спасибо!'),
                                    content: Text(
                                        'Вы успешно оформили доставку! Пожалуйста ожидайте.'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text('ОК'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Center _buildEmptyCart() {
    return Center(
      child: Text('Корзина пустая.'),
    );
  }

  ListView _buildCartItems() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: catalog.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return ItemWidget(catalog: catalog[index], isCartItem: true);
      },
    );
  }
}

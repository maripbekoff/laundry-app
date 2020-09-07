import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:laundry/helpers/secure_storage.dart';
import 'package:laundry/models/catalog.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial());
  final SecureStorage _storage = SecureStorage();
  List<Catalog> cartItems = List<Catalog>();
  double amount = 0.0;
  List<Catalog> decodedCartItems = List<Catalog>();
  int itemCount = 0;

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartUninitialized) {
      List<Catalog> _initList;
      try {
        _initList = await _decodeCartItems ?? [];
        if (_initList.isNotEmpty) {
          cartItems = _initList;
          cartItems.forEach((item) {
            amount += double.parse(item.unit_price);
          });
          yield CartInit(
              catalog: cartItems, amount: amount, itemCount: itemCount);
        } else {
          _clearCart();
          yield CartEmpty();
        }
      } catch (e) {
        print('Корзина пуста.');
      }
    } else if (event is AddItem) {
      cartItems.add(event.catalog);
      amount += double.parse(event.catalog.unit_price);
      if (cartItems.contains(event.catalog)) {
        event.catalog.itemCount += 1;
        cartItems = cartItems.toSet().toList();
        print(cartItems);
      } else {
        event.catalog.itemCount = 1;
        cartItems = cartItems.toSet().toList();
      }
      cartItems.forEach(
        (item) => itemCount += item.itemCount,
      );
      await _encodeCartItems();
      yield CartItemUpdated(
          catalog: cartItems, amount: amount, itemCount: itemCount);
    } else if (event is RemoveItem) {
      amount -= double.parse(event.catalog.unit_price);
      if (event.catalog.itemCount > 1) {
        event.catalog.itemCount -= 1;
      } else {
        event.catalog.itemCount = 0;
        cartItems.remove(event.catalog);
      }
      cartItems.forEach(
        (item) => itemCount += item.itemCount,
      );
      await _encodeCartItems();
      if (cartItems.isEmpty) {
        _clearCart();
        yield CartEmpty();
      } else
        yield CartItemUpdated(
            catalog: cartItems, amount: amount, itemCount: itemCount);
    } else if (event is ClearCart) {
      _clearCart();
      yield CartEmpty();
    }
  }

  Future<void> _encodeCartItems() async =>
      await _storage.writeCartItems(value: json.encode(cartItems));

  Future<List<Catalog>> get _decodeCartItems async {
    List _tempList = (json.decode(await _storage.readCartItems));
    List<Catalog> catalog = List<Catalog>();
    _tempList.forEach((item) {
      catalog.add(Catalog(
        name: item['name'],
        image: item['image'],
        description: item['description'],
        unit_type: item['unit_type'],
        unit_time: item['unit_time'],
        unit_price: item['unit_price'],
        category: item['category'],
        uuid: item['uuid'],
      ));
    });
    return catalog;
  }

  void _clearCart() {
    cartItems = [];
    amount = 0.0;
    _storage.removeCartItems();
  }
}

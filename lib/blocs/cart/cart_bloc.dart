import 'dart:async';

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

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is AddItem) {
      cartItems.add(event.catalog);
      amount += double.parse(event.catalog.unit_price);
      yield CartItemUpdated(catalog: cartItems, amount: amount);
    } else if (event is RemoveItem) {
      cartItems.remove(event.catalog);
      amount -= double.parse(event.catalog.unit_price);
      yield CartItemUpdated(catalog: cartItems, amount: amount);
      if (cartItems.isEmpty) {
        _clearCart();
        yield CartEmpty();
      }
    } else if (event is ClearCart) {
      _clearCart();
      yield CartEmpty();
    }
  }

  void _clearCart() {
    cartItems = [];
    amount = 0.0;
  }
}

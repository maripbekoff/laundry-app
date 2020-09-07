part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartInit extends CartState {
  final List<Catalog> catalog;
  final double amount;
  final int itemCount;

  CartInit({
    @required this.catalog,
    @required this.amount,
    @required this.itemCount,
  });
}

class CartEmpty extends CartState {
  final List<Catalog> catalog = [];
  final double amount = 0.0;
}

class CartItemUpdated extends CartState {
  final List<Catalog> catalog;
  final double amount;
  final int itemCount;

  CartItemUpdated({
    @required this.catalog,
    @required this.amount,
    @required this.itemCount,
  });
}

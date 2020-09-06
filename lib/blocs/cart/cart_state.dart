part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {
  final List<Catalog> catalog = [];
  final double amount = 0.0;
}

class CartEmpty extends CartState {
  final List<Catalog> catalog = [];
  final double amount = 0.0;
}

class CartItemUpdated extends CartState {
  final List<Catalog> catalog;
  final double amount;

  CartItemUpdated({@required this.catalog, @required this.amount});
}

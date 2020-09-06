part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class AddItem extends CartEvent {
  final Catalog catalog;

  AddItem({@required this.catalog});
}

class RemoveItem extends CartEvent {
  final Catalog catalog;

  RemoveItem({@required this.catalog});
}

class ClearCart extends CartEvent {}

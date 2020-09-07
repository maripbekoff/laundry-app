part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class CartUninitialized extends CartEvent {}

class AddItem extends CartEvent {
  Catalog catalog;

  AddItem({@required this.catalog});
}

class RemoveItem extends CartEvent {
  Catalog catalog;

  RemoveItem({@required this.catalog});
}

class ClearCart extends CartEvent {}

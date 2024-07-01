import 'package:flutter/foundation.dart';
import 'package:my_app/dto/Produk.dart';

@immutable
class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<Produk> cart;

  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

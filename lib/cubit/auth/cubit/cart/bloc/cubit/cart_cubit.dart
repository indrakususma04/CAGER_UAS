import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/dto/Produk.dart';

class CartCubit extends Cubit<List<Produk>> {
  final String userId; // Add userId as a member variable

  CartCubit(this.userId) : super([]);

  void addProduct(Produk produk) {
    state.add(produk);
    emit(List.from(state));
  }

  void removeProduct(int idProduk) {
    state.removeWhere((produk) => produk.idProduk == idProduk);
    emit(List.from(state));
  }

  void clearCart() {
    emit([]);
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var produk in state) {
      totalPrice += double.parse(produk.harga);
    }
    return totalPrice;
  }
}

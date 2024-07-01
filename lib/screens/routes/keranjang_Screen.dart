// ignore_for_file: file_names, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/cubit/auth/cubit/cart/bloc/cubit/cart_cubit.dart';
import 'package:my_app/dto/Produk.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/routes/Chekout_Screen.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';


class KeranjangScreen extends StatefulWidget {
  @override
  _KeranjangScreenState createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  static Future<void> addRental(String idProduk, double totalHarga, BuildContext context) async {
    final url = Uri.parse(Endpoints.Rental);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final data = {
      'id_produk': idProduk,
      'status': 'proses', // Assuming 'proses' is the status
      'total_harga': totalHarga.toString(), // Mengubah double ke String
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking berhasil')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan booking')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartCubit, List<Produk>>(
              builder: (context, cart) {
                if (cart.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final produk = cart[index];
                      return _buildProductContainer(context, produk);
                    },
                  );
                } else {
                  return Center(child: Text('Keranjang Kosong'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, List<Produk>>(
        builder: (context, cart) {
          if (cart.isNotEmpty) {
            final cartCubit = context.read<CartCubit>();
            final totalPrice = cartCubit.getTotalPrice();

            return BottomAppBar(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pesanan: Rp ${totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.white,
                      ),
                      child: const Text('BOOKING'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildProductContainer(BuildContext context, Produk produk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (isChecked) {
                  // Handle checkbox state change if needed
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
          ListTile(
            title: Text(produk.namaProduk),
            subtitle: Text('Harga Sewa: Rp ${produk.harga}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    context.read<CartCubit>().removeProduct(produk.idProduk);
                  },
                ),
                Text('1'), 
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.read<CartCubit>().addProduct(produk);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<CartCubit>().removeProduct(produk.idProduk);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

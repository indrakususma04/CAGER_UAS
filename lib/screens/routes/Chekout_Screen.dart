// ignore_for_file: file_names, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/cubit/auth/cubit/cart/bloc/cubit/cart_cubit.dart';
import 'package:my_app/dto/Produk.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  int _calculateDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return 0;
  }

  double _calculateTotalPrice(List<Produk> cart, int days) {
    double totalPrice = 0.0;
    for (var produk in cart) {
      totalPrice += double.parse(produk.harga) * days; 
    }
    return totalPrice;
  }

  static Future<void> addRental(String idProduk, String tanggalMulai, String tanggalSelesai, String status, double totalHarga, BuildContext context) async {
    final url = Uri.parse(Endpoints.Rental);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final data = {
      'id_produk': idProduk,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'status': status,
      'total_harga': totalHarga,
    };

    try {
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
        // Tambahkan logging untuk melihat respon dari server
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal melakukan booking: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CartCubit, List<Produk>>(
        builder: (context, cart) {
          final int days = _calculateDays();
          final double totalPrice = _calculateTotalPrice(cart, days);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Produk yang akan di-booking:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final produk = cart[index];
                      return ListTile(
                        title: Text(produk.namaProduk),
                        subtitle: Text('Harga: Rp ${produk.harga}'),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(_startDate == null
                          ? 'Pilih Tanggal Mulai'
                          : 'Mulai: ${_startDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text(_endDate == null
                          ? 'Pilih Tanggal Selesai'
                          : 'Selesai: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                  ],
                ),
                if (_startDate != null && _endDate != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Jumlah hari: $days',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Harga: Rp ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_startDate == null || _endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan pilih tanggal mulai dan selesai')),
                        );
                        return;
                      }
                      for (final produk in cart) {
                        await addRental(
                          produk.idProduk.toString(),
                          _startDate!.toIso8601String().split('T')[0],  // Mengirim tanggal dalam format YYYY-MM-DD
                          _endDate!.toIso8601String().split('T')[0],  // Mengirim tanggal dalam format YYYY-MM-DD
                          'booked',
                          double.parse(produk.harga) * days, // Konversi harga dari String ke double
                          context,
                        );
                      }
                      context.read<CartCubit>().clearCart();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text('BOOKING'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

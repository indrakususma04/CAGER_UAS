// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:my_app/dto/Rental.dart';
import 'package:my_app/services/data_service.dart';

class RentalScreen extends StatefulWidget {
  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  late Future<List<Rental>> _rentalsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRentals();
  }

  Future<void> _fetchRentals() async {
    try {
      _rentalsFuture = DataService.fetchRentals();
    } catch (e) {
      print('Error fetching rentals: $e');
      // Handle error state if needed
    }
  }

  Future<void> _updateStatus(int rentalId, String newStatus) async {
    try {
      await DataService.updateRentalStatus(rentalId, newStatus);
      await _fetchRentals();
    } catch (e) {
      print('Error updating status: $e');
      // Handle error state if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Rental Screen'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder<List<Rental>>(
        future: _rentalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rentals available'));
          } else {
            final rentals = snapshot.data!;

            return ListView.builder(
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('ID User: ${rentals[index].idUser.toString()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${rentals[index].username}'),
                        Text('ID Produk: ${rentals[index].idProduk.toString()}'),
                        Text('Nama Produk: ${rentals[index].namaProduk}'),
                        Text('Harga: ${rentals[index].harga}'),
                        Text('Tanggal Mulai: ${rentals[index].tanggalMulai}'),
                        Text('Tanggal Selesai: ${rentals[index].tanggalSelesai}'),
                        Text('Status: ${rentals[index].status}'),
                        Text('Total Harga: ${rentals[index].totalHarga}'),
                      ],
                    ),
                    trailing: DropdownButton<String>(
                      value: rentals[index].status,
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          _updateStatus(rentals[index].idUser, newStatus);
                        }
                      },
                      items: <String>['proses', 'selesai', 'batal']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
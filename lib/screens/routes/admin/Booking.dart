// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/services/data_service.dart'; // Sesuaikan dengan path yang sesuai

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final DataService _dataService = DataService(); // Instance dari DataService

  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      List<dynamic> fetchedBookings = await _dataService.fetchBookings();
      setState(() {
        bookings = fetchedBookings;
        isLoading = false; // Set isLoading ke false setelah data berhasil dimuat
      });
    } catch (e) {
      print('Error fetching bookings: $e');
      setState(() {
        isLoading = false; // Set isLoading ke false jika terjadi kesalahan
      });
      // Handle error fetching bookings
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Bookings'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
        )
          : bookings.isEmpty
              ? Center(
                  child: Text(
                    'No bookings found',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemCount: bookings.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['nama_produk'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Status: ${booking['status']}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Total Harga: ${booking['total_harga']}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
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
// ignore_for_file: file_names, camel_case_types, use_super_parameters, prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class manproduk extends StatelessWidget {
  const manproduk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Produk'),
        backgroundColor: Colors.blue, // Warna app bar biru
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuCard(
              title: 'Tambah Produk',
              icon: Icons.add,
              onTap: () {
                Navigator.pushNamed(context, '/produk_form');
              },
            ),
            SizedBox(height: 20),
            MenuCard(
              title: 'Produk di Katalog',
              icon: Icons.list,
              onTap: () {
                Navigator.pushNamed(context, '/produk_katalog');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Container(
        height: 80, // Tinggi card yang lebih besar
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          leading: Icon(icon, size: 40, color: Colors.blue),
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

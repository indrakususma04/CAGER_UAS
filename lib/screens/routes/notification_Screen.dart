// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification 1'),
            subtitle: const Text('This is the first notification'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Tambahkan logika untuk menangani ketika notifikasi diklik
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification 2'),
            subtitle: const Text('This is the second notification'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Tambahkan logika untuk menangani ketika notifikasi diklik
            },
          ),
          // Tambahkan ListTile sesuai dengan jumlah notifikasi yang Anda miliki
        ],
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_app/services/data_service.dart';

class KategoriForm extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID Kategori'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Kategori'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi Kategori'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String id = _idController.text.trim();
                final String nama = _namaController.text.trim();
                final String deskripsi = _deskripsiController.text.trim();

                if (id.isNotEmpty && nama.isNotEmpty && deskripsi.isNotEmpty) {
                  try {
                    await DataService.tambahKategori(id, nama, deskripsi);
                    Navigator.pop(context, true);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Gagal menambahkan kategori: $e'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Peringatan'),
                        content: const Text('Semua field harus diisi.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

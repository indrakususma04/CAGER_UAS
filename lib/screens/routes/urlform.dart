// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:my_app/utils/secure_storage_util.dart';

// ignore: use_key_in_widget_constructors
class URLForm extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _URLFormState createState() => _URLFormState();
}

class _URLFormState extends State<URLForm> {
  final _urlController = TextEditingController();

  Future<void> _saveURL() async {
    String url = _urlController.text.trim();

    // Validasi URL sebelum menyimpan
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validasi skema URL
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL must start with http:// or https://'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await SecureStorageUtil.writeBaseUrl(url);

      // Menampilkan snackbar jika URL berhasil disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigasi kembali ke halaman sebelumnya (pop)
      Navigator.pop(context);
    } catch (e) {
      print('Error saving URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save URL'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update API Base URL')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter API URL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'Base URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveURL,
              child: Text('Save URL'),
            ),
          ],
        ),
      ),
    );
  }
}

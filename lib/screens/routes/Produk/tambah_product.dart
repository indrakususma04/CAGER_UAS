// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dto/kategori_barang.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/services/data_service.dart';
import 'package:flutter/services.dart'; 

class TambahProdukForm extends StatefulWidget {
  @override
  _TambahProdukFormState createState() => _TambahProdukFormState();
}

class _TambahProdukFormState extends State<TambahProdukForm> {
  final _formKey = GlobalKey<FormState>();

  late List<Kategori> _kategoriList = [];
  int? _selectedKategoriId;
  XFile? _gambar;

  TextEditingController idProdukController = TextEditingController();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    try {
      final kategoriList = await DataService.fetchKategori();
      setState(() {
        _kategoriList = kategoriList;
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  Future<void> _ambilGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _gambar = pickedFile;
      });
    }
  }

  Future<void> _tambahProduk(BuildContext context) async {
    if (_selectedKategoriId == null || _gambar == null) {
      return;
    }

    String idProduk = idProdukController.text.trim();
    String namaProduk = namaProdukController.text.trim();
    double harga = double.tryParse(hargaController.text.trim()) ?? 0.0;
    int stok = int.tryParse(stokController.text.trim()) ?? 0;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Endpoints.Produk),
    );

    request.fields['id_produk'] = idProduk;
    request.fields['id_kategori_produk'] = _selectedKategoriId.toString();
    request.fields['nama_produk'] = namaProduk;
    request.fields['harga'] = harga.toString();
    request.fields['stok'] = stok.toString();
    request.fields['deskripsi'] = '';

    request.files.add(await http.MultipartFile.fromPath(
      'gambar',
      _gambar!.path,
      filename: _gambar!.path.split('/').last,
    ));

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Produk berhasil ditambahkan'),
        ));
        Navigator.pushReplacementNamed(context, '/produk_katalog');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menambahkan produk'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('Gagal menambahkan produk: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menambahkan produk'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: idProdukController,
                  decoration: InputDecoration(
                    labelText: 'ID Produk',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID Produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: namaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: hargaController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: stokController,
                  decoration: InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  value: _selectedKategoriId,
                  items: _kategoriList.map((kategori) {
                    return DropdownMenuItem<int>(
                      value: kategori.idKategori,
                      child:
                          Text('${kategori.idKategori} - ${kategori.namaKategori}'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedKategoriId = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: _ambilGambar,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _gambar != null
                        ? Image.file(
                            File(_gambar!.path),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 60,
                                color: Colors.grey,
                              ),
                              Text(
                                'Pilih Gambar',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _tambahProduk(context);
                    }
                  },
                  child: Text('Tambah Produk'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

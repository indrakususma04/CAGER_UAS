// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/dto/kategori_barang.dart';
import 'package:my_app/services/data_service.dart';

class KategoriListScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const KategoriListScreen({Key? key}) : super(key: key);

  @override
  _KategoriListScreenState createState() => _KategoriListScreenState();
}

class _KategoriListScreenState extends State<KategoriListScreen> {
  late Future<List<Kategori>> _kategoriList;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _kategoriList = DataService.fetchKategori();
  }

  // Fungsi untuk memuat ulang data kategori
  Future<void> _reloadKategori() async {
    setState(() {
      _kategoriList = DataService.fetchKategori();
    });
  }

  // Fungsi untuk menghapus kategori
  Future<void> _hapusKategori(int idKategori) async {
    try {
      await DataService.hapusKategori(idKategori);
      // Memuat ulang data kategori setelah berhasil menghapus
      _reloadKategori();
      // Menampilkan pesan sukses jika kategori berhasil dihapus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kategori berhasil dihapus'),
        ),
      );
    } catch (e) {
      // Menangani kesalahan jika gagal menghapus kategori
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus kategori: $e'),
        ),
      );
    }
  }

  // Fungsi untuk melakukan pencarian dan memfilter daftar kategori
  List<Kategori> _filterKategori(List<Kategori> kategoriList) {
    if (_searchKeyword.isEmpty) {
      return kategoriList;
    } else {
      return kategoriList
          .where((kategori) =>
              kategori.namaKategori.toLowerCase().contains(_searchKeyword.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori List'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Tombol refresh untuk memuat ulang data kategori
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadKategori,
          ),
        ],
        // Search bar sebagai bagian dari AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Kategori>>(
        future: _kategoriList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final List<Kategori> kategoriList = snapshot.data!;
            final filteredKategori = _filterKategori(kategoriList);
            return ListView.builder(
              itemCount: filteredKategori.length,
              itemBuilder: (context, index) {
                final kategori = filteredKategori[index];
                return GestureDetector(
                  onTap: () {
                    _hapusKategori(kategori.idKategori);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          'ID Kategori: ${kategori.idKategori}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Nama Kategori: ${kategori.namaKategori}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _hapusKategori(kategori.idKategori);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        tooltip: 'Tambah',
        onPressed: () {
          Navigator.pushNamed(context, '/kategori_form');
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

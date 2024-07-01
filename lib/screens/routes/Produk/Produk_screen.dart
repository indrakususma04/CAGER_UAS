// ignore_for_file: file_names, use_super_parameters, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/dto/Produk.dart';
import 'package:my_app/screens/routes/Produk/product_detail_screen.dart';
import 'package:my_app/services/data_service.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/cubit/auth/cubit/cart/bloc/cubit/cart_cubit.dart';

class ProductScreen extends StatefulWidget {
  final String category;

  const ProductScreen({Key? key, required this.category}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Produk>> _produkListFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _produkListFuture = _fetchProductsByCategory(widget.category);
  }

  Future<List<Produk>> _fetchProductsByCategory(String category) async {
    try {
      List<Produk> produkList = await DataService.fetchProdukByCategory(category);
      return produkList;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  List<Produk> _filterProducts(List<Produk> produkList, String query) {
    if (query.isEmpty) {
      return produkList;
    }
    return produkList.where((produk) =>
        produk.namaProduk.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PRODUK ${widget.category.toUpperCase()}'),
        backgroundColor: Colors.blue,
        elevation: 10,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search produk...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Produk>>(
              future: _produkListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found.'));
                } else {
                  List<Produk> filteredProducts = _filterProducts(snapshot.data!, _searchController.text);

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      Produk produk = filteredProducts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        child: ListTile(
                          onTap: () {
                            // Navigasi ke layar detail produk
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(produk: produk),
                              ),
                            );
                          },
                          leading: Image.network(
                            '${Endpoints.URLBase}/api${produk.gambarUrl}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image, size: 80);
                            },
                          ),
                          title: Text(produk.namaProduk),
                          subtitle: Text('Harga: Rp. ${produk.harga}/Per 1 hari'),
                          trailing: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.shopping_cart, color: Colors.white),
                              onPressed: () {
                                context.read<CartCubit>().addProduct(produk);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Produk ${produk.namaProduk} ditambahkan ke keranjang.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

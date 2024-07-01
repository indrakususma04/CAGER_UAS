// ignore_for_file: file_names, use_super_parameters, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:my_app/dto/Produk.dart';
import 'package:my_app/services/data_service.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  _AdminProductScreenState createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  late Future<List<Produk>> _produkListFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reloadProducts();
  }

  // Function to fetch all products
  Future<void> _reloadProducts() async {
    try {
      List<Produk> produkList = await DataService.fetchProduk();
      setState(() {
        _produkListFuture = Future.value(produkList);
      });
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Function to filter products based on search query
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
        title: Text('Admin Produk'),
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
                  // Filter the products based on search query
                  List<Produk> filteredProducts = _filterProducts(snapshot.data!, _searchController.text);

                  // Display the list of products using ListView.builder
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      Produk produk = filteredProducts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        child: ListTile(
                          title: Text(produk.namaProduk),
                          subtitle: Text('Harga: Rp. ${produk.harga}/Per 1 hari'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editProduk(produk);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteDialog(produk);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tapping on product (if needed)
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddProduct();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Function to show delete confirmation dialog
  void _confirmDeleteDialog(Produk produk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Produk'),
          content: Text('Are you sure you want to delete ${produk.namaProduk}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduk(produk);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a product
  void _deleteProduk(Produk produk) {
    try {
      DataService.hapusProduk(produk.idProduk);
      _reloadProducts(); // Reload products after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk ${produk.namaProduk} berhasil dihapus.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete produk: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  // Function to navigate to add product screen
  void _navigateToAddProduct() {
    // Navigate to add product screen (replace '/add_product' with your actual route)
    Navigator.pushNamed(context, '/produk_form');
  }
  // Function to navigate to edit product screen
  void _editProduk(Produk produk) {
    // Navigate to edit product screen (replace '/edit_product' with your actual route and pass 'produk' as arguments if needed)
    Navigator.pushNamed(context, '/edit_product', arguments: produk);
  }
}

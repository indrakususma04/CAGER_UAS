import 'package:flutter/material.dart';
import 'package:my_app/models/Product.dart';
import 'package:my_app/helpers/dbhelper.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late DbHelper _dbHelper;
  late List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DbHelper();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    List<Product> products = await _dbHelper.getProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _buildProductList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _navigateToProductForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) {
      return const Center(
        child: Text('Produk Tidak Ada Silahkan Tambahkan !!'),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            Product product = _products[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildProductContainer(product),
            );
          },
        ),
      );
    }
  }

  Widget _buildProductContainer(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(product.nama),
        subtitle: Text('Stock: ${product.stok}, Price: ${product.harga}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _navigateToProductForm(context, product: product);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteProduct(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToProductForm(BuildContext context, {Product? product}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductFormPage(product: product),
    ));
    _refreshProducts();
  }

  Future<void> _deleteProduct(Product product) async {
    await _dbHelper.deleteProduct(product.id);
    _refreshProducts();
  }
}

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.product?.nama ?? '');
    _stokController = TextEditingController(text: widget.product?.stok.toString() ?? '');
    _hargaController = TextEditingController(text: widget.product?.harga.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stokController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product stock';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveProduct();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    String nama = _namaController.text.trim();
    int stok = int.tryParse(_stokController.text.trim()) ?? 0;
    int harga = int.tryParse(_hargaController.text.trim()) ?? 0;

    Product newProduct = Product(0, nama, stok, harga);

    if (widget.product == null) {
      await DbHelper().insertProduct(newProduct);
    } else {
      newProduct.id = widget.product!.id;
      await DbHelper().updateProduct(newProduct);
    }
    Navigator.of(context).pop();
  }
}

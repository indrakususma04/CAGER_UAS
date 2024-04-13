import 'package:flutter/material.dart';
import 'package:my_app/screens/routes/keranjang_Screen.dart';

class TendaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TENDA'),
        backgroundColor: Colors.blue, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, productList[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(product.imageAsset),
          radius: 30, 
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stok: ${product.stock}'),
            Text('Penjual: ${product.seller}'),
            Text('Lokasi: ${product.location}'),
            Text('Harga Sewa: ${product.rentPrice}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman keranjang saat tombol "Sewa" ditekan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KeranjangScreen()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          child: const Text('Sewa'),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final int stock;
  final String seller;
  final String location;
  final double rentPrice;
  final String imageAsset;

  Product({
    required this.name,
    required this.stock,
    required this.seller,
    required this.location,
    required this.rentPrice,
    required this.imageAsset,
  });
}

List<Product> productList = [
  Product(
    name: 'tenda double layer 4 orang merk eiger',
    stock: 10,
    seller: 'indra camp store',
    location: 'denpasar bali',
    rentPrice: 50.000,
    imageAsset: 'assets/images/tendanew.jpeg',
  ),
  Product(
    name: 'Kompor portable + gas ',
    stock: 5,
    seller: 'campgear shop singaraja',
    location: 'singaraja',
    rentPrice: 25.0000,
    imageAsset: 'assets/images/kompor.jpeg',

  ),
  // Daftar produk lainnya
];

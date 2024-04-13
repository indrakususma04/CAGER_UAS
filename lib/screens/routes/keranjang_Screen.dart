import 'package:flutter/material.dart';
import 'package:my_app/screens/routes/Chekout_Screen.dart';

class KeranjangScreen extends StatefulWidget {
  @override
  _KeranjangScreenState createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  List<bool> _isCheckedList = List.generate(4, (index) => false); // Daftar untuk menyimpan status ceklis setiap item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          _buildProductContainer(
            index: 0,
            sellerName: 'Penjual: indra rental shop',
            productName: 'tenda dome 4 orang merk eiger 2 layer',
            productPrice: 'Rp 100.000',
            productImage: 'assets/images/tendanew.jpeg',
          ),
          _buildProductContainer(
            index: 1,
            sellerName: 'Penjual: Seller Cager singaraja',
            productName: 'Kompor portable merk rinnai 1 tungkku',
            productPrice: 'Rp 150.000',
            productImage: 'assets/images/kompor.jpeg',
          ),
          _buildProductContainer(
            index: 2,
            sellerName: 'Penjual: Seller ndrshop camp',
            productName: 'tenda anak anak 2 orang',
            productPrice: 'Rp 150.000',
            productImage: 'assets/images/tenda.jpeg',
          ),
          _buildProductContainer(
            index: 3,
            sellerName: 'Penjual: Seller Cager singaraja',
            productName: 'Kompor portable merk rinnai 1 tungkku',
            productPrice: 'Rp 150.000',
            productImage: 'assets/images/kompor.jpeg',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pesanan: Rp 250.000',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white, // Warna teks biru
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductContainer({
    required int index,
    required String sellerName,
    required String productName,
    required String productPrice,
    required String productImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isCheckedList[index], // Menggunakan nilai ceklis dari daftar
                onChanged: (isChecked) {
                  setState(() {
                    _isCheckedList[index] = isChecked!; // Mengubah status ceklis sesuai dengan tindakan pengguna
                  });
                },
                activeColor: Colors.blue,
              ),
              Text(
                sellerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(productImage),
            ),
            title: Text(productName),
            subtitle: Text('Harga Sewa: $productPrice'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {},
                ),
                const Text('1'), // Jumlah qty produk
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

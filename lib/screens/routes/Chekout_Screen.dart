import 'package:flutter/material.dart';
import 'package:my_app/screens/routes/Payment_succes.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Transfer';
  String _selectedDeliveryOption = 'Ambil di Tempat';
  String _selectedCourier = 'JNE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkout'),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Metode Pembayaran'),
            _buildDropdownButton(_selectedPaymentMethod, (newValue) {
              setState(() {
                _selectedPaymentMethod = newValue!;
              });
            }, ['Transfer', 'COD', 'Shopee Pay']),
            const SizedBox(height: 16),
            _buildSectionTitle('Pilihan Pengambilan'),
            _buildDropdownButton(_selectedDeliveryOption, (newValue) {
              setState(() {
                _selectedDeliveryOption = newValue!;
              });
            }, ['Ambil di Tempat', 'Diantar']),
            const SizedBox(height: 16),
            _buildSectionTitle('Pilihan Kurir'),
            _buildDropdownButton(_selectedCourier, (newValue) {
              setState(() {
                _selectedCourier = newValue!;
              });
            }, ['JNE', 'J&T', 'POS Indonesia']),
            const SizedBox(height: 32),
            const SizedBox(height: 4),
            const Text(
              'Total Pesanan: Rp 250.000',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke layar PaymentSuccessScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Bayar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  Widget _buildDropdownButton(String value, ValueChanged<String?> onChanged, List<String> items) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 36,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
    );
  }
}

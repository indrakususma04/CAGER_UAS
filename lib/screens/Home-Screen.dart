// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/screens/Profile-Screen.dart';
import 'package:my_app/screens/routes/Produk/Produk_screen.dart';
import 'package:my_app/screens/routes/admin/Booking.dart';
import 'package:my_app/screens/routes/notification_screen.dart';
import 'package:my_app/screens/routes/keranjang_screen.dart';
import 'package:my_app/screens/routes/about_us/about_us.dart';
import 'package:my_app/widgets/top_section';
import 'package:my_app/widgets/category_section';
import 'package:my_app/services/data_service.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KeranjangScreen()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          break;
      }
    });
  }

  void _performSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductScreen(category: ''),
      ),
    );
  }

  void _navigateToProductCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(category: category),
      ),
    );
  }

  Future<void> _logout() async {
    final response = await DataService.logoutData();

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      context.read<AuthCubit>().Logout();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/login-screen');
    } else {
      // Handle logout error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.trolley, color: Colors.blueAccent),
              title: const Text('Status Pesanan'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookingsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.blueAccent),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop(); 
                _logout();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopSection(),
            Expanded(
              child: Column(
                children: [
                  CategorySection(
                    titles: const ['TENDA', 'ALAT MASAK', 'ALAT TIDUR', 'OTHER'],
                    // ignore: prefer_const_literals_to_create_immutables
                    icons: [
                      Icons.home,
                      Icons.fire_extinguisher,
                      Icons.bed,
                      Icons.devices_other
                    ],
                    onSelectionChanged: (index) {
                      switch (index) {
                        case 0:
                          _navigateToProductCategory('TENDA');
                          break;
                        case 1:
                          _navigateToProductCategory('ALAT MASAK');
                          break;
                        case 2:
                          _navigateToProductCategory('ALAT TIDUR');
                          break;
                        case 3:
                          _navigateToProductCategory('OTHER');
                          break;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

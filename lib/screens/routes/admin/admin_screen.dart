import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/screens/Profile-Screen.dart'; 
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/services/data_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  Future<void> _logout() async {
    try {
      final response = await DataService.logoutData();

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        context.read<AuthCubit>().Logout(); // Adjust according to your AuthCubit
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/login-screen');
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error during logout: $e');
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
        automaticallyImplyLeading: false, // Remove back arrow
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white, // Change text color to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Set app bar color to blue
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            // Navigate to Profile screen when Profile tab is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        backgroundColor: Colors.white, // Background color
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return _buildDashboard();
      case 1:
        return Container(); // Placeholder for Profile screen
      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildCard('Manajemen Produk', Icons.settings, '/Produk-man'),
        _buildCard('Daftar Peminjaman', Icons.check, '/rental-screen'),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, String routeName) {
    return Container(
      width: double.infinity, // Make the card fill the width
      height: 150.0, // Adjust height as needed
      margin: const EdgeInsets.only(bottom: 10.0), // Space between cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Define what happens when the card is tapped
            Navigator.pushNamed(context, routeName);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

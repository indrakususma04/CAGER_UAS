import 'package:flutter/material.dart';
import 'package:my_app/screens/routes/add_Product.dart';
import 'package:my_app/screens/profile-screen.dart';
import 'package:my_app/screens/routes/keranjang_Screen.dart';
import 'package:my_app/screens/routes/news_screen.dart';
import 'package:my_app/widgets/top_section';
import 'package:my_app/screens/routes/notification_Screen.dart';
import 'package:my_app/widgets/Carousel';
import 'package:my_app/widgets/category_section';
import 'package:my_app/screens/routes/Tenda_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KeranjangScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('user'),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.jpeg'), 
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(' Latihan|Crud Sqlite'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.router),
              title: const Text('latihan|API'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.room_service),
              title: const Text('Help'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Bukalapak'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_center),
              title: const Text('aboutus'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewsScreen(),
                ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
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
                    titles: ['TENDA', 'ALAT MASAK', 'ALAT TIDUR','GUIDE'],
                    icons: [Icons.home, Icons.fire_extinguisher, Icons.bed,Icons.person],
                    onSelectionChanged: (index) {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TendaScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50), 
            CarouselContainer(),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}

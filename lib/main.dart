import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/auth_wrapper.dart';
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/cubit/auth/cubit/cart/bloc/cubit/cart_cubit.dart'; 
import 'package:my_app/screens/Home-Screen.dart';
import 'package:my_app/screens/Profile-Screen.dart';
import 'package:my_app/screens/login-Screen.dart';
import 'package:my_app/screens/routes/Produk/Manproduk_screen.dart';
import 'package:my_app/screens/routes/Produk/ProdukAdmin_screen.dart';
import 'package:my_app/screens/routes/Produk/kategori_screen.dart';
import 'package:my_app/screens/routes/Splash_screen.dart';
import 'package:my_app/screens/routes/admin/admin_screen.dart';
import 'package:my_app/screens/routes/admin/daftar_peminjaman.dart';
import 'package:my_app/screens/routes/produk/tambah_kategori.dart';
import 'package:my_app/screens/routes/produk/tambah_product.dart';
import 'package:my_app/screens/routes/urlform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<CartCubit>(
          create: (context) {
            final authState = BlocProvider.of<AuthCubit>(context).state;
            return authState.isLoggedIn
                ? CartCubit(authState.userId)
                : CartCubit(''); 
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Splash(),
        routes: {
          '/login-screen': (context) => const LoginPage(),
          '/Produk-man': (context) => const manproduk(),
          '/admin-Screen': (context) => const AdminScreen(),
          '/Home-Screen': (context) => const AuthWrapper(child: HomeScreen()),
          '/kategori_form': (context) => KategoriForm(),
          '/produk_form': (context) => TambahProdukForm(),
          '/Kategori-screen': (context) => const KategoriListScreen(),
          '/produk_katalog': (context) => const AdminProductScreen(),
          '/profile-screen':  (context) => const ProfileScreen(),
          '/rental-screen':  (context) =>  RentalScreen(),
           '/url-form':  (context) =>  URLForm(),
        },
      ),
    );
  }
}

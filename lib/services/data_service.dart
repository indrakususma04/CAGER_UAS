// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/dto/Produk.dart';
import 'package:my_app/dto/Rental.dart';
import 'package:my_app/dto/kategori_barang.dart';
import 'package:my_app/dto/userprofile.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class DataService {
  // Fetch all categories
  static Future<List<Kategori>> fetchKategori() async {
    final response = await http.get(Uri.parse(Endpoints.Kategori));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((item) => Kategori.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load kategori');
    }
  }

  // Add a new category
  static Future<void> tambahKategori(String id, String nama, String deskripsi) async {
    final response = await http.post(
      Uri.parse(Endpoints.Kategori),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_kategori_produk': id,
        'nama_kategori': nama,
        'deskripsi_kategori': deskripsi,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add kategori');
    }
  }

  // Delete a category by ID
  static Future<void> hapusKategori(int idKategori) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.Kategori}/$idKategori'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete kategori');
    }
  }

  // Fetch all products with pagination
  static Future<List<Produk>> fetchProduk({int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse('${Endpoints.Produk}?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body)['products'];
      return list.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load produk');
    }
  }

  // Fetch products by category with pagination
  static Future<List<Produk>> fetchProdukByCategory(String category, {int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse('${Endpoints.Produk}/kategori/$category?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body)['products'];
      return list.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load produk by category');
    }
  }

  // Add a new product
  static Future<void> tambahProduk(String idProduk, String idKategori, String namaProduk, double harga, int stok, String deskripsi, String gambarUrl) async {
    final response = await http.post(
      Uri.parse(Endpoints.Produk),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_produk': idProduk,
        'id_kategori_produk': idKategori,
        'nama_produk': namaProduk,
        'harga': harga,
        'stok': stok,
        'deskripsi': deskripsi,
        'gambar_url': gambarUrl,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add produk');
    }
  }

  // Delete a product by ID
  static Future<void> hapusProduk(int idProduk) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.Produk}/$idProduk'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete produk');
    }
  }

  // Post login with email and password
  static Future<http.Response> sendLoginData(String username, String password) async {
    final url = Uri.parse(Endpoints.Login);
    final data = {'username': username, 'password': password};
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  // Register user
  static Future<http.Response> sendRegistrationData(String username, String password, String email) async {
    final url = Uri.parse(Endpoints.Register);
    final data = {'username': username, 'password': password, 'email': email};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      print('Error sending registration request: $e');
      rethrow;
    }
  }

  // Logout user
  static Future<http.Response> logoutData() async {
    final url = Uri.parse(Endpoints.Logout);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response;
  }

  // Fetch user profile
  static Future<UserProfile> fetchUserProfile() async {
    final url = Uri.parse(Endpoints.Profile);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  // Update user profile
  static Future<void> updateProfile(String email, String nohp) async {
    final url = Uri.parse(Endpoints.UpdateProfile);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final data = {
      'email': email,
      'no_hp': nohp,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
  
  // Add a new rental
  static Future<void> addRental(String idProduk, String tanggalMulai, String tanggalSelesai, String status, double totalHarga) async {
    final url = Uri.parse(Endpoints.Rental);
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final data = {
      'id_produk': idProduk,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'status': status,
      'total_harga': totalHarga,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add rental');
    }
  }

  static Future<List<Rental>> fetchRentals() async {
    final String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.get(
      Uri.parse(Endpoints.Rent),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body);
      return jsonList.map((model) => Rental.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load rentals');
    }
  }
static Future<void> updateRentalStatus(int idRental, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(Endpoints.Rent),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update rental status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 Future<List<dynamic>> fetchBookings() async {
  String? accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);
  if (accessToken == null) {
    throw Exception('Access token is missing');
  }

  final response = await http.get(
    Uri.parse(Endpoints.Booking),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> bookings = jsonDecode(response.body);
    return bookings;
  } else {
    throw Exception('Failed to load bookings');
  }
}
}



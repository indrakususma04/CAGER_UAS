import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_app/models/Product.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  // Konstruktor pribadi untuk mengontrol pembuatan objek
  DbHelper._createObject();

  // Factory constructor untuk mendapatkan instance tunggal DbHelper
  factory DbHelper() {
    _dbHelper ??= DbHelper._createObject();
    return _dbHelper!;
  }

  // Metode untuk mengakses atau membuat database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Metode untuk inisialisasi database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(documentsDirectory.path, 'Cager.db');
    return await openDatabase(dbPath, version: 1, onCreate: _createDb);
  }

  // Metode untuk membuat tabel produk jika tidak ada
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        stok INTEGER,
        harga INTEGER
      )
    ''');
  }

  // Metode untuk menambahkan produk ke database
  Future<int> insertProduct(Product product) async {
    final db = await database;
    // Memeriksa apakah produk sudah ada berdasarkan nama
    final List<Map<String, dynamic>> existingProduct = await db.query(
      'products',
      where: 'nama = ?',
      whereArgs: [product.nama],
    );
    if (existingProduct.isNotEmpty) {
      throw Exception('Product with name "${product.nama}" already exists.');
    }

    // Menetapkan ID produk secara manual
    int nextId = await _getNextProductId(db);

    // Memasukkan produk dengan ID yang ditetapkan secara manual
    product.id = nextId;
    return await db.insert('products', product.toMap());
  }

  // Metode untuk mendapatkan ID berikutnya untuk produk
  Future<int> _getNextProductId(Database db) async {
    // Mendapatkan ID terbesar dari produk yang sudah ada di database
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT MAX(id) AS max_id FROM products
    ''');
    int maxId = (result.first['max_id'] ?? 0) as int;
    return maxId + 1;
  }

  // Metode untuk mendapatkan semua produk dari database
  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Metode untuk memperbarui produk di database
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Metode untuk menghapus produk dari database
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

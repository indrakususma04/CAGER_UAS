import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:my_app/dto/Produk.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cartcager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS keranjang(id_produk INTEGER PRIMARY KEY, id_kategori_produk INTEGER, nama_produk TEXT, harga TEXT, stok INTEGER, deskripsi TEXT, gambar_url TEXT, quantity INTEGER, userId TEXT)',
    );
  }

  Future<void> insertProduct(Produk produk, String userId) async {
    final db = await database;
    await db.insert(
      'keranjang',
      {...produk.toJson(), 'userId': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Produk>> getProducts(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'keranjang',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Produk.fromJson(maps[i]);
    });
  }

  Future<void> deleteProduct(int idProduk, String userId) async {
    final db = await database;
    await db.delete(
      'keranjang',
      where: 'id_produk = ? AND userId = ?',
      whereArgs: [idProduk, userId],
    );
  }

  Future<void> clearCart(String userId) async {
    final db = await database;
    await db.delete(
      'keranjang',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}

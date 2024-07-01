
// ignore_for_file: file_names, duplicate_ignore

class Produk {
  final int idProduk;
  final int idKategoriProduk;
  final String namaProduk;
  final String harga;
  final int stok;
  final String deskripsi;
  final String gambarUrl;
  int quantity;

  Produk({
    required this.idProduk,
    required this.idKategoriProduk,
    required this.namaProduk,
    required this.harga,
    required this.stok,
    required this.deskripsi,
    required this.gambarUrl,
    this.quantity = 0,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      idProduk: json['id_produk'],
      idKategoriProduk: json['id_kategori_produk'],
      namaProduk: json['nama_produk'],
      harga: json['harga'],
      stok: json['stok'],
      deskripsi: json['deskripsi'],
      gambarUrl: json['gambar_url'],
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produk': idProduk,
      'id_kategori_produk': idKategoriProduk,
      'nama_produk': namaProduk,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
      'gambar_url': gambarUrl,
      'quantity': quantity,
    };
  }
}

// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

class Rental{
  final double harga;
  final int idProduk;
  final int idUser;
  final String namaProduk;
  final String status;
  final String tanggalMulai;
  final String tanggalSelesai;
  final double totalHarga;
  final String username;

  Rental({
    required this.harga,
    required this.idProduk,
    required this.idUser,
    required this.namaProduk,
    required this.status,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.totalHarga,
    required this.username,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      harga: double.parse(json['harga']),
      idProduk: json['id_produk'],
      idUser: json['id_user'],
      namaProduk: json['nama_produk'],
      status: json['status'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      totalHarga: double.parse(json['total_harga']),
      username: json['username'],
    );
  }
}

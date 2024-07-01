class Kategori {
  int idKategori;
  String namaKategori;
  String deskripsiKategori;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
    required this.deskripsiKategori,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
  return Kategori(
    idKategori: json['id_kategori'] as int,
    namaKategori: json['nama_kategori'] as String,
    deskripsiKategori: json['deskripsi_kategori'] as String,
  );
}

}
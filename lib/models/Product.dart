

 class Product {
  int _id;
  String _nama;
  int _stok;
  int _harga;

  // ignore: empty_constructor_bodies
  Product(this._id, this._nama, this._stok, this._harga) {
  }

  Product.fromMap(Map<String, dynamic> map)
      : _id = map['id'] ?? 0,
        _nama = map['nama'] ?? '',
        _stok = map['stok'] ?? 0,
        _harga = map['harga'] ?? 0;

  // ignore: unnecessary_getters_setters
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  // ignore: unnecessary_getters_setters
  String get nama => _nama;
  set nama(String value) {
    _nama = value;
  }

  int get stok => _stok;
  set stok(int value) {
    _stok = value;
  }

  int get harga => _harga;
  set harga(int value) {
    _harga = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nama': _nama,
      'stok': _stok,
      'harga': _harga,
    };
  }
}
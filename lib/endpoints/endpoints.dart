// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:my_app/utils/secure_storage_util.dart';

class Endpoints {
  static String get URLBase => SecureStorageUtil.urlBase;

  static String get Kategori => "$URLBase/api/kategori";
  static String get Produk => "$URLBase/api/produk";
  static String get Profile => "$URLBase/api/profile";
  static String get UpdateProfile => "$URLBase/profile/update";
  // ignore: non_constant_identifier_names
  static String get Rental => "$URLBase/api/sewa";
  static String get Booking => "$URLBase/api/booking";
  static String get Rent => "$URLBase/api/rental";
  static String get Login => "$URLBase/api/login";
  static String get Register => "$URLBase/api/register";
  static String get Logout => "$URLBase/api/logout";
}

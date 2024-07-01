// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static final storage = FlutterSecureStorage();

  static final String defaultURLBase = "http://192.168.1.7:5000";
  static String _urlBase = defaultURLBase;

  static void init() async {
    // Example: Read URL base from secure storage on app startup
    String? savedUrl = await storage.read(key: 'base_url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _urlBase = savedUrl;
    } else {
      _urlBase = defaultURLBase;
    }
  }

  static String get urlBase => _urlBase;

  static Future<void> writeBaseUrl(String url) async {
    _urlBase = url;
    await storage.write(key: 'base_url', value: url);
  }
}

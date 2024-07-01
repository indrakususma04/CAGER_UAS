// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:my_app/endpoints/endpoints.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendRegistration(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    try {
      final response = await DataService.sendRegistrationData(username, password, email);
      if (response.statusCode == 201) {
        debugPrint("Registration successful");
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/login-screen');
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration successful, please login"),
          duration: Duration(seconds: 3),
        ));
      } else {
        debugPrint("Registration failed with status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration failed"),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      debugPrint("Error during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred during registration"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue, // Warna latar belakang app bar
      ),
      backgroundColor: Colors.blue, // Warna latar belakang halaman
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white), // Warna teks input
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white), // Warna label
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white), // Warna teks input
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white), // Warna label
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white), // Warna teks input
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white), // Warna label
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  sendRegistration(context);
                },
                // ignore: sort_child_properties_last
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Warna tombol
                  disabledBackgroundColor: Colors.blue, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class DataService {
  static Future<http.Response> sendRegistrationData(String username, String password, String email) async {
    final url = Uri.parse(Endpoints.Register); 
    final data = {
      'username': username,
      'password': password,
      'email': email,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Error sending registration request: $e');
      rethrow;
    }
  }
}

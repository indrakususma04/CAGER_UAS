// ignore_for_file: use_build_context_synchronously, file_names, use_super_parameters, library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/dto/login.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/Register_screen.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> sendLogin(BuildContext context, AuthCubit authCubit) async {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await sendLoginData(username, password);
      if (response.statusCode == 200) {
        debugPrint("Login successful");
        final data = jsonDecode(response.body);
        final loggedIn = Login.fromJson(data);
        await SecureStorageUtil.storage.write(key: tokenStoreName, value: loggedIn.accessToken);
        authCubit.Login(loggedIn.accessToken, loggedIn.role);

        if (loggedIn.role.toLowerCase() == 'admin') {
          Navigator.pushNamed(context, '/admin-Screen');
        } else {
          Navigator.pushNamed(context, '/Home-Screen');
        }
      } else {
        debugPrint("Login failed with status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login failed"),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      debugPrint("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred during login"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  static Future<http.Response> sendLoginData(String username, String password) async {
    final url = Uri.parse(Endpoints.Login); // Adjusted endpoint naming convention
    final data = {'username': username, 'password': password};
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    sendLogin(context, authCubit);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()), // Navigasi ke RegisterPage
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Atau ubah URL base API ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/url-form'); // Ganti '/url-form' sesuai dengan rute yang Anda gunakan
                      },
                      child: const Icon(
                        Icons.link,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

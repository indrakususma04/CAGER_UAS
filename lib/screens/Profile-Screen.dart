// ignore_for_file: file_names, library_prefixes, use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/services/data_service.dart' as DataService;
import 'package:my_app/dto/userprofile.dart' as UserProfile;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile.UserProfile? _userProfile;
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }
  Future<void> _fetchUserProfile() async {
    try {
      UserProfile.UserProfile userProfile = await DataService.DataService.fetchUserProfile();
      setState(() {
        _userProfile = userProfile;
      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        elevation: 8,
      ),
      backgroundColor: Colors.blue[50], // Warna latar belakang
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: const Icon(
                          Icons.account_circle,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileInfo('Nama', _userProfile!.username), 
                      _buildProfileInfo('No. HP', _userProfile!.phoneNumber),
                      _buildProfileInfo('Email', _userProfile!.email),
                       _buildProfileInfo('Role', _userProfile!.role),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          elevation: 5,
                        ),
                        child: const Text('Logout', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProfileInfo(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

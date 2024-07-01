class UserProfile {
  final String username;
  final String email;
  final String phoneNumber;
  final String role;

  UserProfile({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '', 
      email: json['email'] ?? '', 
      phoneNumber: json['no_hp'] ?? '', 
      role: json['role'] ?? '', 
    );
  }
}

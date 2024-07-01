// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

class Login {
  final String accessToken;
  final String tokenType;
  final String role;
  final int userId; 

  Login({
    required this.accessToken,
    required this.tokenType,
    required this.role,
    required this.userId, 
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['access_token'],
      tokenType: json['type'],
      role: json['role'],
      userId: json['user_id'], 
    );
  }
}

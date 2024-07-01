import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final String accessToken;
  final String role;
  final String userId;

  const AuthState({
    required this.isLoggedIn,
    required this.accessToken,
    required this.role,
    required this.userId,
  });
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super(
    isLoggedIn: true,
    accessToken: "",
    role: '',
    userId: '',
  );
}

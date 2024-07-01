// ignore_for_file: non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitialState());

  void Login(String accessToken, String role) {
    emit(AuthState(isLoggedIn: true, accessToken: accessToken, role: role, userId: ''));
  }
  
  void Logout(){
    emit(const AuthState(isLoggedIn: false, accessToken: "",role: '', userId: ''));
  }
}

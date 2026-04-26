import 'package:flutter/material.dart';
import '../../domain/login_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider({required this.loginUseCase});

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await loginUseCase.call(email, password);
      _isLoading = false;
      notifyListeners();
      return true; 
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
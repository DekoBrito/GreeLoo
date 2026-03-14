import 'package:flutter/material.dart';
import 'database_helper.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _dbHelper.login(username, password);
      
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Usuário ou senha inválidos';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Verificar se usuário já existe
      final exists = await _dbHelper.userExists(username, email);
      
      if (exists) {
        _errorMessage = 'Usuário ou email já cadastrado';
        _setLoading(false);
        return false;
      }
      
      final userData = {
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'avatar': 'default_avatar.png',
      };
      
      final userId = await _dbHelper.register(userData);
      
      if (userId != null) {
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Erro ao criar conta';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao registrar: $e';
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
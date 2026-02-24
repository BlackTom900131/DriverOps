import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool isAuthenticated = false;
  String? userId;
  String? token;
  bool isLoading = false;
  String? error;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    error = message;
    notifyListeners();
  }

  void login({required String userId, required String token}) {
    this.userId = userId;
    this.token = token;
    isAuthenticated = true;
    error = null;
    notifyListeners();
  }

  void logout() {
    userId = null;
    token = null;
    isAuthenticated = false;
    error = null;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    'isAuthenticated': isAuthenticated,
    'userId': userId,
    'token': token,
    'isLoading': isLoading,
    'error': error,
  };

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState()
      ..isAuthenticated = json['isAuthenticated'] as bool? ?? false
      ..userId = json['userId'] as String?
      ..token = json['token'] as String?
      ..isLoading = json['isLoading'] as bool? ?? false
      ..error = json['error'] as String?;
  }
}

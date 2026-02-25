import 'package:flutter/foundation.dart';
import 'package:teacher_tracker/core/services/firebase_auth_service.dart';
import 'package:teacher_tracker/features/auth/models/auth_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  AuthModel? _user;
  AuthModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  AuthViewModel() {
    _authService.user.listen((userModel) {
      _user = userModel;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.signUp(email, password);
    if (result == null) _error = "Login Failed";
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.signIn(email, password);
    if (result == null) _error = "Create user failed";
    _isLoading = false;
    notifyListeners();
  }

  Future<void> forgetPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await _authService.forgetPassword(email);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

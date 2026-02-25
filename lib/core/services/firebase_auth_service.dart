import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:teacher_tracker/core/services/firebase_services.dart';
import 'package:teacher_tracker/features/auth/models/auth_model.dart';

class FirebaseAuthService {
  final _auth = FirebaseServices.auth;

  AuthModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return AuthModel(email: user.email!, uid: user.uid);
  }

  Future<AuthModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromFirebase(result.user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<AuthModel?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromFirebase(result.user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Stream<AuthModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<void> forgetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

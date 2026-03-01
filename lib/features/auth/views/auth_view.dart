import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/core/services/firebase_user_login_db.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_dashboard_view.dart';
import 'package:teacher_tracker/features/dashboard/teachers/teachers_dashboard_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    if (authVM.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (authVM.error.toString().isNotEmpty) debugPrint(authVM.error.toString());

    if (authVM.user != null) {
      return FutureBuilder(
        future: FirebaseUserLoginDb().getUserDetail(authVM.user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final role = snapshot.data!.role;

          if (role == 'admin') {
            return AdminDashboardView();
          }
          if (role == 'teacher') {
            return AdminDashboardView();
          }
          return Scaffold(body: Center(child: Text('No role exist')));
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    authVM.signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    final userData = authVM.user;
                    if (userData == null) {
                      return;
                    } else {
                      final userRole = await FirebaseUserLoginDb()
                          .getUserDetail(userData.uid);
                      if (!context.mounted) {
                        return;
                      }
                      if (userRole?.role.toString() == 'admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminDashboardView(),
                          ),
                        );
                      }
                      if (userRole?.role.toString() == 'teacher') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeachersDashboardView(),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to sign-up or forgot password
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

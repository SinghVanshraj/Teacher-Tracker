import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/auth/views/auth_view.dart';
import 'package:teacher_tracker/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthView());
  }
}

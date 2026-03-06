import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_dashboard_view.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_map_view.dart';

class AdminRootScreen extends StatefulWidget {
  const AdminRootScreen({super.key});

  @override
  State<AdminRootScreen> createState() => _AdminRootScreen();
}

class _AdminRootScreen extends State<AdminRootScreen> {
  final List<Widget> _pages = [AdminDashboardView(),AdminMapView()];
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (value) => setState(() {
          _currentPage = value;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
        ],
      ),
    );
  }
}

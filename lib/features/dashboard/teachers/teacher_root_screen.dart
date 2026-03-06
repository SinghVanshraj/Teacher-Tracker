import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/dashboard/teachers/teacher_map_view.dart';
import 'package:teacher_tracker/features/dashboard/teachers/teachers_dashboard_view.dart';

class TeacherRootScreen extends StatefulWidget {
  const TeacherRootScreen({super.key});

  @override
  State<TeacherRootScreen> createState() => _TeacherRootScreenState();
}

class _TeacherRootScreenState extends State<TeacherRootScreen> {

  final List<Widget> _pages = [TeachersDashboardView(),TeacherMapView()];
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
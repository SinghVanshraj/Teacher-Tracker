import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/teacher/viewmodels/teacher_viewmodel.dart';

class TeachersDashboardView extends StatefulWidget {
  const TeachersDashboardView({super.key});

  @override
  State<TeachersDashboardView> createState() => _TeachersDashboardViewState();
}

class _TeachersDashboardViewState extends State<TeachersDashboardView> {
  bool trackingActive = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final uid = context.read<AuthViewModel>().user!.uid;
      debugPrint("get $uid");
      context.read<TeacherViewmodel>().fetchTeacher(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _teacherVM = context.watch<TeacherViewmodel>();
    final String name = _teacherVM.teacher?.name ?? "Teacher";
    final String email = _teacherVM.teacher?.email ?? "Unknown";
    if (_teacherVM.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_teacherVM.error != null) {
      return Center(child: Text(_teacherVM.error.toString()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Good Morning 👋",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 5),

            Text(
              name.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(radius: 25, child: Icon(Icons.person)),
                title: Text("Teacher ID: $email"),
                subtitle: Text("ABC Public School"),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: trackingActive ? Colors.green.shade50 : Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.gps_fixed,
                  color: trackingActive ? Colors.green : Colors.red,
                ),
                title: const Text("Tracking Status"),
                subtitle: Text(
                  trackingActive ? "Active (Controlled by Admin)" : "Inactive",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "Current Location",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Text("Latitude : 26.8467"),
                    Text("Longitude : 80.9462"),

                    SizedBox(height: 8),

                    Text(
                      "Last Updated : 10:45 AM",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Tracking Information"),
                subtitle: Text(
                  "Location tracking is controlled by the admin. "
                  "Please keep location services enabled.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/core/widgets/stats_card.dart';
import 'package:teacher_tracker/core/widgets/teacher_list_item.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/auth/views/sigup.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_view_model.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return null;
      context.read<AdminViewModel>().fetchTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authVM = context.watch<AuthViewModel>();
    final _teachersList = context.watch<AdminViewModel>();
    final int? numberOfTeacher = _teachersList.teachers?.docs.length;
    final listOfTeachers = _teachersList.teachers?.docs.toList();
    if (_teachersList.isLoading) {
      return Center(child: const CircularProgressIndicator.adaptive());
    }
    if (_teachersList.error != null) {
      return Center(child: Text(_teachersList.error.toString()));
    }
    final stats = [
      {
        "title": "Total Teachers",
        "value": numberOfTeacher.toString(),
        "color": Colors.blue,
      },
      {"title": "Active Classes", "value": "12", "color": Colors.green},
      {"title": "Pending Tasks", "value": "5", "color": Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person_add_alt_1_rounded),
              title: Text('Create New User'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await _authVM.signOut();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stats.length,
                separatorBuilder: (a, b) => SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final stat = stats[index];
                  return StatsCard(
                    title: stat["title"]! as String,
                    value: stat["value"]! as String,
                    color: stat["color"] as Color,
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Teachers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: listOfTeachers?.length ?? 0,
                separatorBuilder: (a, b) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final teacher = listOfTeachers![index].data() as Map<String,dynamic>;
                  return TeacherListItem(
                    name: teacher['name'] ?? '',
                    subject: teacher['department'] ?? '',
                    status: 'online',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

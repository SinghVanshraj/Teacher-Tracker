import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/core/widgets/stats_card.dart';
import 'package:teacher_tracker/core/widgets/teacher_list_item.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/auth/views/sigup.dart';

class AdminDashboardView extends StatefulWidget {
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  Widget build(BuildContext context) {
    final _authVM = context.watch<AuthViewModel>();
    final stats = [
      {"title": "Total Teachers", "value": "25", "color": Colors.blue},
      {"title": "Active Classes", "value": "12", "color": Colors.green},
      {"title": "Pending Tasks", "value": "5", "color": Colors.orange},
    ];

    final teachers = [
      {"name": "John Doe", "subject": "Math", "status": "Online"},
      {"name": "Alice Smith", "subject": "Physics", "status": "Offline"},
      {"name": "Robert Lee", "subject": "Chemistry", "status": "Online"},
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
            // Stats cards
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stats.length,
                separatorBuilder: (_, __) => SizedBox(width: 16),
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

            // Teachers list
            Text(
              "Teachers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: teachers.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final teacher = teachers[index];
                  return TeacherListItem(
                    name: teacher["name"]!,
                    subject: teacher["subject"]!,
                    status: teacher["status"]!,
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

import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/widgets/stats_card.dart';
import 'package:teacher_tracker/core/widgets/teacher_list_item.dart';
class AdminDashboardView extends StatefulWidget {
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  Widget build(BuildContext context) {
    // Sample data for UI only
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
            Text("Teachers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
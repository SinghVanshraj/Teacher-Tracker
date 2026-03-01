import 'package:flutter/material.dart';

class TeacherListItem extends StatelessWidget {
  final String name;
  final String subject;
  final String status;

  const TeacherListItem({
    super.key,
    required this.name,
    required this.subject,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == "Online" ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subject),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(status, style: TextStyle(color: statusColor)),
        ),
      ),
    );
  }
}
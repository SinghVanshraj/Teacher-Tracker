import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_view_model.dart';
import 'package:teacher_tracker/features/institute/viewmodels/institute_view_model.dart';
import 'package:teacher_tracker/features/teacher/viewmodels/teacher_viewmodel.dart';

class AdminMapView extends StatefulWidget {
  const AdminMapView({super.key});

  @override
  State<AdminMapView> createState() => _AdminMapViewState();
}

class _AdminMapViewState extends State<AdminMapView> {
  @override
  void initState() {
    super.initState();
    // Safe: read does not subscribe
    Future.microtask(() {
      context.read<AdminViewModel>().fetchTeachers();
      context.read<InstituteViewModel>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _teacherVM = context.watch<TeacherViewmodel>();
    final _adminVM = context.watch<AdminViewModel>();
    final _institueVM = context.watch<InstituteViewModel>();
    final listOfTeachers = _adminVM.teachers?.docs.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Tracker")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(28.4629, 77.4901),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.teacher_tracker',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(28.4629, 77.4901),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Mr. John Doe - On the way to school"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

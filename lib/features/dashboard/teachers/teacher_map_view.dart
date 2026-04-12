import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/core/services/firebase_teachers_database.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/institute/viewmodels/institute_view_model.dart';
import 'package:teacher_tracker/features/location/viewmodels/location_viewmodel.dart';
import 'package:teacher_tracker/features/teacher/viewmodels/teacher_viewmodel.dart';

class TeacherMapView extends StatefulWidget {
  const TeacherMapView({super.key});

  @override
  State<TeacherMapView> createState() => _TeacherMapViewState();
}

class _TeacherMapViewState extends State<TeacherMapView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final uid = context.read<AuthViewModel>().user!.uid;
      final _teacher = context.read<TeacherViewmodel>();
      final institue = context.read<InstituteViewModel>();
      final locationVM = context.read<LocationViewmodel>();
      final service = FirebaseTeachersDatabase();

      locationVM.startTracking(service.getTeacherLocation());

      await _teacher.teacher?.instituteId;
      final iId = _teacher.teacher?.instituteId;
      if (iId != null) {
        await institue.getInstitute(iId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authVM = context.watch<AuthViewModel>();
    final _teacherVM = context.watch<TeacherViewmodel>();
    final _institueVM = context.watch<InstituteViewModel>();
    final _locationVM = context.watch<LocationViewmodel>();
    final String name = _teacherVM.teacher?.name ?? "Teacher";
    final String email = _teacherVM.teacher?.email ?? "Unknown";

    if (_teacherVM.isLoading || _institueVM.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_teacherVM.error != null) {
      return Center(child: Text(_teacherVM.error.toString()));
    }

    Geofence? geoInstitute;
    LatLng? geoLatLng;
    double? radius;
    final institute = _institueVM.instituteModel;
    if (institute != null) {

      geoLatLng = LatLng(
        institute.geoPoint.latitude,
        institute.geoPoint.longitude,
      );
      radius = institute.radius;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Tracker")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: geoLatLng ?? LatLng(28.4743879, 77.5039906),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.teacher_tracker',
              ),
              if (geoLatLng != null && radius != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: geoLatLng,
                      radius: radius,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      _locationVM.currentLocation?.latitude ?? 0,
                      _locationVM.currentLocation?.longitude ?? 0,
                    ),
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

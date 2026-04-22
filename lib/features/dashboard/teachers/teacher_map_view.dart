import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/core/services/firebase_teachers_database.dart';
import 'package:teacher_tracker/core/services/geofenceing_service.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/institute/viewmodels/institute_view_model.dart';
import 'package:teacher_tracker/features/livelocation/live_location_view_model.dart';
import 'package:teacher_tracker/features/location/viewmodels/location_viewmodel.dart';
import 'package:teacher_tracker/features/teacher/viewmodels/teacher_viewmodel.dart';

// ⚠️ Replace with your PC's local IP when running server.dart
const String kServerUrl = 'ws://192.168.1.5:8080';

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
      final teacher = context.read<TeacherViewmodel>();
      final institute = context.read<InstituteViewModel>();
      final locationVM = context.read<LocationViewmodel>();
      final liveLocationVM = context.read<LiveLocationViewModel>();
      final service = FirebaseTeachersDatabase();

      locationVM.startTracking(service.getTeacherLocation());

      await teacher.fetchTeacher(uid);

      final iId = teacher.teacher?.instituteId;
      if (iId != null) {
        await institute.getInstitute(iId);

        await GeofenceingService().createGeofence(
          instituteName: institute.instituteModel!.name,
          instituteLocation: institute.instituteModel!.geoPoint,
          instituteRadius: institute.instituteModel!.radius,
        );
      }

      // ✅ Connect to WebSocket server
      liveLocationVM.connect(
        url: kServerUrl,
        uid: uid,
        role: 'teacher',
      );

      // ✅ Start sending location every 5 seconds
      liveLocationVM.startSendingLocation(
        lat: locationVM.currentLocation?.latitude ?? 0,
        long: locationVM.currentLocation?.longitude ?? 0,
        name: teacher.teacher?.name ?? '',
        email: teacher.teacher?.email ?? '',
        department: teacher.teacher?.department ?? '',
        geofenceStatus: 'outside', // default, updated by geofence trigger
      );
    });
  }

  @override
  void dispose() {
    context.read<LiveLocationViewModel>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherVM = context.watch<TeacherViewmodel>();
    final instituteVM = context.watch<InstituteViewModel>();
    final locationVM = context.watch<LocationViewmodel>();
    final String name = teacherVM.teacher?.name ?? 'Teacher';

    if (teacherVM.isLoading || instituteVM.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (teacherVM.error != null) {
      return Center(child: Text(teacherVM.error.toString()));
    }

    LatLng? geoLatLng;
    double? radius;
    final institute = instituteVM.instituteModel;
    if (institute != null) {
      geoLatLng = LatLng(
        institute.geoPoint.latitude,
        institute.geoPoint.longitude,
      );
      radius = institute.radius;
    }

    final LatLng teacherLatLng = LatLng(
      locationVM.currentLocation?.latitude ?? 0,
      locationVM.currentLocation?.longitude ?? 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Tracker')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: geoLatLng ?? const LatLng(28.4743879, 77.5039906),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.teacher_tracker',
              ),

              // Institute geofence circle
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

              // Teacher's live location marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: teacherLatLng,
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
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                    ),
                    const SizedBox(width: 10),
                    Text('You ($name)'),
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
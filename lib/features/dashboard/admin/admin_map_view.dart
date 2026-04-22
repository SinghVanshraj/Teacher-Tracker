import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:teacher_tracker/features/auth/viewmodels/auth_view_model.dart';
import 'package:teacher_tracker/features/dashboard/admin/admin_view_model.dart';
import 'package:teacher_tracker/features/institute/models/institute_model.dart';
import 'package:teacher_tracker/features/livelocation/live_location_model.dart';
import 'package:teacher_tracker/features/livelocation/live_location_view_model.dart';

// ⚠️ Replace with your PC's local IP when running server.dart
const String kServerUrl = 'ws://192.168.1.5:8080';

class AdminMapView extends StatefulWidget {
  const AdminMapView({super.key});

  @override
  State<AdminMapView> createState() => _AdminMapViewState();
}

class _AdminMapViewState extends State<AdminMapView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final uid = context.read<AuthViewModel>().user!.uid;
      final liveLocationVM = context.read<LiveLocationViewModel>();

      context.read<AdminViewModel>().fetchTeachers();
      context.read<AdminViewModel>().fetchInstitues();

      // ✅ Connect as admin to receive teacher locations
      liveLocationVM.connect(
        url: kServerUrl,
        uid: uid,
        role: 'admin',
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
    final adminVM = context.watch<AdminViewModel>();
    final liveLocationVM = context.watch<LiveLocationViewModel>();

    final listOfInstitutes = adminVM.institues?.docs ?? [];
    // ✅ Real teacher locations from WebSocket
    final Map<String, LiveLocationModel> teacherLocations =
        liveLocationVM.teacherLocations;

    if (adminVM.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Tracker')),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(28.4629, 77.4901),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.teacher_tracker',
              ),

              // Institute geofence circles
              CircleLayer(
                circles: listOfInstitutes.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final institute = InstituteModel.fromJson(data);
                  return CircleMarker(
                    point: LatLng(
                      institute.geoPoint.latitude,
                      institute.geoPoint.longitude,
                    ),
                    radius: institute.radius,
                    useRadiusInMeter: true,
                    color: Colors.blue.withOpacity(0.2),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),

              // ✅ Real teacher markers from WebSocket
              MarkerLayer(
                markers: teacherLocations.values.map((teacher) {
                  final isInside = teacher.geofenceStatus == 'inside';
                  return Marker(
                    point: LatLng(teacher.lat, teacher.long),
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isInside ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          color: Colors.white,
                          child: Text(
                            teacher.name,
                            style: const TextStyle(fontSize: 9),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Teacher count card
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      '${teacherLocations.length} teachers online',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: liveLocationVM.isConnected
                            ? Colors.green
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      liveLocationVM.isConnected ? 'Live' : 'Offline',
                      style: TextStyle(
                        color: liveLocationVM.isConnected
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Teacher details bottom sheet trigger
          if (teacherLocations.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: teacherLocations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final teacher =
                        teacherLocations.values.elementAt(index);
                    final isInside = teacher.geofenceStatus == 'inside';
                    return ListTile(
                      leading: Icon(
                        Icons.circle,
                        color: isInside ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      title: Text(teacher.name,
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text(teacher.department,
                          style: const TextStyle(fontSize: 11)),
                      trailing: Text(
                        isInside ? 'Inside' : 'Outside',
                        style: TextStyle(
                          color: isInside ? Colors.green : Colors.red,
                          fontSize: 11,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
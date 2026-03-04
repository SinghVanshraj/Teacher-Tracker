import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TeachersDashboardView extends StatelessWidget {
  const TeachersDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Tracker"),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(28.4629, 77.4901),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.teacher_tracker', // optional
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

          // Floating Teacher Info
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
                      backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
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
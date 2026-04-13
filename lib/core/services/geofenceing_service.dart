import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) return;

  final today = DateTime.now();
  final currentStatus = "${today.year}-${today.month}-${today.day}";

  final doc = FirebaseFirestore.instance
      .collection('attendance')
      .doc(uid)
      .collection('dates')
      .doc(currentStatus);
  if (params.event == GeofenceEvent.enter) {
    await doc.set({
      'attendance': "present",
      'current status': "inside",
    });
  } else if (params.event == GeofenceEvent.exit) {
    await doc.set({
      'attendance': "absent",
      'current status': "outside",
    });
  } else if (params.event == GeofenceEvent.dwell) {
    await doc.set({
      'attendance': "present",
      'current status': "inside",
    });
  }
}

class GeofenceingService {
  Future<void> createGeofence({
    required String instituteName,
    required GeoPoint instituteLocation,
    required double instituteRadius,
  }) async {
    await Permission.locationAlways.request();

    final geoFence = Geofence(
      id: instituteName,
      location: Location(
        latitude: instituteLocation.latitude,
        longitude: instituteLocation.longitude,
      ),
      radiusMeters: instituteRadius,
      iosSettings: IosGeofenceSettings(initialTrigger: false),
      androidSettings: AndroidGeofenceSettings(
        initialTriggers: {GeofenceEvent.enter, GeofenceEvent.exit},
      ),
      triggers: {GeofenceEvent.enter, GeofenceEvent.dwell, GeofenceEvent.exit},
    );

    try {
      await NativeGeofenceManager.instance.createGeofence(
        geoFence,
        geofenceTriggered,
      );
    } on NativeGeofenceException catch (e) {
      debugPrint(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:native_geofence/native_geofence.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  if (params.event == GeofenceEvent.enter) {
  } else if (params.event == GeofenceEvent.exit) {
  } else if (params.event == GeofenceEvent.dwell) {
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

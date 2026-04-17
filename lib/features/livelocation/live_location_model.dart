class LiveLocationModel {
  final String uid;
  final double lat;
  final double long;
  final String name;
  final String email;
  final String department;
  final String geofenceStatus;
  final DateTime timeStamp;

  LiveLocationModel({
    required this.uid,
    required this.lat,
    required this.long,
    required this.name,
    required this.email,
    required this.department,
    required this.geofenceStatus,
    required this.timeStamp,
  });

  factory LiveLocationModel.fromJson(Map<String, dynamic> json) {
    return LiveLocationModel(
      uid: json['uid'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
      name: json['name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      geofenceStatus: json['geofenceStatus'] as String,
      timeStamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'lat': lat,
      'long': long,
      'name': name,
      'email': email,
      'department': department,
      'geofenceStatus': geofenceStatus,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }
}

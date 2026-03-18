import 'package:cloud_firestore/cloud_firestore.dart';

class InstituteModel {
  final String name;
  final GeoPoint geoPoint;
  final double radius;

  InstituteModel({
    required this.name,
    required this.geoPoint,
    required this.radius,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location' : geoPoint,
      'radius' : radius
    };
  }

  factory InstituteModel.fromJson(Map<String, dynamic> json) {
    return InstituteModel(
      name: json['name'],
      geoPoint: json['location'] as GeoPoint,
      radius: (json['radius'] as num).toDouble(),
    );
  }
}

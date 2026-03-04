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
}

class TeacherModel {
  final String name;
  final String email;
  final String department;
  final String instituteId;
  final String workingStartTime;
  final String workingEndTime;

  TeacherModel({
    required this.name,
    required this.email,
    required this.department,
    required this.instituteId,
    required this.workingStartTime,
    required this.workingEndTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'instituteId': instituteId,
      'workingStartTime': workingStartTime,
      'workingEndTime': workingEndTime,
    };
  }

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      name: json['name'],
      email: json['email'],
      department: json['department'],
      instituteId: json['instituteId'],
      workingStartTime: json['workingStartTime'],
      workingEndTime: json['workingEndTime'],
    );
  }
}

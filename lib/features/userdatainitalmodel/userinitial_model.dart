// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserinitialModel {
  final String email;
  final String role;
  UserinitialModel({required this.email, required this.role});

  Map<String, dynamic> toJson() {
    return {'email': email, 'role': role};
  }

  factory UserinitialModel.fromJson(Map<String, dynamic> json) {
    return UserinitialModel(email: json['email'], role: json['role']);
  }
}

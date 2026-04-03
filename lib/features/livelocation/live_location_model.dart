class LiveLocationModel {
  final String uid;
  final double lat;
  final double long;
  final DateTime timeStamp;

  LiveLocationModel({
    required this.uid,
    required this.lat,
    required this.long,
    required this.timeStamp,
  });

  factory LiveLocationModel.fromJson(Map<String, dynamic> json) {
    return LiveLocationModel(
      uid: json['uid'],
      lat: json['lat'],
      long: json['long'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'lat': lat,
      'long': long,
      'timeStamp': timeStamp.toIso8601String()
    };
  }
}

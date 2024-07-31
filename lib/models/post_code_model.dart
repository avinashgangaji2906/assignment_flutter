class PostcodeModel {
  final String status;
  final int statusCode;
  final int postcode;
  final List<LocationData> city;
  final List<LocationData> state;

  PostcodeModel({
    required this.status,
    required this.statusCode,
    required this.postcode,
    required this.city,
    required this.state,
  });

  factory PostcodeModel.fromJson(Map<String, dynamic> map) {
    return PostcodeModel(
      postcode: map['postcode'],
      status: map['status'] ?? '',
      statusCode: map['statusCode'],
      city: List<LocationData>.from(
          (map['city'] ?? []).map((item) => LocationData.fromJson(item))),
      state: List<LocationData>.from(
          (map['state'] ?? []).map((item) => LocationData.fromJson(item))),
    );
  }
}

class LocationData {
  final int id;
  final String name;

  LocationData({
    required this.id,
    required this.name,
  });

  factory LocationData.fromJson(Map<String, dynamic> map) {
    return LocationData(
      id: map['id'],
      name: map['name'] ?? '',
    );
  }
}

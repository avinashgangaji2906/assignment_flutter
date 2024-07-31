class PanModel {
  final String status;
  final int statusCode;
  final bool isValid;
  final String fullName;

  PanModel({
    required this.status,
    required this.statusCode,
    required this.isValid,
    required this.fullName,
  });

  factory PanModel.fromJson(Map<String, dynamic> map) {
    return PanModel(
        fullName: map['fullName'] ?? '',
        isValid: map['isValid'],
        status: map['status'],
        statusCode: map['statusCode']);
  }
}

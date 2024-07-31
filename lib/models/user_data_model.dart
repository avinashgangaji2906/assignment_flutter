class UserDataModel {
  final String userId;
  final String panNumber;
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<Addresses> addresses;

  UserDataModel({
    required this.userId,
    required this.panNumber,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.addresses,
  });

// to convert UserDataModel object to Json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'pan_number': panNumber,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'addresses': addresses,
    };
  }

// to convert json to UserdataModel
  factory UserDataModel.fromJson(Map<String, dynamic> map) {
    return UserDataModel(
      userId: map['user_id'] ?? '',
      panNumber: map['pan_number'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      addresses: List<Addresses>.from(map['addresses'] ?? [])
          .map(
            (item) => Addresses.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  UserDataModel copyWith({
    String? userId,
    String? panNumber,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? postCode,
    List<Addresses>? addresses,
  }) {
    return UserDataModel(
        userId: userId ?? this.userId,
        panNumber: panNumber ?? this.panNumber,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        addresses: addresses ?? this.addresses);
  }
}

class Addresses {
  final String addressLine1;
  final String? addressLine2;
  final String postCode;
  final String city;
  final String state;

  Addresses({
    required this.addressLine1,
    this.addressLine2,
    required this.postCode,
    required this.city,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'post_code': postCode,
      'city': city,
      'state': state,
    };
  }

  factory Addresses.fromJson(Map<String, dynamic> map) {
    return Addresses(
      addressLine1: map['address_line1'] as String,
      addressLine2:
          map['address_line2'] != null ? map['address_line2'] as String : null,
      postCode: map['post_code'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
    );
  }
  Addresses copyWith({
    String? addressLine1,
    String? addressLine2,
    String? postCode,
    String? city,
    String? state,
  }) {
    return Addresses(
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }
}

class Address {
  final String? id;
  final String fullName;
  final String locality;
  final String pincode;
  final String city;
  final String state;
  final String landmark;
  final String alternativePhone;
  final String addressType;

  Address({
    this.id,
    required this.fullName,
    required this.locality,
    required this.pincode,
    required this.city,
    required this.state,
    required this.landmark,
    required this.alternativePhone,
    required this.addressType,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'locality': locality,
      'pincode': pincode,
      'city': city,
      'state': state,
      'landmark': landmark,
      'alternativePhone': alternativePhone,
      'addressType': addressType,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["_id"],
      fullName: json["fullName"],
      locality: json["locality"],
      pincode: json["pincode"],
      city: json["city"],
      state: json["state"],
      landmark: json["landmark"],
      alternativePhone: json["alternativePhone"],
      addressType: json["addressType"],
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Address {
  final String? id;
  final bool? isDefault;
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
    this.isDefault,
    required this.fullName,
    required this.locality,
    required this.pincode,
    required this.city,
    required this.state,
    required this.landmark,
    required this.alternativePhone,
    required this.addressType,
  });

  Map<String, dynamic> toJsonWithDefault() {
    return {
      'fullName': fullName,
      'locality': locality,
      'pincode': pincode,
      'city': city,
      'state': state,
      'landmark': landmark,
      'alternativePhone': alternativePhone,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }

  Map<String, dynamic> toJsonWithoutDefault() {
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
      isDefault: json["isDefault"],
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, isDefault: $isDefault, fullName: $fullName, locality: $locality, pincode: $pincode, city: $city, state: $state, landmark: $landmark, alternativePhone: $alternativePhone, addressType: $addressType)';
  }
}

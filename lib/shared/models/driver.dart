import 'dart:convert';

class Driver {
  final String id;
  // Personal info
  String name;
  String governmentId;
  String dateOfBirth; // ISO 8601 format: YYYY-MM-DD
  String phone;
  String email;
  String residentialAddress;
  String? photoBase64; // base64 encoded selfie

  // Vehicle info
  String vehicleType;
  String vehicleBrand;
  String vehicleModel;
  String vehicleYear;
  String licensePlate;
  String vehicleRegistration;

  Driver({
    required this.id,
    required this.name,
    required this.governmentId,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.residentialAddress,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.licensePlate,
    required this.vehicleRegistration,
    this.photoBase64,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      governmentId: json['governmentId'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      residentialAddress: json['residentialAddress'] as String,
      vehicleType: json['vehicleType'] as String,
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehicleYear: json['vehicleYear'] as String,
      licensePlate: json['licensePlate'] as String,
      vehicleRegistration: json['vehicleRegistration'] as String,
      photoBase64: json['photoBase64'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'governmentId': governmentId,
    'dateOfBirth': dateOfBirth,
    'phone': phone,
    'email': email,
    'residentialAddress': residentialAddress,
    'vehicleType': vehicleType,
    'vehicleBrand': vehicleBrand,
    'vehicleModel': vehicleModel,
    'vehicleYear': vehicleYear,
    'licensePlate': licensePlate,
    'vehicleRegistration': vehicleRegistration,
    'photoBase64': photoBase64,
  };

  static List<Driver> listFromJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    final list = json.decode(jsonString) as List<dynamic>;
    return list.map((e) => Driver.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<Driver> drivers) {
    final list = drivers.map((d) => d.toJson()).toList();
    return json.encode(list);
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return regex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final regex = RegExp(r"^[0-9+()\-\s]{7,20}");
    return regex.hasMatch(phone);
  }

  static bool isValidGovernmentId(String id) {
    return id.trim().length >= 5;
  }

  static bool isValidLicensePlate(String plate) {
    return plate.trim().length >= 3;
  }

  static bool isValidYear(String year) {
    try {
      final y = int.parse(year);
      return y >= 1900 && y <= DateTime.now().year;
    } catch (_) {
      return false;
    }
  }
}

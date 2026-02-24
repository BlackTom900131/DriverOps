import 'dart:convert';

class RouteStop {
  final String id;
  String address;
  double? latitude;
  double? longitude;
  int sequence;
  String? eta; // ISO 8601 or simple timestamp string

  RouteStop({
    required this.id,
    required this.address,
    this.latitude,
    this.longitude,
    required this.sequence,
    this.eta,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      sequence: json['sequence'] as int,
      eta: json['eta'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'sequence': sequence,
    'eta': eta,
  };
}

class RouteModel {
  final String id;
  String name;
  String? description;
  List<RouteStop> stops;

  RouteModel({
    required this.id,
    required this.name,
    this.description,
    List<RouteStop>? stops,
  }) : stops = stops ?? [];

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final stopsJson = json['stops'] as List<dynamic>?;
    return RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      stops: stopsJson == null
          ? []
          : stopsJson
                .map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'stops': stops.map((s) => s.toJson()).toList(),
  };

  static List<RouteModel> listFromJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    final list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<RouteModel> routes) {
    final list = routes.map((r) => r.toJson()).toList();
    return json.encode(list);
  }
}

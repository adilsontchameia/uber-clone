import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String? title;
  final LatLng? position;
  final String? label;
  final String? id;

  Place({
    this.id,
    this.title,
    this.position,
    this.label,
  });

  static Place fromjson(Map<String, dynamic> json) {
    return Place(
        id: json["id"],
        title: json['title'],
        position: LatLng(json['position']["lat"], json['position']["lng"]),
        label: json['address']["label"]);
  }
}

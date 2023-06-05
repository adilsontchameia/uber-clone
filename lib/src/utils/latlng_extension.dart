import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

extension LatLngString on LatLng {
  String format() {
    return "$latitude,$longitude";
  }
}

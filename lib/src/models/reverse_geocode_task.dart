import 'package:uber_clone/src/models/places.dart';

class ReverseGeoCodeTask {
  Place place;

  bool isOrigin;

  ReverseGeoCodeTask({required this.place, required this.isOrigin});
}

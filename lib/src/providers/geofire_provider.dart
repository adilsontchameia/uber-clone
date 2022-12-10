import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class GeofireProvider {
  CollectionReference? _ref;
  GeoFlutterFire? _geo;

  GeofireProvider() {
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = GeoFlutterFire();
  }

  Stream<List<DocumentSnapshot>> getNearbyDrivers(
      double lat, double lng, double radius) {
    //Radius - Pra ver se mostre os condutores em que raio de distancia
    GeoFirePoint center = _geo!.point(latitude: lat, longitude: lng);
    return _geo!
        .collection(
            collectionRef:
                _ref!.where('status', isEqualTo: 'drivers_available'))
        .within(center: center, radius: radius, field: 'position');
  }

  Stream<DocumentSnapshot> getLocationByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(String id, double lat, double lng) {
    GeoFirePoint myLocation = _geo!.point(latitude: lat, longitude: lng);
    return _ref!
        .doc(id)
        .set({'status': 'drivers_available', 'position': myLocation.data});
  }

  Future<void> delete(String id) {
    return _ref!.doc(id).delete();
  }
}

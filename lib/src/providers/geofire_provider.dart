import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeofireProvider {
  CollectionReference _ref;
  Geoflutterfire _geo;

  GeofireProvider() {
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = Geoflutterfire();
  }

  Stream<DocumentSnapshot> getLocationByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(String id, double lat, double lng) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref
        .doc(id)
        .set({'status': 'drivers_available', 'position': myLocation.data});
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }
}

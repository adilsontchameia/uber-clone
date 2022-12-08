import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_flutter_udemy/src/models/client.dart';
import 'package:uber_clone_flutter_udemy/src/models/driver.dart';

class DriverProvider {

  CollectionReference _ref;

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void> create(Driver driver) {
    String errorMessage;

    try {
      return _ref.doc(driver.id).set(driver.toJson());
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Driver> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      Driver driver = Driver.fromJson(document.data());
      return driver;
    }

    return null;
  }

}
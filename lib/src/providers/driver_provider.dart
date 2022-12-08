import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver.dart';

class DriverProvider {
  CollectionReference? _ref;

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void>? create(Driver driver) {
    String errorMessage;

    try {
      return _ref!.doc(driver.id).set(driver.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }

    return Future.error(errorMessage);
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Driver?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      Driver driver = Driver.fromJson(document.data() as Map<String, dynamic>);
      return driver;
    }

    return null;
  }
}

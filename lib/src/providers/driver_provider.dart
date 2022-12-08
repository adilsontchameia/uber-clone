import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    } on FirebaseAuthException catch (error) {
      errorMessage = error.code;
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    } else {
      return create(driver);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Driver> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      Driver driver = Driver.fromJson(document.data() as Map<String, dynamic>);
      return driver;
    }

    return getById(id);
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref!.doc(id).update(data);
  }
}

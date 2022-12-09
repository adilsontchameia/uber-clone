import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client.dart';

class ClientProvider {
  CollectionReference? _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection('Clients');
  }

  Future<void>? create(Client client) {
    String errorMessage;

    try {
      return _ref!.doc(client.id).set(client.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    } else {
      return create(client);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Client?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      Client client =
          Client.fromJson(document.data().toString() as Map<String, dynamic>);
      return client;
    }

    return null;
  }
}

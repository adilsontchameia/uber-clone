import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_flutter_udemy/src/models/client.dart';

class ClientProvider {

  CollectionReference _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection('Clients');
  }

  Future<void> create(Client client) {
    String errorMessage;

    try {
      return _ref.doc(client.id).set(client.toJson());
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

  Future<Client> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      Client client = Client.fromJson(document.data());
      return client;
    }

    return null;

  }


}
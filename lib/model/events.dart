import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';

class events {
  String id = '';
  location locations = location.empty();
  users client = users.empty();
  users master = users.empty();
  DateTime start = DateTime.now();
  DateTime finish = DateTime.now();

  events(this.id, this.locations, this.client, this.master, this.start,
      this.finish);

  events.empty() {
    this.id = '';
    this.locations = location.empty();
    this.client = users.empty();
    client.role = 'client';
    this.master = users.empty();
    master.role = 'master';
    this.start = DateTime.now();
    this.finish = DateTime.now();
  }

  static events short(DocumentSnapshot ds) {
    location locations = location.empty();
    locations.id = (ds['location_id'] as DocumentReference).id;

    users client = users.empty();
    client.role = 'client';
    client.id = (ds['client_id'] as DocumentReference).id;

    users master = users.empty();
    master.role = 'master';
    master.id = (ds['master_id'] as DocumentReference).id;

    return events(ds.id, locations, client, master, ds['start'].toDate(),
        ds['finish'].toDate());
  }

  static Future<events> fromDocSnapshot(DocumentSnapshot ds) async {
    String client_id = (ds['client_id'] as DocumentReference).id;

    DocumentSnapshot<Map<String, dynamic>> clientSn = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(client_id)
        .get();
    users client = users.fromDocumentSnapshot(clientSn);

    String master_id = (ds['master_id'] as DocumentReference).id;

    DocumentSnapshot<Map<String, dynamic>> masterSn = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(master_id)
        .get();
    users master = users.fromDocumentSnapshot(masterSn);
    //----------------------------------
    String locationId = (ds['location_id'] as DocumentReference).id;

    DocumentSnapshot<Map<String, dynamic>> lockSn = await FirebaseFirestore
        .instance
        .collection('locations')
        .doc(locationId)
        .get();

    location locat = location.fromDocSnapshot(lockSn);

    return events(ds.id, locat, client, master, ds['start'].toDate(),
        ds['finish'].toDate());
  }

  @override
  String toString() {
    return 'id= $id, locations = $locations, client = $client, master = $master, start = $start, finish = $finish';
  }
}

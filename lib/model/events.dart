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

  static events fromDocSnapshot(DocumentSnapshot ds) {
    String clientId = ds['client']['id'];
    String clientEmail = ds['client']['email'];

    String clientPassword = ds['client']['password'];
    String clientUserName = ds['client']['userName'];
    String clientRole = ds['client']['role'];
    bool clientIsApproved = ds['client']['IsApproved'];
    String clientFotoUrl = ds['client']['fotoUrl'];

    users client = users(clientId, clientEmail, clientPassword, clientUserName,
        clientRole, clientIsApproved, clientFotoUrl);

    String masterId = ds['master']['id'];
    String masterEmail = ds['master']['email'];

    String masterPassword = ds['master']['password'];
    String masterUserName = ds['master']['userName'];
    String masterRole = ds['master']['role'];
    bool masterIsApproved = ds['master']['IsApproved'];
    String masterFotoUrl = ds['master']['fotoUrl'];

    users master = users(masterId, masterEmail, masterPassword, masterUserName,
        masterRole, masterIsApproved, masterFotoUrl);

    String locationId = (ds['location_id'] as DocumentReference).id;

    // DocumentSnapshot locationSnapshot = await FirebaseFirestore.instance
    //     .collection('locations')
    //     .doc(locationId)
    //     .get();

    location locat = location(locationId, '');

    return events(ds.id, locat, client, master, ds['start'].toDate(),
        ds['finish'].toDate());
  }

  @override
  String toString() {
    return 'id= $id, locations = $locations, client = $client, master = $master, start = $start, finish = $finish';
  }
}

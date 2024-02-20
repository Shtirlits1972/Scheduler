import 'package:cloud_firestore/cloud_firestore.dart';

class location {
  String id = '';
  String LocationName = '';

  location(this.id, this.LocationName);
  location.empty() {
    id = '';
    LocationName = '';
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'LocationName': LocationName};
  }

  factory location.fromDocSnapshot(DocumentSnapshot ds) {
    String LocationName = ds['LocationName'];

    return location(ds.id, LocationName);
  }

  @override
  String toString() {
    return 'id = $id, LocationName = $LocationName';
  }
}

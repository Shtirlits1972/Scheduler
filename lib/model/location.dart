import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app/model/color_save.dart';

class location {
  String id = '';
  String LocationName = '';
  color_save color_s = color_save.empty();

  location(this.id, this.LocationName, this.color_s);
  location.empty() {
    id = '';
    LocationName = '';
    color_s = color_save.empty();
  }

  Map<String, dynamic> toMap() {
    return {'LocationName': LocationName, 'color_s': color_s.toMap()};
  }

  factory location.fromDocSnapshot(DocumentSnapshot ds) {
    String LocationName = ds['LocationName'];

    int alpha = ds['color_s.alpha'];
    int red = ds['color_s.red'];
    int green = ds['color_s.green'];
    int blue = ds['color_s.blue'];

    color_save color_s = color_save(alpha, red, green, blue);
    return location(ds.id, LocationName, color_s);
  }

  @override
  String toString() {
    return 'id = $id, LocationName = $LocationName, color_s = $color_s';
  }
}

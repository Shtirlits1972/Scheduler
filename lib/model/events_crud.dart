import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';

class EventsCrud {
  static Future<events> getEventFromDocSnapshot(DocumentSnapshot ds) async {
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

    DocumentReference locationId = ds['location_id'];

    location locat = location.empty();

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId.id)
        .get();

    locat = location.fromDocSnapshot(snap);

    //     .then(
    //   (value) {
    //
    return events(ds.id, locat, client, master, ds['start'].toDate(),
        ds['finish'].toDate());
    //   },
    // );
    // return events.empty();
    // location locat = location.fromDocSnapshot(locationSnapshot);
  }

//   Future<List<events>> getEvents() async {
//     List<events> list = [];

// //     final modelsRef = FirebaseFirestore
// //       .instance
// //       .collection('events')
// //       .withConverter( fromFirestore: (snapshot, _) => events.fromJson(snapshot.data()!),
// //       toFirestore: (model, _) => model.toJson(),
// // );

//     QuerySnapshot eventsSnapshot =
//         await FirebaseFirestore.instance.collection('events').get();

//     for (QueryDocumentSnapshot eventDoc in eventsSnapshot.docs) {
//       print(eventDoc.data());

//       if (eventDoc['location_id'] != null) {
//         events ev = events.empty();
//         print(eventDoc['location_id'].id);

//         try {
//           DocumentSnapshot doc = await FirebaseFirestore.instance
//               .collection('locations')
//               .doc(eventDoc['location_id'].id)
//               .get();

//           print(doc.data());
//           location loc = location.fromDocSnapshot(doc);
//           ev.locations = loc;
//           list.add(ev);
//           int y = 0;
//         } catch (e) {
//           print(e);
//         }
//       }

//       events model = events.fromDocSnapshot(eventDoc);
//       print(model);
//       list.add(model);
//     }

//     return list;
//   }
}

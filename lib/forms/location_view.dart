import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';

class LocationView extends StatefulWidget {
  LocationView({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;
  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocationView'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              location model = location.empty();
              Navigator.pushNamed(context, '/LocationAddForm',
                  arguments: model);
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add new Location',
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Dismissible(
                  key: Key(ds.id),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    //   setState(() {
                    final collection =
                        FirebaseFirestore.instance.collection('locations');
                    collection
                        .doc(ds.id) // <-- Doc ID to be deleted.
                        .delete() // <-- Delete
                        .then((_) => print('Deleted'))
                        .catchError((error) => print('Delete failed: $error'));
                    //    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${ds['LocationName']} удалён!')));
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      print('long press   ${ds['LocationName']} ');
                      location model = location(ds.id, ds['LocationName']);

                      Navigator.pushNamed(context, '/LocationAddForm',
                          arguments: model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ds['LocationName'],
                        style: txt20,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomBarGeneral(
        selectedIndex: widget.selectedIndex,
        IsAdmin: context.read<DataCubit>().getUser.IsAdmin(),
      ),
    );
  }
}

Future<List<location>> getLocations() async {
  List<location> list = [];

  var collection = FirebaseFirestore.instance.collection('locations');
  var querySnapshots = await collection.get();

  for (var snapshot in querySnapshots.docs) {
    String documentID = snapshot.id; // <-- Document ID
    String LocationName = snapshot.data()['LocationName'];
    location loc = location(documentID, LocationName);
    list.add(loc);
  }

  return list;
}

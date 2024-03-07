import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/events_crud.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';

class SchedulerView extends StatefulWidget {
  SchedulerView({Key? key, required this.selectedIndex}) : super(key: key);

  int selectedIndex;
  @override
  _SchedulerViewState createState() => _SchedulerViewState();
}

class _SchedulerViewState extends State<SchedulerView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;
  List<events> lstEvents = [];

  @override
  Widget build(BuildContext context) {
    if (lstEvents.isNotEmpty) {
      print(lstEvents);
      int a = 0;
    }

    if (context.read<DataCubit>().getUser.role == 'client') {
      snapshot = FirebaseFirestore.instance
          .collection('events')
          .where('client.id', isEqualTo: context.read<DataCubit>().getUser.id)
          .snapshots();
    } else if (context.read<DataCubit>().getUser.role == 'master') {
      snapshot = FirebaseFirestore.instance
          .collection('events')
          .where('master.id', isEqualTo: context.read<DataCubit>().getUser.id)
          .snapshots();
    } else {
      snapshot = FirebaseFirestore.instance.collection('events').snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'SchedulerView',
          style: txt20,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // var lst = await crud.getEvents();
              // print(lst);
              // int h = 0;

              events model = events.empty();
              Navigator.pushNamed(context, '/ShedulerAdd', arguments: model);
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add new Event',
          )
        ],
      ),
      body: StreamBuilder(
        stream: snapshot,
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Нет Данных',
                  style: txt20,
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                String LocationName = 'locationName';
                events model = events.empty();

                return Dismissible(
                  key: Key(ds.id),
                  onDismissed: (direction) {
                    final collection =
                        FirebaseFirestore.instance.collection('events');
                    collection
                        .doc(ds.id) // <-- Doc ID to be deleted.
                        .delete() // <-- Delete
                        .then((_) => print('Deleted'))
                        .catchError((error) => print('Delete failed: $error'));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('мероприятие удалено!'),
                      ),
                    );
                    print(ds.id);
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      Navigator.pushNamed(context, '/ShedulerAdd',
                          arguments: model);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0) //
                                ),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'location: ${ds['locations']['LocationName']}',
                            'location ${ds['location_id'].path}',
                            style: txt20,
                          ),
                          Text(
                            'start: ${dataFormat.format(ds['start'].toDate())}',
                            style: txt20,
                          ),
                          Text(
                            'finish: ${dataFormat.format(ds['finish'].toDate())}',
                            style: txt20,
                          ),
                          Text(
                            'Master: ${ds['master']['userName']}',
                            style: txt20,
                          ),
                          Text(
                            'Client: ${ds['client']['userName']}',
                            style: txt20,
                          ),
                        ],
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

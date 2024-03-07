import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';

class ShedulerViewFuture extends StatefulWidget {
  ShedulerViewFuture({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;
  @override
  _ShedulerViewFutureState createState() => _ShedulerViewFutureState();
}

class _ShedulerViewFutureState extends State<ShedulerViewFuture> {
  // ======
  Future<List<events>> getLength(String userRole) async {
    List<events> list = [];

    QuerySnapshot<Map<String, dynamic>> events_snapshot;

    if (userRole == 'client') {
      events_snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('client.id', isEqualTo: context.read<DataCubit>().getUser.id)
          .get();
    } else if (userRole == 'master') {
      events_snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('master.id', isEqualTo: context.read<DataCubit>().getUser.id)
          .get();
    } else {
      events_snapshot =
          await FirebaseFirestore.instance.collection('events').get();
    }

    // QuerySnapshot<Map<String, dynamic>> events_snapshot =
    //     await FirebaseFirestore.instance.collection('events').get();

    for (int i = 0; i < events_snapshot.docs.length; i++) {
      events ev = events.fromDocSnapshot(events_snapshot.docs[i]);
      DocumentSnapshot<Map<String, dynamic>> lock = await FirebaseFirestore
          .instance
          .collection('locations')
          .doc(ev.locations.id)
          .get();
      ev.locations.LocationName = lock['LocationName'];
      list.add(ev);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
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
              events model = events.empty();
              Navigator.pushNamed(context, '/ShedulerAdd', arguments: model);
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add new Event',
          )
        ],
      ),
      body: Center(
        child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
            itemCount: context.read<DataCubit>().getEvents.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(context.read<DataCubit>().getEvents[index].id),
                onDismissed: (direction) {
                  final collection =
                      FirebaseFirestore.instance.collection('events');
                  collection
                      .doc(context
                          .read<DataCubit>()
                          .getEvents[index]
                          .id) // <-- Doc ID to be deleted.
                      .delete() // <-- Delete
                      .then((_) {
                    context
                        .read<DataCubit>()
                        .delEvents(context.read<DataCubit>().getEvents[index]);
                    print('Deleted');
                  }).catchError((error) => print('Delete failed: $error'));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('мероприятие удалено!'),
                    ),
                  );
                  print(context.read<DataCubit>().getEvents[index].id);
                },
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.pushNamed(context, '/ShedulerAdd',
                        arguments: context.read<DataCubit>().getEvents[index]);
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
                          'location ${context.read<DataCubit>().getEvents[index].locations.LocationName}',
                          style: txt20,
                        ),
                        Text(
                          'start: ${dataFormat.format(context.read<DataCubit>().getEvents[index].start)}',
                          style: txt20,
                        ),
                        Text(
                          'finish: ${dataFormat.format(context.read<DataCubit>().getEvents[index].finish)}',
                          style: txt20,
                        ),
                        Text(
                          'Master: ${context.read<DataCubit>().getEvents[index].master.userName}',
                          style: txt20,
                        ),
                        Text(
                          'Client: ${context.read<DataCubit>().getEvents[index].client.userName}',
                          style: txt20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),

      //  FutureBuilder<int>(
      //     future: getLength(),
      //     builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //       return Center(
      //         child: Text(
      //           snapshot.data!.toString(),
      //           style: txt20,
      //         ),
      //       );
      //     }),
      bottomNavigationBar: BottomBarGeneral(
        selectedIndex: widget.selectedIndex,
        IsAdmin: context.read<DataCubit>().getUser.IsAdmin(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    getLength(context.read<DataCubit>().getUser.role).then((value) {
      context.read<DataCubit>().setEventsList(value);
      setState(() {});
    });
    super.initState();
  }
}

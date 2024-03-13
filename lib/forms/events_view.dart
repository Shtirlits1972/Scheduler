import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';

class EventsView extends StatefulWidget {
  EventsView({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  bool isLoaded = false;
  // ======
  Future<List<events>> getEventList(String userRole) async {
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

    for (int i = 0; i < events_snapshot.docs.length; i++) {
      events ev = events.short(events_snapshot.docs[i]);
      location lock = context
          .read<DataCubit>()
          .getLocations
          .singleWhere((element) => element.id == ev.locations.id);
      ev.locations = lock;

      users master = context.read<DataCubit>().getAllUsers.singleWhere(
          (element) => element.id == ev.master.id && element.role == 'master');
      ev.master = master;

      users client = context.read<DataCubit>().getAllUsers.singleWhere(
          (element) => element.id == ev.client.id && element.role == 'client');
      ev.client = client;

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
      body: getCenterWidget(context),
      bottomNavigationBar: BottomBarGeneral(
        selectedIndex: widget.selectedIndex,
        IsAdmin: context.read<DataCubit>().getUser.IsAdmin(),
      ),
    );
  }

  Center getCenterWidget(BuildContext context) {
    if (context.read<DataCubit>().getEvents.isEmpty) {
      return Center(
        child: Text(
          'No Data',
          style: txt30,
        ),
      );
    } else {
      return Center(
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
                      color: Color.fromARGB(
                          context
                              .read<DataCubit>()
                              .getEvents[index]
                              .locations
                              .color_s
                              .alpha,
                          context
                              .read<DataCubit>()
                              .getEvents[index]
                              .locations
                              .color_s
                              .red,
                          context
                              .read<DataCubit>()
                              .getEvents[index]
                              .locations
                              .color_s
                              .green,
                          context
                              .read<DataCubit>()
                              .getEvents[index]
                              .locations
                              .color_s
                              .blue),
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
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getEventList(context.read<DataCubit>().getUser.role).then((value) {
      setState(() {
        context.read<DataCubit>().setEventsList(value);
        isLoaded = true;
      });
    });
  }
}

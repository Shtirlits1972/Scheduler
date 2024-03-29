import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:scheduler_app/block/block.dart';

import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/user_select.dart';
import 'package:scheduler_app/widgets/locations_select.dart';

class EventAdd extends StatefulWidget {
  EventAdd({Key? key, required this.model}) : super(key: key);
  events model;
  @override
  _EventAddState createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  String strStart = 'начало';
  String strFinish = 'окончание';
  String strLocation = 'локация';
  String strMasterName = 'мастер';
  String strClientName = 'клиент';
  DateTime dateCurrStart = DateTime.now();
  DateTime dateCurrFinish = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.model.id.trim().isNotEmpty) {
      strLocation = widget.model.locations.LocationName;
      strMasterName = widget.model.master.userName;
      strClientName = widget.model.client.userName;
      dateCurrStart = widget.model.start;
      dateCurrFinish = widget.model.finish;
//================================
      strStart = dataFormat.format(dateCurrStart);
      strFinish = dataFormat.format(dateCurrFinish);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'ShedulerAdd',
          style: txt20,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // начало
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Start',
                          style: txt20,
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(
                              16,
                              16,
                            ),
                          ),
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: TextButton(
                          onPressed: () {
                            picker.DatePicker.showDateTimePicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              print('confirm $date');

                              setState(
                                () {
                                  strStart = dataFormat.format(date);
                                  dateCurrStart = date;
                                  widget.model.start = date;
                                },
                              );
                            },
                                currentTime: dateCurrStart,
                                locale: picker.LocaleType.ru);
                          },
                          child: Text(
                            strStart,
                            style: txt20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            //  окончание
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Finish',
                        style: txt20,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(
                              16,
                              16,
                            ),
                          ),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextButton(
                        onPressed: () {
                          picker.DatePicker.showDateTimePicker(context,
                              showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            print('confirm $date');

                            setState(
                              () {
                                strFinish = dataFormat.format(date);
                                dateCurrFinish = date;
                                widget.model.finish = date;
                              },
                            );
                          },
                              currentTime: dateCurrFinish,
                              locale: picker.LocaleType.ru);
                        },
                        child: Text(
                          strFinish,
                          style: txt20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //  локации
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Location',
                          style: txt20,
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.elliptical(
                                16,
                                16,
                              ),
                            ),
                            border: Border.all(color: Colors.blueAccent)),
                        child: TextButton(
                          onPressed: () async {
                            List<location> listLocations = [];

                            CollectionReference collection = FirebaseFirestore
                                .instance
                                .collection('locations');

                            var snapshot = await collection.get();

                            for (int i = 0; i < snapshot.docs.length; i++) {
                              location locat =
                                  location.fromDocSnapshot(snapshot.docs[i]);

                              // location(snapshot.docs[i].id,
                              //     snapshot.docs[i]['LocationName']);

                              listLocations.add(locat);
                            }

                            if (widget.model.locations.id.isEmpty) {
                              widget.model.locations = listLocations[0];
                            }

                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                int y = 0;
                                return LocationsSelect(
                                  LocationId: widget.model.locations.id,
                                  callback: (value) {
                                    //   groupValue = value!;

                                    setState(
                                      () {
                                        widget.model.locations = listLocations
                                            .firstWhere((e) => e.id == value);

                                        strLocation =
                                            widget.model.locations.LocationName;
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            strLocation,
                            style: txt20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            //  master
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Master',
                        style: txt20,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(
                              16,
                              16,
                            ),
                          ),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextButton(
                        onPressed: () async {
                          List<users> listMaster = [];
                          CollectionReference collection =
                              FirebaseFirestore.instance.collection('users');

                          var snapshot = await collection
                              .where('role', isEqualTo: 'master')
                              .get();

                          for (int i = 0; i < snapshot.docs.length; i++) {
                            users master = users(
                                snapshot.docs[i].id,
                                snapshot.docs[i]['email'],
                                snapshot.docs[i]['password'],
                                snapshot.docs[i]['userName'],
                                snapshot.docs[i]['role'],
                                snapshot.docs[i]['IsApproved'],
                                snapshot.docs[i]['fotoUrl']);

                            listMaster.add(master);
                          }

                          if (widget.model.master.id.isEmpty) {
                            widget.model.master = listMaster[0];
                          }
                          int y = 0;
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              int y = 0;
                              return UserSelect(
                                user_id: widget.model.master.id,
                                user_role: 'master',
                                callback: (value) {
                                  //   groupValue = value!;

                                  setState(
                                    () {
                                      int p = 0;
                                      widget.model.master = listMaster
                                          .firstWhere((e) => e.id == value);

                                      strMasterName =
                                          widget.model.master.userName;
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          strMasterName,
                          style: txt20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //  client
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Client',
                        style: txt20,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(
                              16,
                              16,
                            ),
                          ),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextButton(
                        onPressed: () async {
                          List<users> listClient = [];
                          CollectionReference collection =
                              FirebaseFirestore.instance.collection('users');

                          var snapshot = await collection
                              .where('role', isEqualTo: 'client')
                              .get();

                          for (int i = 0; i < snapshot.docs.length; i++) {
                            users client = users(
                              snapshot.docs[i].id,
                              snapshot.docs[i]['email'],
                              snapshot.docs[i]['password'],
                              snapshot.docs[i]['userName'],
                              snapshot.docs[i]['role'],
                              snapshot.docs[i]['IsApproved'],
                              snapshot.docs[i]['fotoUrl'],
                            );

                            listClient.add(client);
                          }

                          if (widget.model.client.id.isEmpty) {
                            widget.model.client = listClient[0];
                          }
                          int y = 0;
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              int y = 0;
                              return UserSelect(
                                user_id: widget.model.client.id,
                                user_role: 'client',
                                callback: (value) {
                                  int y = 0;
                                  setState(
                                    () {
                                      try {
                                        users client = listClient
                                            .firstWhere((e) => e.id == value);

                                        int p = 0;
                                        widget.model.client = client;
                                        int h = 0;
                                        strClientName =
                                            widget.model.client.userName;
                                      } on Exception catch (e) {
                                        print(e);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          strClientName,
                          style: txt20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            //  кнопки
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          String error = '';
                          print(widget.model);

                          if (widget.model.locations.id.trim().isEmpty) {
                            error += 'locations is empty! \r\n';
                          }

                          if (widget.model.master.id.trim().isEmpty) {
                            error += 'master is empty! \r\n';
                          }

                          if (widget.model.client.id.trim().isEmpty) {
                            error += 'client is empty! \r\n';
                          }

                          if (strStart == 'начало') {
                            error += 'select start! \r\n';
                          }

                          if (strFinish == 'окончание') {
                            error += 'select finish! \r\n';
                          }
                          //  есть ошибки
                          if (error.trim().isNotEmpty) {
                            showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Warning!'),
                                content: Text(error),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      'OK',
                                      style: txt30,
                                    ),
                                  ),
                                ],
                              ),
                            );

                            return;
                          }
                          //  нет ошибок
                          else {
                            DocumentSnapshot<Map<String, dynamic>>
                                locDocSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('locations')
                                    .doc(widget.model.locations.id)
                                    .get();

                            DocumentReference locRef = locDocSnapshot.reference;
                            //======================================================
                            DocumentSnapshot<Map<String, dynamic>>
                                clientSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.model.client.id)
                                    .get();

                            DocumentReference clientRef =
                                clientSnapshot.reference;
                            //------------------------------------------------
                            DocumentSnapshot<Map<String, dynamic>>
                                masterSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.model.master.id)
                                    .get();

                            DocumentReference masterRef =
                                masterSnapshot.reference;
                            //======================================================

                            if (widget.model.id.trim().isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(widget.model.id)
                                  .update(
                                {
                                  'location_id': locRef,
                                  'start': widget.model.start,
                                  'finish': widget.model.finish,
                                  'client_id': clientRef,
                                  'master_id': masterRef,
                                },
                              ).then((value) {
                                //==========
                              }).catchError((error) {
                                print("Failed to add message: $error");
                                int h = 0;
                              });
                            } else {
                              try {
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .add(
                                  {
                                    'location_id': locRef,
                                    'start': widget.model.start,
                                    'finish': widget.model.finish,
                                    'client_id': clientRef,
                                    'master_id': masterRef,
                                  },
                                ).then((value) {
                                  setState(() {
                                    context
                                        .read<DataCubit>()
                                        .addEvents(widget.model);
                                  });
                                }).catchError((error) {
                                  print("Failed to add message: $error");
                                });
                              } catch (e) {
                                print(e);
                              }
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/ShedulerViewFuture',
                                arguments: 0);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ShedulerViewFuture',
                              arguments: 0);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/location.dart';

class LocationsSelect extends StatefulWidget {
  LocationsSelect({
    Key? key,
    required this.LocationId,
    required this.callback,
  }) : super(key: key);
  String LocationId;
  final Function(String) callback;
  @override
  _LocationsSelectState createState() => _LocationsSelectState();
}

class _LocationsSelectState extends State<LocationsSelect> {
  @override
  Widget build(BuildContext context) {
    String valueRes = widget.LocationId;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          int u = 0;
          return Container(
            height: 500,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'Локации',
                        style: txt20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        location lock = location.fromDocSnapshot(ds);

                        Color color = Color.fromARGB(
                            lock.color_s.alpha,
                            lock.color_s.red,
                            lock.color_s.green,
                            lock.color_s.blue);
                        int y = 0;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioListTile(
                            //                             int alpha = ds['color_s.alpha'];
                            // int red = ds['color_s.red'];
                            // int green = ds['color_s.green'];
                            // int blue = ds['color_s.blue'];

                            secondary: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            title: Text(
                              ds['LocationName'],
                              style: txt20,
                            ),
                            value: ds.id,
                            groupValue: widget.LocationId,
                            onChanged: (value) {
                              setState(() {
                                // groupValue = value!;
                                widget.LocationId = value!;
                                print(widget.LocationId);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    //   flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              setState(() {
                                valueRes = widget.LocationId;
                              });

                              widget.callback(valueRes);
                              Navigator.pop(context, valueRes);
                            }),
                        ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              //  widget.callback(widget.LocationId);
                              Navigator.pop(context, valueRes);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

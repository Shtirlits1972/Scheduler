import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/constants.dart';

class MasterSelect extends StatefulWidget {
  MasterSelect(
      {Key? key,
      required this.user_id,
      required this.user_role,
      required this.callback})
      : super(key: key);

  String user_id;
  String user_role;
  final Function(String) callback;
  @override
  _MasterSelectState createState() => _MasterSelectState();
}

class _MasterSelectState extends State<MasterSelect> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: widget.user_role)
          .snapshots(),
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
                    flex: 1,
                    child: Center(
                      child: Text(
                        widget.user_role,
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioListTile(
                            title: Text(
                              ds['userName'],
                              style: txt20,
                            ),
                            value: ds.id,
                            groupValue: widget.user_id,
                            onChanged: (value) {
                              setState(
                                () {
                                  // groupValue = value!;
                                  widget.user_id = value!;
                                  print(
                                      'userId: ${widget.user_id}  userName: ${ds['userName']}');
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        child: const Text('выбрать'),
                        onPressed: () {
                          widget.callback(widget.user_id);
                          Navigator.pop(context, widget.user_id);
                        }),
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

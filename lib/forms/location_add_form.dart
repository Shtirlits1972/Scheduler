import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/model/location.dart';

class LocationAddForm extends StatefulWidget {
  LocationAddForm({Key? key, required this.model}) : super(key: key);

  location model;

  @override
  _LocationAddFormState createState() => _LocationAddFormState();
}

class _LocationAddFormState extends State<LocationAddForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    nameController.text = widget.model.LocationName;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Text('Add Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name Location',
                    hintText: 'Enter name location'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        print(nameController.text);

                        if (widget.model.id.trim().isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('locations')
                              .doc(widget.model!.id)
                              .update(
                                  {'LocationName': nameController.text.trim()});
                        } else {
                          try {
                            FirebaseFirestore.instance
                                .collection('locations')
                                .add({'LocationName': nameController.text})
                                .then((value) {})
                                .catchError((error) {
                                  print("Failed to add message: $error");
                                });
                          } catch (e) {
                            print(e);
                          }
                        }

                        Navigator.pushNamed(context, '/LocationView');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/LocationView');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

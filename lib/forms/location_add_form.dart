import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/color_save.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class LocationAddForm extends StatefulWidget {
  LocationAddForm({Key? key, required this.model}) : super(key: key);

  location model;

  @override
  _LocationAddFormState createState() => _LocationAddFormState();
}

class _LocationAddFormState extends State<LocationAddForm> {
  late Color selectedColor;

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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 150,
                color: selectedColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  showColorPickerDialog(context, selectedColor).then(
                    (value) {
                      selectedColor = value;
                      setState(() {});
                    },
                  );
                },
                child: Text('Select Color', style: txt20),
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

                        widget.model.LocationName = nameController.text;

                        widget.model.color_s = color_save(
                            selectedColor.alpha,
                            selectedColor.red,
                            selectedColor.green,
                            selectedColor.blue);

                        if (widget.model.id.trim().isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('locations')
                              .doc(widget.model!.id)
                              .update(widget.model.toMap())
                              .then((value) {
                            context.read<DataCubit>().updLocation(widget.model);
                          });
                        } else {
                          try {
                            FirebaseFirestore.instance
                                .collection('locations')
                                .add(widget.model.toMap())
                                .then((value) {
                              widget.model.id = value.id;
                              context
                                  .read<DataCubit>()
                                  .addLocation(widget.model);
                            }).catchError((error) {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedColor = Color.fromARGB(
        widget.model.color_s.alpha,
        widget.model.color_s.red,
        widget.model.color_s.green,
        widget.model.color_s.blue);
  }
}

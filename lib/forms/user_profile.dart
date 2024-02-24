import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scheduler_app/auth.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Image img = Image.asset('assets/images/no_foto.jpg');
  @override
  Widget build(BuildContext context) {
    TextEditingController passController = TextEditingController();
    TextEditingController displayNameController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'User profile',
          style: txt20,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DataCubit, Keeper>(
        builder: (context, state) {
          passController.text = context.read<DataCubit>().getUser.password;
          displayNameController.text =
              context.read<DataCubit>().getUser.userName;

          int h = 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: displayNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'DisplayName',
                        hintText: 'Enter your display name'),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: img,
                  onTap: () {
                    FilePicker.platform
                        .pickFiles(type: FileType.image)
                        .then((value) {
                      if (value != null && value.count > 0) {
                        setState(() {
                          String fileName = value!.files.single.path!.substring(
                              value!.files.single.path!.lastIndexOf('/'));
                          print(fileName);
                          img = Image.file(File(value!.files.single.path!));
                        });
                      } else {
                        print('Canceled');
                      }
                    });
                  },
                ),

                // getUserImage(context.read<DataCubit>().getUser.fotoUrl),
              ),

              //   кнопки
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        height: 50,
                        child: ElevatedButton(
                          child: Text(
                            'Сохранить',
                            style: txt20,
                          ),
                          onPressed: () {
                            print(
                                ' Password: ${passController.text}, Dysplay Name : ${displayNameController.text}');
                            try {
                              print(context.read<DataCubit>().getUser.id);

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(context.read<DataCubit>().getUser.id)
                                  .update(
                                {
                                  'userName': displayNameController.text.trim(),
                                  'password': passController.text.trim()
                                },
                              );

                              context.read<DataCubit>().setCurrentUser(
                                  context.read<DataCubit>().getUser);
                            } catch (e) {
                              print(e);
                              showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Warning!'),
                                  content: Text(e.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomBarGeneral(
        selectedIndex: widget.selectedIndex,
        IsAdmin: context.read<DataCubit>().getUser.IsAdmin(),
      ),
    );
  }

  Center getUserImage(String fotoUrl) {
    Widget imgWidget = Image.asset('assets/images/no_foto.jpg');

    if (fotoUrl.trim().isNotEmpty) {
      imgWidget = Image.network(fotoUrl);
    }

    // if (fotoUrl.trim().isNotEmpty) {
    return Center(
      child: GestureDetector(
        child: imgWidget,
        onTap: () async {
          print('tap image');

          String ext = '.jpg';
          // Create a storage reference from our app
          final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
          // final mountainsRef =
          //     storageRef.child(context.read<DataCubit>().getUser.id + ext);

          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.image);

          if (result != null) {
            File file = File(result.files.single.path!);
            print(file.path);
            int y = 0;

            setState(() {
              imgWidget = Text(file.path);
            });
          } else {
            // User canceled the picker
          }

// // Create a reference to 'images/mountains.jpg'
//           final mountainImagesRef = storageRef.child("users/$mountainsRef");

          //   Directory appDocDir = await

          // getDownloadsDirectory().then((value) {
          //   print(value);
          //   int y = 0;
          // });

          // String filePath = '${appDocDir.absolute}/file-to-upload.png';
          // io.File file = io.File(filePath);
        },
      ),
    );
  }
}

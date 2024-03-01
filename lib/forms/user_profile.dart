import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  Widget imgNoFoto = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Image.asset(
      'assets/images/no_foto.jpg',
      height: 250,
    ),
  );

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

          Widget widgFoto =
              getUserImage(context.read<DataCubit>().getUser.fotoUrl);

          int h = 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: widgFoto,
              ),
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
    if (fotoUrl.trim().isNotEmpty) {
      String url = fotoUrl;
      return Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.network(url),
            ),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: Text('Удалить фото'),
                  onPressed: () async {
                    print('delete foto');

                    try {
                      await FirebaseStorage.instance
                          .refFromURL(context.read<DataCubit>().getUser.fotoUrl)
                          .delete();
                      //     .whenComplete(() {

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Фото удалено!')));
                      //   print('foto deleted');
                      // }).catchError((err) {
                      //   print(err);
                      // });

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(context.read<DataCubit>().getUser.id)
                          .update(
                        {
                          'fotoUrl': '',
                        },
                      );

                      imgNoFoto = Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/no_foto.jpg',
                          height: 250,
                        ),
                      );

                      setState(() {
                        context.read<DataCubit>().getUser.fotoUrl = '';
                        url = '';
                      });
                      // })
                      // .catchError((Error2) {
                      //   print(Error2);
                      // });
                    } on FirebaseException catch (e) {
                      print('FirebaseException ${e.message}');
                      int h = 0;
                    } catch (e1) {
                      print(e1);
                    }
                  },
                ))
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 200,
                child: imgNoFoto,
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print('upload pressed');

                  FilePicker.platform
                      .pickFiles(
                    type: FileType.any,
                    dialogTitle: 'выберите фото',
                  )
                      .then((value) {
                    if (value != null && value.count > 0) {
                      setState(() async {
                        String fileName = value!.files.single.path!.substring(
                            value!.files.single.path!.lastIndexOf('/') + 1);
                        print(fileName);
                        imgNoFoto = Image.file(File(value!.files.single.path!));

                        if (fileName.trim().isNotEmpty) {
                          bool? flag = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Внимание!'),
                              content: Text('Загрузить фото?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    'OK',
                                    style: txt15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: txt15,
                                  ),
                                ),
                              ],
                            ),
                          );

                          print(flag);

                          if (flag!) {
                            try {
                              Reference firebaseStorageRef =
                                  FirebaseStorage.instance.ref().child(
                                      "users_image/${context.read<DataCubit>().getUser.id}/$fileName");
                              int y1 = 0;

                              UploadTask uploadTask =
                                  firebaseStorageRef.putFile(
                                File(value!.files.single.path!),
                              );
                              TaskSnapshot taskSnapshot =
                                  await uploadTask.whenComplete(() {
                                print('uploaded');
                              });
                              int y2 = 0;
                              String imageUrl =
                                  await taskSnapshot.ref.getDownloadURL();
                              int y3 = 0;
                              print('Изображение загружено. URL: $imageUrl');

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(context.read<DataCubit>().getUser.id)
                                  .update(
                                {
                                  'fotoUrl': imageUrl.trim(),
                                },
                              ).catchError((Error2) {
                                print(Error2);
                              }).whenComplete(() {
                                setState(() {
                                  context.read<DataCubit>().getUser.fotoUrl =
                                      imageUrl;
                                });
                              });
                            } on FirebaseException catch (e) {
                              print('FirebaseException ${e.message}');
                              int h = 0;
                            } catch (err2) {
                              print(err2);
                            }
                          }
                        }
                      });
                    } else {
                      print('Canceled');
                    }
                  });
                },
                child: Text(
                  'upload foto',
                  style: txt15,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

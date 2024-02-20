import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'DisplayName',
                      hintText: 'Enter your display name'),
                ),
              ),
              Row(
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
                                .update({
                              'userName': displayNameController.text.trim(),
                              'password': passController.text.trim()
                            });

                            // Auth.SavePasswordAndDysplayName(passController.text,
                            //     displayNameController.text);

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
}

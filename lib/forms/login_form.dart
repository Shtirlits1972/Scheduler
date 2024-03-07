import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/forms/scheduler_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler_app/model/auth_result.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/users.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  final String route = '/';
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passController = TextEditingController();

    loginController.text = 'admin@mail.ru';
    passController.text = '1234567';

    return Scaffold(
      body: BlocBuilder<DataCubit, Keeper>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: loginController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid mail id as abc@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your secure password'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        height: 50,
                        child: ElevatedButton(
                          child: Text(
                            'Login',
                            style: txt20,
                          ),
                          onPressed: () async {
                            print(
                                'Login: ${loginController.text}, Password: ${passController.text}');

                            try {
                              QuerySnapshot<Map<String, dynamic>> snapshot =
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .where("email",
                                          isEqualTo: loginController.text)
                                      .where("password",
                                          isEqualTo: passController.text)
                                      .where("IsApproved", isEqualTo: true)
                                      .limit(1)
                                      .get();

                              if (FirebaseAuth.instance.currentUser != null) {
                                await FirebaseAuth.instance.signOut();
                              }

                              // var userCred = await FirebaseAuth.instance
                              //     .signInWithEmailAndPassword(
                              //         email: loginController.text,
                              //         password: passController.text);

                              // print(userCred);
                              // int g = 0;

                              if (snapshot.size > 0) {
                                users userAvtorize =
                                    users.fromQuerySnapshot(snapshot);

                                print(userAvtorize);

                                setState(() {
                                  context
                                      .read<DataCubit>()
                                      .setCurrentUser(userAvtorize);

                                  Navigator.pushNamed(
                                      context, '/ShedulerViewFuture',
                                      arguments: 0);
                                });
                              } else {
                                showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Autorization Error!'),
                                    content: Text('Invalid email or password!'),
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
                              }
                            } on Exception catch (e) {
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
                                      child: Text(
                                        'OK',
                                        style: txt30,
                                      ),
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
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/RegisterForm');
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ],
              //  );
            ),
          );
        },
      ),
    );
  }
}

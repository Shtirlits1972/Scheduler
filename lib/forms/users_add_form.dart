import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/check_box_widget.dart';
import 'package:scheduler_app/widgets/show_dialog_role.dart';

class UsersAddForm extends StatefulWidget {
  UsersAddForm({Key? key, required this.model}) : super(key: key);
  users model;
  @override
  _UsersAddFormState createState() => _UsersAddFormState();
}

class _UsersAddFormState extends State<UsersAddForm> {
  bool IsApproved = true;
  String role = 'client';

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController userNameController = TextEditingController();

    emailController.text = widget.model.email;
    passwordController.text = widget.model.password;
    userNameController.text = widget.model.userName;
    IsApproved = widget.model.IsApproved;
    role = widget.model.role;

    void _showDialog() {
      String groupValue = widget.model.role;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return ShowDialogRole(
              role: groupValue,
            );
          }));
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            role = value;
            widget.model.role = value!;
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'User',
          style: txt20,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    widget.model.email = value;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                      hintText: 'Enter E-mail'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    widget.model.password = value;
                  },
                  controller: passwordController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    widget.model.userName = value;
                  },
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Dysplay Name',
                      hintText: 'Enter User Name'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 50),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: Text(
                  'role: ${widget.model.role}',
                  style: txt30,
                ),
                onPressed: () {
                  _showDialog();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CheckBoxWidget(
                  callback: (value) => IsApproved = value,
                  isChecked: widget.model.IsApproved,
                  text: 'IsApproved',
                ),
              ),
            ),
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
                        child: Text(
                          'OK',
                          style: txt15,
                        ),
                        onPressed: () {
                          String Error = '';

                          if (emailController.text.trim().isEmpty) {
                            Error += "E-mail is empty!  \r\n";
                          }

                          if (passwordController.text.trim().isEmpty) {
                            Error += "Password is empty!  \r\n";
                          }

                          if (userNameController.text.trim().isEmpty) {
                            Error += "User Name is empty!  \r\n";
                          }

                          if (Error.trim().isNotEmpty) {
                            showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error!'),
                                content: Text(Error),
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

                          widget.model.email = emailController.text;
                          widget.model.password = passwordController.text;
                          widget.model.userName = userNameController.text;
                          widget.model.IsApproved = IsApproved;
                          print(widget.model);

                          if (widget.model.id.trim().isNotEmpty) {
                            print(widget.model);
                            print('User update');

                            try {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.model.id)
                                  .update({
                                'email': emailController.text.trim(),
                                'password': passwordController.text.trim(),
                                'userName': userNameController.text.trim(),
                                'role': widget.model.role,
                                'IsApproved': IsApproved,
                              });

                              Navigator.pushNamed(context, '/UsersView',
                                  arguments: 3);
                            } on Exception catch (e) {
                              print(e);
                            }
                          } else {
                            print(widget.model);
                            print('user added');
                            try {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .add({
                                    'email': emailController.text.trim(),
                                    'password': passwordController.text.trim(),
                                    'userName': userNameController.text.trim(),
                                    'role': widget.model.role,
                                    'IsApproved': IsApproved,
                                  })
                                  .then((value) {})
                                  .catchError((error) {
                                    print("Failed to add message: $error");
                                  });
                              Navigator.pushNamed(context, '/UsersView',
                                  arguments: 3);
                            } on Exception catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        child: Text(
                          'Cancel',
                          style: txt15,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/UsersView',
                              arguments: 3);
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

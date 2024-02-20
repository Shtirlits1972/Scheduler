import 'package:flutter/material.dart';
import 'package:scheduler_app/auth.dart';
import 'package:scheduler_app/constants.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  final String route = 'RegisterForm';

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController displayNameController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            appName,
            style: TextStyle(fontSize: 40),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        'Зарегистрироватся',
                        style: txt20,
                      ),
                      onPressed: () async {
                        print(
                            'Login: ${loginController.text}, Password: ${passController.text}');
                        try {
                          Auth.registerEmailAndPassword(
                                  loginController.text,
                                  passController.text,
                                  displayNameController.text)
                              .then((value) {
                            if (value!.email != loginController.text) {
                              print('Register Error');
                            } else {
                              print(value);
                            }
                          });
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
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text(
                'Логин',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
          ],
        ));
  }
}

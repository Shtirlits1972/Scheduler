import 'package:flutter/material.dart';

class ShowDialogRole extends StatefulWidget {
  ShowDialogRole({Key? key, required this.role}) : super(key: key);

  String role;
  @override
  _ShowDialogRoleState createState() => _ShowDialogRoleState();
}

class _ShowDialogRoleState extends State<ShowDialogRole> {
  String dropdownvalue = 'client';
  // List of items in our dropdown menu
  var items = [
    'client',
    'master',
    'admin',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton(
          // Initial Value
          value: dropdownvalue,

          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context, dropdownvalue);
            },
            child: const Text("Ok"))
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownvalue = widget.role;
  }
}

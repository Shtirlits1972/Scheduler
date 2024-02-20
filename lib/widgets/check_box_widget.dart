import 'package:flutter/material.dart';
import 'package:scheduler_app/constants.dart';

class CheckBoxWidget extends StatefulWidget {
  final Function(bool) callback;
  CheckBoxWidget(
      {super.key,
      required this.callback,
      required this.isChecked,
      required this.text});

  bool isChecked;
  final text;
  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
            value: widget.isChecked,
            onChanged: (value) {
              widget.callback(value!);
              setState(() => widget.isChecked = !widget.isChecked);
            }),
        Text(
          widget.text,
          style: txt20,
        )
      ],
    );
  }
}

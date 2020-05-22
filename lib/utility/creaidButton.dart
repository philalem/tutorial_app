import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({this.label, this.onPressed});
  final Function onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

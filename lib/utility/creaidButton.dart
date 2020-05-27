import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({this.onPressed, this.children});
  Function onPressed;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: children,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

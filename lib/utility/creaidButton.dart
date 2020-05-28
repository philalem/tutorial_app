import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({this.onPressed, this.children, this.disabled: false});
  Function onPressed;
  bool disabled;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: disabled ? null : onPressed,
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

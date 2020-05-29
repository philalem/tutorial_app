import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({
    this.onPressed,
    this.children,
    this.disabled: false,
    this.shrink: false,
  });
  List<Widget> children;
  Function onPressed;
  bool disabled;
  bool shrink;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: disabled ? null : onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
        mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({
    this.onPressed,
    this.children,
    this.disabled: false,
    this.shrink: false,
    this.color: Colors.indigo,
  });
  List<Widget> children;
  Function onPressed;
  bool disabled;
  bool shrink;
  Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      onPressed: disabled ? null : onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
          mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
        ),
      ),
    );
  }
}

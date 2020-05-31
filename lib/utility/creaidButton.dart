import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({
    this.onPressed,
    this.children,
    this.disabled: false,
    this.shrink: false,
    this.color: Colors.indigo,
    this.padding: 10,
  });
  List<Widget> children;
  Function onPressed;
  bool disabled;
  bool shrink;
  Color color;
  double padding;

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
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
          mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
        ),
      ),
    );
  }
}

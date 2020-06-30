import 'package:flutter/material.dart';

class CreaidButton extends StatelessWidget {
  CreaidButton({
    this.onPressed,
    this.children,
    this.disabled: false,
    this.shrink: false,
    this.color: Colors.indigo,
    this.padding: 10,
    this.filled: true,
  });
  final List<Widget> children;
  final Function onPressed;
  final bool disabled;
  final bool shrink;
  final Color color;
  final double padding;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: filled ? color : Colors.white,
      onPressed: disabled ? null : onPressed,
      textColor: filled ? Colors.white : color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: color),
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

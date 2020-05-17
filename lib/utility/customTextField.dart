import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onChanged});
  final FormFieldSetter<String> onChanged;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          hintText: hint,
          prefixIcon: Padding(
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).primaryColor),
              child: icon,
            ),
            padding: EdgeInsets.only(left: 0, right: 0),
          ),
        ),
      ),
    );
  }
}

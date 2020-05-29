import 'package:flutter/material.dart';

class CreaidTextField extends StatelessWidget {
  CreaidTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onChanged,
      this.controller});
  final FormFieldSetter<String> onChanged;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller != null ? controller : TextEditingController(),
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
        prefixIcon: icon != null
            ? Padding(
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).primaryColor),
                  child: icon,
                ),
                padding: EdgeInsets.only(left: 0, right: 0),
              )
            : null,
      ),
    );
  }
}

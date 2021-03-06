import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:flutter/material.dart';

class CreateUsername extends StatefulWidget {
  @required
  final TextEditingController controller;
  final String username;
  final Function enableForm;
  final Function disableForm;

  CreateUsername(
      {this.username, this.enableForm, this.disableForm, this.controller});

  @override
  _CreateUsername createState() => _CreateUsername();
}

class _CreateUsername extends State<CreateUsername> {
  final AlgoliaService algoliaService = AlgoliaService();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Create a username',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        CreaidTextField(
          hint: 'Enter a username',
          validator: (val) => val.isEmpty ? 'Enter a username' : null,
          controller: widget.controller,
          onChanged: (value) async {
            bool isMatch =
                await algoliaService.isThereAnExactUsernameMatch(value);
            if (isMatch) {
              widget.disableForm();
              error = 'Sorry, this username is taken already. Try another.';
            } else if (value == '') {
              widget.disableForm();
              error = 'Please enter a username';
            } else {
              widget.enableForm();
              error = '';
            }
            setState(() {});
          },
        ),
        Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        )
      ],
    );
  }
}

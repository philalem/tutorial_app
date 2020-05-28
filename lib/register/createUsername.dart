import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/firebaseAuth.dart';
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
  final FireBaseAuthorization _auth = FireBaseAuthorization();

  String error = '';
  var interests = new List<String>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Text(
            'Create a username',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          TextFormField(
              validator: (val) => val.isEmpty ? 'Enter a valid interest' : null,
              controller: widget.controller,
              onChanged: (value) async {
                bool isMatch =
                    await algoliaService.isThereAnExactUsernameMatch(value);
                if (isMatch) {
                  setState(() {
                    widget.disableForm();
                    error = 'Can not register this username. Try another.';
                  });
                } else {
                  setState(() {
                    widget.enableForm();
                    error = '';
                  });
                }
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                hintText: 'Username',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                prefixIcon: Padding(
                  child: IconTheme(
                    data: IconThemeData(color: Theme.of(context).primaryColor),
                    child: Icon(Icons.alarm),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 10),
                ),
              )),
          SizedBox(height: 12.0),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          )
        ],
      ),
    );
  }
}

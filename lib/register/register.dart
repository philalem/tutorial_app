import 'package:creaid/utility/customTextField.dart';
import 'package:creaid/register/interestsSignUp.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text('Creaid'),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign in'),
              onPressed: () {
                widget.toggleView();
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  'Signup for your Creaid acount:',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                CustomTextField(
                  icon: Icon(Icons.person),
                  obsecure: false,
                  onChanged: (input) => name = input,
                  validator: (input) =>
                      input.isEmpty ? "Need to enter a name" : null,
                  hint: "Name",
                ),
                SizedBox(height: 20.0),
                CustomTextField(
                  icon: Icon(Icons.email),
                  obsecure: false,
                  onChanged: (input) => email = input,
                  validator: (input) =>
                      input.isEmpty ? "Need to enter a valid email" : null,
                  hint: "Email",
                ),
                SizedBox(height: 20.0),
                CustomTextField(
                  icon: Icon(Icons.panorama_fish_eye),
                  obsecure: false,
                  onChanged: (input) => password = input,
                  validator: (input) => input.length < 7
                      ? "Need to enter a password with a length longer then 6"
                      : null,
                  hint: "Password",
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InterestsSignUp(
                                  email: email,
                                  name: name,
                                  password: password)),
                        );
                      }
                    }),
              ]))),
    );
  }
}

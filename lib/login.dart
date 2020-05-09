
import 'package:creaid/customTextField.dart';
import 'package:creaid/firebaseAuth.dart';
import 'package:flutter/material.dart';
import 'package:creaid/home.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({this.toggleView});


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final FireBaseAuthorization _auth = FireBaseAuthorization();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0.0,
        title: Text('Creaid'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Login to your Creaid acount:',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CustomTextField(
                icon: Icon(Icons.email),
                obsecure: false,
                onChanged: (input) => email = input,
                validator: (input) => input.isEmpty ? "Need to enter a valid email" : null,
                hint: "Email",
              ),
              SizedBox(height: 20.0),
              CustomTextField(
                icon: Icon(Icons.panorama_fish_eye),
                obsecure: true,
                onChanged: (input) => password = input,
                validator: (input) => input.length<6 ? "Need to enter a password with length greater then 6" : null,
                hint: "Password",
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    dynamic res = await _auth.signInWithEmailAndPassword(email, password);

                    if (res == null) {
                      setState(() {
                        error = 'Could not sign in with those credentials';
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    }
                  }
                }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ]
          )
        )
      ),
    );
  }
}
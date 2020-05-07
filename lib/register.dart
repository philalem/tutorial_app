import 'package:creaid/firebaseAuth.dart';
import 'package:creaid/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final FireBaseAuthorization _auth = FireBaseAuthorization();

  String email = '';
  String password = '';
  String name = '';
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
            label: Text('Sign in'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Signup for your Creaid acount:',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Name',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black12,
                  fontSize: 10.0
                  ),
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter a valid name' : null,
                onChanged: (val) {
                  setState(() => name = val);
                }
              ),
              SizedBox(height: 20.0),
              Text(
                'Email',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black12,
                  fontSize: 10.0
                  ),
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter a valid email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              Text(
                'Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black12,
                  fontSize: 10.0
                  ),
              ),
              TextFormField(
                validator: (val) => val.length<6 ? 'Enter a valid password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },

              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic res = await _auth.registerWithEmailAndPassword(email, password);

                    if(res == null) {
                      setState(() {
                        error = 'Can not register this user';
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
                style: TextStyle(
                  color: Colors.red, fontSize: 14.0
                ),
              )
            ]
          )
        )
      ),
    );
  }
}
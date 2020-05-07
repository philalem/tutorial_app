
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
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                validator: (val) => val.isEmpty ? "Need to enter an email" : null,
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
                validator: (val) => val.isEmpty ? "Need to enter a password" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },

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
import 'package:creaid/login/login.dart';
import 'package:creaid/register/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signIn = true;

  void toggleView() {
    setState(() => signIn = !signIn);
  }

  @override
  Widget build(BuildContext context) {
    if (signIn) {
      return Register(toggleView: toggleView);
    } else {
      return Login(toggleView: toggleView);
    }
  }
}

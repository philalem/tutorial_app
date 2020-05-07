import 'package:creaid/authenticate.dart';
//import 'package:creaid/login.dart';
import 'package:flutter/material.dart';
//import 'package:creaid/home.dart';

void main() => runApp(CreaidApp());

class CreaidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creaid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }
}

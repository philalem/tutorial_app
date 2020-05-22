import 'package:creaid/utility/authenticate.dart';
import 'package:flutter/material.dart';

void main() => runApp(CreaidApp());

class CreaidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creaid',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        buttonColor: Colors.indigo,
      ),
      home: Authenticate(),
    );
  }
}

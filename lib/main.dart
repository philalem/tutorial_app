import 'package:flutter/material.dart';
import 'package:tutorial_app/camerascreen/camera_screen.dart';
import 'package:tutorial_app/create.dart';
import 'package:tutorial_app/home.dart';

void main() => runApp(CreaidApp());

class CreaidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

import 'package:creaid/home.dart';
import 'package:creaid/utility/authenticate.dart';
import 'package:creaid/utility/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Authenticate();
  }
}
import 'package:creaid/home.dart';
import 'package:creaid/utility/authenticate.dart';
import 'package:creaid/utility/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
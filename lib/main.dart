import 'package:creaid/utility/authenticate.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(CreaidApp());

class CreaidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: FireBaseAuthorization().user,
      child: MaterialApp(
        title: 'Creaid',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Wrapper(),
      )
    );
  }
}

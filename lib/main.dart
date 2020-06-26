import 'package:creaid/utility/firebaseAuth.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(CreaidApp());

class CreaidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: FireBaseAuthorization().user,
      child: CupertinoApp(
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        title: "Creaid",
        theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.indigo,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

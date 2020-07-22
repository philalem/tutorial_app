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
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: CupertinoApp(
          localizationsDelegates: [
            DefaultMaterialLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          ),
          title: "Creaid",
          theme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.indigo,
            textTheme: CupertinoTextThemeData(
              primaryColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

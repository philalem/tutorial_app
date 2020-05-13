import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  FireBaseAuthorization auth = new FireBaseAuthorization();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget old) {
    return true;
  }

  static Provider of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<Provider>());

}
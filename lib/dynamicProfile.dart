import 'package:creaid/profile.dart';
import 'package:creaid/userList.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class DynamicProfile extends StatefulWidget {
  @override
  _DynamicProfileState createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicProfile> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: UserDbService(uuid: user.uuid).getNames(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData data = snapshot.data;

          return Container(
            child: Text(
              data.name,
            )
          );
        }
        else{
          return new CircularProgressIndicator();
        }
      },
    );
  }


}
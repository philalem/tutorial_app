import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<QuerySnapshot>(context);

    for(var u in user.documents){
      print(u.data);
    }

    return Container(
      
    );
  }
}
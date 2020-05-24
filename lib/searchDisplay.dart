import 'package:creaid/notifications.dart';
import 'package:flutter/material.dart';

class SearchDisplay extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  TextEditingController searchTextController;
  SearchDisplay({this.navigatorKey, this.searchTextController});

  @override
  createState() => _SearchDisplayState();
}

class _SearchDisplayState extends State<SearchDisplay> {
  static List<String> mainDataList = [
    "Apple",
    "Apricot",
    "Banana",
    "Blackberry",
    "Coconut",
    "Date",
    "Fig",
    "Gooseberry",
    "Grapes",
    "Lemon",
    "Litchi",
    "Mango",
    "Orange",
    "Papaya",
    "Peach",
    "Pineapple",
    "Pomegranate",
    "Starfruit"
  ];
  List<String> filteredList = [];

  @override
  void initState() {
    widget.searchTextController.addListener(() {
      var text = widget.searchTextController.text;
      text != '' ? searchList(text) : filteredList = [];
      setState(() {});
    });
    super.initState();
  }

  void searchList(text) {
    setState(() {
      filteredList = mainDataList
          .where((element) => element.toLowerCase().contains(text))
          .take(5)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: filteredList.map((data) {
        return InkWell(
          child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(data),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

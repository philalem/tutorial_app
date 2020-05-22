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
  List<String> filteredList = List.from(mainDataList);

  @override
  void initState() {
    widget.searchTextController.addListener(() {
      searchList(widget.searchTextController.text);
      setState(() {});
    });
    super.initState();
  }

  void searchList(text) {
    setState(() {
      filteredList = mainDataList
          .where((element) => element.toLowerCase().contains(text))
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
                widget.navigatorKey.currentState.pushNamed('/profile');
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

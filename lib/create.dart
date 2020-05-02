import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  @override
  createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Text(
                      'Step 1',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: RaisedButton(
                      child: Text('Press Me!'),
                      onPressed: () {
                        print('Pressed');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

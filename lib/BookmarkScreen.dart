import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookmarkScreen();
  }

}
class _BookmarkScreen extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
        ListTile(
          leading: Icon(Icons.photo_album),
          title: Text('Album'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
        ),
      ],
    );
  }

}
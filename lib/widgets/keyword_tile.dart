import 'package:flutter/material.dart';

class KeywordTile extends StatefulWidget {
  final String keyword;

  const KeywordTile({Key key, this.keyword}) : super(key: key);

  @override
  _KeywordTileState createState() => _KeywordTileState();
}

class _KeywordTileState extends State<KeywordTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      child: Card(child: Center(child: Text(widget.keyword))),
    );
  }
}

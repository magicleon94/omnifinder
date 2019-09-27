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
    return FractionallySizedBox(
      widthFactor: 100,
      child: Container(
        height: 84,
        child: Text(widget.keyword),
      ),
    );
  }
}

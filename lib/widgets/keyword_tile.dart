import 'package:flutter/material.dart';

class KeywordTile extends StatelessWidget {
  final String keyword;
  final int index;
  final Function() onEdit;
  final Function() onDelete;

  const KeywordTile({
    Key key,
    @required this.keyword,
    this.index,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => onDelete(),
      direction: DismissDirection.endToStart,
      key: Key(index.toString()),
      background: SizedBox.expand(
        child: Container(
          color: Colors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.delete_sweep,
                  size: 28,
                )
              ],
            ),
          ),
        ),
      ),
      child: Container(
        height: 84,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Text(
                keyword,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit),
              ),
            )
          ],
        ),
      ),
    );
  }
}

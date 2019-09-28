import 'package:flutter/material.dart';

class KeywordInputScreen extends StatefulWidget {
  final String initialValue;

  const KeywordInputScreen({
    Key key,
    this.initialValue,
  }) : super(key: key);

  @override
  _KeywordInputScreenState createState() => _KeywordInputScreenState();
}

class _KeywordInputScreenState extends State<KeywordInputScreen> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController =
        TextEditingController(text: widget.initialValue ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: Navigator.of(context).pop,
        child: Align(
          alignment: Alignment.center,
          child: Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: "Keyword",
                      ),
                      onSubmitted: Navigator.of(context).pop,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(_textEditingController.text);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

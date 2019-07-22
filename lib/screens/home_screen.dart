import 'package:flutter/material.dart';
import 'package:omnifinder/Screens/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _submitForm(String value) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          keywords: [value],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(hintText: "Keyword"),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: _submitForm),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        _submitForm(_textController.text);
                      },
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

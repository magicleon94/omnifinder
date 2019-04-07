import 'package:flutter/material.dart';
import 'package:omnifinder/Screens/CameraScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Keyword"),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(
                        keywords: [value],
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

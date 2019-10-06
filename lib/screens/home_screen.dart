import 'package:flutter/material.dart';
import 'package:omnifinder/models/keywords_container.dart';
import 'package:omnifinder/routing/route_arguments/camera_screen_route_arguments.dart';
import 'package:omnifinder/routing/route_arguments/keyword_input_route_arguments.dart';
import 'package:omnifinder/routing/route_parameters.dart';
import 'package:omnifinder/routing/routes.dart';
import 'package:omnifinder/widgets/keyword_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textController = TextEditingController();
  GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  List<String> keywords = [];

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _startSearch() {
    if (keywords.isNotEmpty) {
      Navigator.of(context).pushNamed(
        Routes.CAMERA,
        arguments: RouteParameters(
          routeArguments: CameraScreenRouteArguments(
            keywordsContainer: KeywordsContainer(
              keywords: keywords,
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("You have to add at least one keyword!"),
        ),
      );
    }
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Coming soon!"),
      ),
    );
  }

  void _editKeyword(int index) async {
    String currentValue = keywords[index];
    var newValue = await Navigator.of(context).pushNamed(
      Routes.KEYWORD_INPUT,
      arguments: RouteParameters(
        routeArguments: KeywordInputRouteArguments(
          initialValue: currentValue,
        ),
      ),
    ) as String;

    if ((newValue?.trim()?.length ?? 0) == 0) {
      _removeKeyword(
        index,
        fromForm: true,
      );
    } else {
      keywords[index] = newValue;
    }
    _animatedListKey.currentState.reassemble();
  }

  void _addKeyword() async {
    var value = await Navigator.of(context).pushNamed(
      Routes.KEYWORD_INPUT,
    ) as String;
    if ((value?.trim()?.length ?? 0) > 0) {
      keywords.add(value);
      _animatedListKey.currentState.insertItem(
        keywords.length - 1,
      );
    }
  }

  void _removeKeyword(int index, {bool fromForm}) {
    keywords.removeAt(index);

    _animatedListKey.currentState.removeItem(
      index,
      (context, animation) {
        if (!(fromForm ?? false)) {
          return SizedBox.shrink();
        } else {
          Animation<double> fadeAnimation = Tween<double>(
            begin: 1,
            end: 0,
          ).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: KeywordTile(
              onEdit: () => _editKeyword(index),
              onDelete: () => _removeKeyword(index),
              index: index,
              keyword: keywords[index],
            ),
          );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation animation) {
    Animation<double> fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animation);

    return FadeTransition(
      opacity: fadeAnimation,
      child: KeywordTile(
        onEdit: () => _editKeyword(index),
        onDelete: () => _removeKeyword(index),
        index: index,
        keyword: keywords[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Omnifinder"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _startSearch,
        child: Icon(
          Icons.camera,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "What do you want to search?",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: AnimatedList(
              key: _animatedListKey,
              initialItemCount: keywords.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index, animation) {
                return _buildItem(context, index, animation);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BottomItem(
                icon: Icons.add,
                text: "Add keyword",
                onTap: _addKeyword,
              ),
              BottomItem(
                icon: Icons.history,
                text: "Recent keywords",
                onTap: _showHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final String text;

  const BottomItem({
    Key key,
    this.icon,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          if (text?.isNotEmpty ?? false) Text(text)
        ],
      ),
    );
  }
}

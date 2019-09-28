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
  }

  void _addKeyword([String existingValue, int existingIndex]) async {
    var value = await Navigator.of(context).pushNamed(
      Routes.KEYWORD_INPUT,
      arguments: RouteParameters(
        routeArguments: KeywordInputRouteArguments(
          initialValue: existingValue,
        ),
      ),
    ) as String;

    if (existingValue == null) {
      if ((value?.trim()?.length ?? 0) > 0) {
        keywords.add(value);
        _animatedListKey.currentState.insertItem(
          keywords.length - 1,
        );
      }
    } else if (existingIndex != null) {
      if ((value?.trim()?.length ?? 0) == 0) {
        _removeKeyword(
          existingIndex,
          fromForm: true,
        );
      }
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
          Animation<Offset> slideUpAnimation = Tween<Offset>(
            begin: Offset.zero,
            end: Offset(1, 0),
          ).animate(animation);

          return SlideTransition(
            position: slideUpAnimation,
            child: Dismissible(
              onDismissed: (_) => _removeKeyword(index),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _addKeyword(keywords[index]),
                child: KeywordTile(
                  keyword: keywords[index],
                ),
              ),
              key: Key(index.toString()),
            ),
          );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation animation) {
    Animation<Offset> slideUpAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(animation);

    return SlideTransition(
      position: slideUpAnimation,
      child: Dismissible(
        onDismissed: (_) => _removeKeyword(index),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _addKeyword(keywords[index]),
          child: KeywordTile(
            keyword: keywords[index],
          ),
        ),
        key: Key(index.toString()),
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please select the keywords you want to look up",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: AnimatedList(
                key: _animatedListKey,
                initialItemCount: keywords.length + 1,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  if (index == keywords.length) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: FloatingActionButton(
                        onPressed: _addKeyword,
                        child: Icon(Icons.add),
                        mini: true,
                      ),
                    );
                  } else {
                    return _buildItem(context, index, animation);
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: _startSearch,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  child: Text("Search"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

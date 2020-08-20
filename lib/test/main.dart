import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RedditPost.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body: RedditSlider()),
    );
  }
}

class RedditSlider extends StatefulWidget {
  RedditSlider({Key key}) : super(key: key);

  @override
  _RedditSliderState createState() => _RedditSliderState();
}

class _RedditSliderState extends State<RedditSlider> {
  final PageController ctrl = PageController(viewportFraction: 0.80);
  int currentPage = 0;
  String activeSubreddit = 'foodporn';
  List<RedditPost> slideList = [];

  _fetchImages() async {
    print("Fetch");
    List<RedditPost> list = [];
    final response = await http
        .get('https://www.reddit.com/r/$activeSubreddit/.json?limit=15');
    print(response.statusCode);
    print("OI");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      for (Map d in data['data']['children']) {
        if (d['data']['url'].toString().contains('jpg')) {
          RedditPost post = RedditPost.fromJson(d['data']);
          print(post.imgUrl);
          list.add(post);
        }
      }
      setState(() {
        slideList = list;
      });
    } else {
      throw Exception("Failed to load reddit.");
    }
  }

  @override
  void initState() {
    _fetchImages();
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  _buildButton(subreddit) {
    Color color = subreddit == activeSubreddit
        ? Theme.of(context).primaryColor
        : Colors.white;
    Color textColor = !(subreddit == activeSubreddit)
        ? Theme.of(context).primaryColor
        : Colors.white;
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      onPressed: () {
        setState(() {
          activeSubreddit = subreddit;
          _fetchImages();
        });
      },
      color: color,
      child: Text(
        '/r/$subreddit',
        style: TextStyle(color: textColor),
      ),
    );
  }

  _buildSubredditPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SubReddit',
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        Text(
          'Choose',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        _buildButton('earthporn'),
        _buildButton('foodporn'),
        _buildButton('nocontextpics')
      ],
    );
  }

  _buildPicPage(RedditPost post, active) {
    final double topMargin = active ? 100 : 200;
    final double offset = active ? 20 : 0;
    final double blur = active ? 100 : 200;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
      margin: EdgeInsets.only(top: topMargin, bottom: 30, right: 15),
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            child: Center(
                child: Text(
                  post.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                )),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Colors.black.withAlpha(100)),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.black87,
          image: DecorationImage(image: NetworkImage(post.imgUrl), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                offset: Offset(offset, offset),
                blurRadius: blur)
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: PageView.builder(
        controller: ctrl,
        itemCount: slideList.length + 1,
        itemBuilder: (context, int currentIndex) {
          if (currentIndex == 0) {
            return _buildSubredditPage();
          } else {
            bool active = currentIndex == currentPage;
            return _buildPicPage(slideList[currentIndex - 1], active);
          }
        },
      ),
    );
  }
}
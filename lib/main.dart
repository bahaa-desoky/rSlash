import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(new MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      title: 'rSlash',
      home: new HomePage(title: 'Posts'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}


// The homepage that users see when the app is launched.
// Contains: Welcome message and the top stories of the day from r/WritingPrompts and r/nosleep
class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  var fontColor = Color(0xFFe8e7e0);
  List colors = [Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff),Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff)];
  Random random = new Random();

  PageController _pageController = PageController(initialPage: 0);

  // Future that retrieves post json data from custom-made API
  Future<List<Post>> _getStories() async {
    var data = await http.get(
        "http://wpapi.pythonanywhere.com/"
    );
    var jsonAPIData = json.decode(data.body);

    List<Post> posts = [];

    for(var i in jsonAPIData){
      Post post = Post(i["subreddit"], i["title"], i["comments"], i["author"], i["comment authors"], i["selftext"]);
      posts.add(post);
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF203040),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              // Hello welcome text
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Hello!', style: TextStyle(fontSize: 30, fontFamily: 'NotoLight' , color: fontColor))
                ),
              ),

              // Top stories welcome text
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15, bottom: 15),
                child: Text('Here are today\'s top stories:', style: TextStyle(fontSize: 35, fontFamily: 'Noto', color: fontColor),),
              ),

              // Title tiles
              Container(
                child: FutureBuilder(
                  future: _getStories(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    print(snapshot.data);
                    if(snapshot.data == null){
                      // Loading indicator if there is no internet, or any other errors
                      return Container(
                          padding: EdgeInsets.all(120),
                          child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                          )
                      );
                    }
                    else {
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: EdgeInsets.fromLTRB(14, 10, 14, 10),
                                  color: colors[Random().nextInt(colors.length)],
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          new MaterialPageRoute(builder: (context) => StoriesPage(snapshot.data[index]))
                                      );
                                    },
                                    child: Container(
                                      child: Stack(
                                          children: [
                                            ListTile(
                                              title: Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 10, 5, 7),
                                                child: Text(snapshot.data[index].title, style: TextStyle(fontFamily: 'Noto', fontSize: 20),),
                                              ),
                                            ),

                                            // Author bubble
                                            Positioned(
                                              bottom: 20,
                                              child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                  margin: EdgeInsets.only(left: 14, top: 10),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: Offset(3, 3),
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  child: Text('by u/${snapshot.data[index].author}', style: TextStyle(fontFamily: 'Noto', fontSize: 17),)
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Page indicator (for titles)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 27.0, 8.0, 8.0),
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: snapshot.data.length,
                              effect: WormEffect(
                                dotHeight: 12,
                                dotWidth: 12,
                                dotColor: Color(0xFFa4a4a4),
                                activeDotColor: Color(0xFFc86060),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}


// The stories page that appears when you tap a prompt/story.
// Contains: comments with stories (WritingPrompts) or a single story (nosleep)
class StoriesPage extends StatelessWidget {
  final Post post;
  StoriesPage(this.post);

  var fontColor = Color(0xFFe8e8e8);
  List colors = [Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff)];
  Random random = new Random();
  int index = 0;

  PageController _commentController = PageController(initialPage: 0);

  titleReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Color(0xFF203040),
          content: Text(post.title, style: TextStyle(fontFamily: 'Noto', fontSize: 20, color: fontColor),),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Color(0xFF101a24)
          ),
          child: post.subreddit== 'nosleep' ?
          // r/nosleep stories
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xff203040),
            ),
            margin: EdgeInsets.only(top: 30, bottom: 30, right: 15, left: 15),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 50, 22, 22),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: MarkdownBody(
                          selectable: false,
                          data: post.selftext,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(color: fontColor, fontSize: 19, fontFamily: "Noto"),
                          ),
                      )
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: new Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          color: Color(0xFF404850),
                        ),
                        child: Center(child: new Text('by u/${post.author}', style: TextStyle(fontSize: 17, fontFamily: 'Noto', color: fontColor),)),
                      )
                  ),
                ],
              ),
            ),
          )
              :
          // r/WritingPrompt story comments
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _commentController,
                    itemCount: post.comments.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onLongPress: () {
                          titleReminderDialog(context);
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              color: Color(0xff203040),
                          ),
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOutQuint,
                          margin: EdgeInsets.only(top: 30, bottom: 30, right: 15, left: 15),
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(22, 50, 22, 22),
                                  child: Container(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      child: Markdown(
                                        data: post.comments[index],
                                        styleSheet: MarkdownStyleSheet(
                                          p: TextStyle(color: fontColor, fontFamily: "Noto", fontSize: 19)
                                        ),
                                      ),
                                    )
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: new Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                        color: Color(0xFF404850),
                                      ),
                                      child: Center(child: new Text('by u/${post.commentAuthors[index]}', style: TextStyle(fontSize: 17, fontFamily: 'Noto', color: fontColor),)),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),

              // Page indicator (stories/comments)
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: SmoothPageIndicator(
                  controller: _commentController,
                  count: post.comments.length,
                  effect: WormEffect(
                    dotHeight: post.comments.length.toDouble() > 10 ? 5 : 10,
                    dotWidth: post.comments.length.toDouble() > 10 ? 5 : 10,
                    dotColor: Color(0xFFa4a4a4),
                    activeDotColor: Color(0xFFc86060),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}


// Post class that is called by the Future to retrieve title, author, comments, etc., from
// each post in the API.
class Post {
  final String subreddit;
  final String title;
  final List<dynamic> comments;
  final String author;
  final List<dynamic> commentAuthors;
  final String selftext;

  Post(this.subreddit, this.title, this.comments, this.author, this.commentAuthors, this.selftext);

}


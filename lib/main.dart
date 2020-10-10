import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var fontColor = Color(0xFFe8e7e0);

  List colors = [Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff),Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff)];
  Random random = new Random();

  PageController _pageController = PageController(initialPage: 0);

  Future<List<Post>> _getUsers() async {
    var data = await http.get(
//        "http://www.json-generator.com/api/json/get/cfwkXWPKPS?indent=2"
        "http://wpapi.pythonanywhere.com/"
    );
    var jsonData = json.decode(data.body);

    List<Post> posts = [];

    for(var i in jsonData){
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
//        drawer: Drawer(
//          child: Container(
//            decoration: BoxDecoration(
//              color: Color(0xFF203040)
//            ),
//            child: ListView(
//              children: [
//                DrawerHeader(
//                  decoration: BoxDecoration(
//                    color: Color(0xFF203040)
//                  ),
//                  child: Column(
//                    children: [
//                      Container(
//                        margin: EdgeInsets.only(top: 60),
//                        child: Align(
//                          alignment: Alignment.bottomLeft,
//                          child: Text('rSlash', style: TextStyle(fontFamily: 'Noto', fontSize: 30, color: fontColor),)
//                        )
//                      ),
//                      Align(
//                        alignment: Alignment.bottomLeft,
//                        child: Text('a collection of reddit short stories', style: TextStyle(fontFamily: 'Noto', fontSize: 16, color: Color(0xff66FFFFFF)),)
//                      )
//                    ],
//                  )
//                ),
//                Divider(
//                  indent: 5,
//                  endIndent: 5,
//                  color: Color(0xff66FFFFFF),
//                ),
//                ListTile(
//                  title: Text('WritingPrompts', style: TextStyle(fontFamily: 'Noto', fontSize: 20, color: fontColor),),
//                  subtitle: Text('stories inspired by prompts', style: TextStyle(fontFamily: 'Noto', fontSize: 13, color: Color(0xff66FFFFFF)),),
//                  trailing: Image.asset('assets/images/icons/writingPrompts.png', scale: 2.4,),
//                ),
//                ListTile(
//                  title: Text('nosleep', style: TextStyle(fontFamily: 'Noto', fontSize: 20, color: fontColor),),
//                  subtitle: Text('stories to keep you up at night', style: TextStyle(fontFamily: 'Noto', fontSize: 13, color: Color(0xff66FFFFFF)),),
//                  trailing: Image.asset('assets/images/icons/nosleep.png', scale: 2.4,),
//                ),
//                ListTile(
//                  title: Text('Saved', style: TextStyle(fontFamily: 'Noto', fontSize: 20, color: fontColor),),
//                  trailing: Image.asset('assets/images/icons/saved.png', scale: 2.7,),
//                ),
//                ListTile(
//                  title: Text('Login/Sign Up', style: TextStyle(fontFamily: 'Noto', fontSize: 20, color: fontColor),),
//                  trailing: Image.asset('assets/images/icons/login.png', scale: 2.6,),
//                ),
//
//              ],
//            ),
//          ),
//        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              //menu and nightmode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu
//                  GestureDetector(
//                    onTap: (){
//                      _scaffoldKey.currentState.openDrawer();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.only(left: 20, top: 30),
//                      child: Image.asset('assets/images/menu-light.png', scale: 14,),
//                    ),
//                  ),
                  // nightmode
//                  Padding(
//                    padding: const EdgeInsets.only(right: 20, top: 30 ),
//                    child: Image.asset('assets/images/nightmode.png', scale: 14)
//                  )
                ],
              ),

              // hello text
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Hello!', style: TextStyle(fontSize: 30, fontFamily: 'NotoLight' , color: fontColor))
                ),
              ),

              // top stories text
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15, bottom: 15),
                child: Text('Here are today\'s top stories:', style: TextStyle(fontSize: 35, fontFamily: 'Noto', color: fontColor),),
              ),

              // writing prompt tiles
              Container(
                child: FutureBuilder(
                  future: _getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    print(snapshot.data);
                    if(snapshot.data == null){
                      return Container(
                          child: Center(
                              child: Text("Loading...")
                          )
                      );
                    } else {
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
                                          new MaterialPageRoute(builder: (context) => CommentsPage(snapshot.data[index]))
                                      );
                                    },
                                    child: Container(
//                                      decoration: BoxDecoration(
//                                          image: DecorationImage(
//                                              image: AssetImage('assets/images/backdrop.png'),
//                                              fit: BoxFit.cover
//                                          )
//                                      ),
                                      child: Stack(
                                          children: [
                                            ListTile(
                                              title: Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 10, 5, 7),
                                                child: Text(snapshot.data[index].title, style: TextStyle(fontFamily: 'Noto', fontSize: 20),),
                                              ),
                                            ),

                                            // writing prompts bubble
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
                                                          offset: Offset(3, 3), // changes position of shadow
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
                          // page indicator
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

class CommentsPage extends StatelessWidget {
  final Post post;
  CommentsPage(this.post);
  var fontColor = Color(0xFFe8e8e8);

  List colors = [Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff)];
  Random random = new Random();
  int index = 0;

  PageController _commentController = PageController(initialPage: 0);

  titleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Text(post.title, style: TextStyle(fontFamily: 'Noto', fontSize: 20),),
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
                      child: Text(post.selftext, style: TextStyle(fontFamily: 'Noto', fontSize: 19, color: fontColor),),
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

          Column(
            children: [
              // story comments
              Expanded(
                child: PageView.builder(
                    controller: _commentController,
                    itemCount: post.comments.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onLongPress: () {
                          titleDialog(context);
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
                                    child: Text(post.comments[index], style: TextStyle(fontFamily: 'Noto', fontSize: 19, color: fontColor),),
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

              // page indicator
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

class Post {
  final String subreddit;
  final String title;
  final List<dynamic> comments;
  final String author;
  final List<dynamic> commentAuthors;
  final String selftext;

  Post(this.subreddit, this.title, this.comments, this.author, this.commentAuthors, this.selftext);

}


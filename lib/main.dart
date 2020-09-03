import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  List colors = [Color(0xFFf3ffe3), Color(0xFFc4faf8), Color(0xFFffcbc1), Color(0xFFaff8db), Color(0xFFecd4ff)];
  Random random = new Random();
  int index = 0;
  PageController _pageController = PageController(initialPage: 0);

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  Future<List<Post>> _getUsers() async {
    var data = await http.get(
//        "http://www.json-generator.com/api/json/get/cfwkXWPKPS?indent=2"
        "http://wpapi.pythonanywhere.com/"
    );
    var jsonData = json.decode(data.body);

    List<Post> posts = [];

    for(var i in jsonData){
      Post post = Post(i["title"], i["comments"], i["author"], i["comment authors"]);
      posts.add(post);
    }

    return posts;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            //menu and nightmode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // menu
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Image.asset('assets/images/menu.png', scale: 14,),
                ),
                // nightmode
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 30 ),
                  child: Image.asset('assets/images/nightmode.png', scale: 14,),
                )
              ],
            ),

            // hello text
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Hello!', style: TextStyle(fontSize: 30, fontFamily: 'NotoLight'))
              ),
            ),

            // top stories text
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15, bottom: 15),
              child: Text('Here are today\'s top stories:', style: TextStyle(fontSize: 35, fontFamily: 'Noto'),),
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
                                margin: EdgeInsets.all(10),
                                color: colors[index],
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,
                                        new MaterialPageRoute(builder: (context) => CommentsPage(snapshot.data[index]))
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                        children: [
                                          ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.all(7.0),
                                              child: Text(snapshot.data[index].title, style: TextStyle(fontFamily: 'Noto', fontSize: 20),),
                                            ),
                                          ),

                                          // writing prompts bubble
                                          Align(
                                            alignment: FractionalOffset.bottomLeft,
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
                                                child: Text('by u/ ${snapshot.data[index].author}', style: TextStyle(fontFamily: 'Noto', fontSize: 17),)
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
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: snapshot.data.length,
                          effect: WormEffect(
                            dotHeight: 15,
                            dotWidth: 15,
                            dotColor: Color(0xFFb5b5b5),
                            activeDotColor: Colors.blueGrey,
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
          color: colors[index]
        ),
        child: Column(
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
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 4),
                                  blurRadius: 4)
                            ]
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
                                  child: Text(post.comments[index], style: TextStyle(fontFamily: 'Noto', fontSize: 19),),
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
                                        color: Color(0xFFF2EEED),
                                    ),
                                    child: Center(child: new Text('by u/${post.commentAuthors[index]}', style: TextStyle(fontSize: 17, fontFamily: 'Noto'),)),
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
              margin: EdgeInsets.only(bottom: 20, top: 0),
              child: SmoothPageIndicator(
                controller: _commentController,
                count: post.comments.length,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  dotColor: Color(0xFFb5b5b5),
                  activeDotColor: Colors.blueGrey,
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
  final String title;
  final List<dynamic> comments;
  final String author;
  final List<dynamic> commentAuthors;


  Post(this.title, this.comments, this.author, this.commentAuthors);

}
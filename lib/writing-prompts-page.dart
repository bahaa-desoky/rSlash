import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'main.dart';
import 'colors.dart';

void main() => runApp(wpPosts());

class wpPosts extends StatelessWidget {
  var fontColor = Color(0xFFe8e7e0);

  Future<List<Post>> _getWPposts() async {
    var data = await http.get(
        "http://wpapi.pythonanywhere.com/"
    );
    var jsonAPIData = json.decode(data.body);

    List<Post> wp_posts = [];

    for(var i in jsonAPIData){
      Post wp_post = Post(i["subreddit"], i["title"], i["comments"], i["author"], i["comment authors"], i["selftext"]);
      if(wp_post.subreddit == "WritingPrompts")
        {
          wp_posts.add(wp_post);
        }
    }

    return wp_posts;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Color(0xFF203040),
        appBar: PreferredSize(
          child: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: fontColor,
            ),
            backgroundColor: Color(0xFF203040),
            elevation: 0,
            // title: Text('Writing Prompts', style: TextStyle(color: fontColor, fontFamily: "Noto", fontSize: 23),),
          ),
          preferredSize: Size.fromHeight(45),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getWPposts(),
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
                return ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.9,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: EdgeInsets.fromLTRB(14, 10, 14, 10),
                            color: colors[index], // changed the color to be index, try it out?
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
                                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 70),
                                          child: Text(snapshot.data[index].title, style: TextStyle(fontFamily: 'Noto', fontSize: 19),),
                                        ),
                                      ),

                                      //Author bubble
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
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
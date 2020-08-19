import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<List<User>> _getUsers() async {
    var data = await http.get(
        "http://www.json-generator.com/api/json/get/cfwkXWPKPS?indent=2"
//        "http://www.json-generator.com/api/json/get/bUkuLpiSle?indent=2"
    );
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for(var u in jsonData){
      User user = User(u["title"], u["comments"]);
      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: [
          // nightmode
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 30),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/nightmode.png', scale: 13,)
            ),
          ),
          // hello text
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Hello!', style: TextStyle(fontSize: 30, fontFamily: 'NotoLight'))
            ),
          ),
          // top stories text
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 15),
            child: Text('Here are today\'s top stories:', style: TextStyle(fontSize: 35, fontFamily: 'Noto'),),
          ),
        ],
      )
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: user.comments.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: ListTile(
              title: Text(user.comments[index]),
            ),
          );
        }
    );
  }
}

class User {
  final String title;
  final List<dynamic> comments;

  User(this.title, this.comments);

}
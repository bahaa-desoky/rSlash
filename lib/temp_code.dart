
// Future builder
//Container(
//child: FutureBuilder(
//future: _getUsers(),
//builder: (BuildContext context, AsyncSnapshot snapshot){
//print(snapshot.data);
//if(snapshot.data == null){
//return Container(
//child: Center(
//child: Text("Loading...")
//)
//);
//} else {
//return ListView.builder(
//itemCount: snapshot.data.length,
//itemBuilder: (BuildContext context, int index) {
//return ListTile(
//title: Text(snapshot.data[index].title),
//onTap: (){
//
//Navigator.push(context,
//new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
//);
//
//},
//);
//},
//);
//}
//},
//),
//),


//ListView.builder(
//shrinkWrap: true,
//itemCount: snapshot.data.length,
//itemBuilder: (BuildContext context, int index) {
//return Card(
//margin: EdgeInsets.all(10),
//color: colors[index],
//child: Container(
//child: Column(
//children: [
//ListTile(
//title: Padding(
//padding: const EdgeInsets.all(7.0),
//child: Text(snapshot.data[index].title, style: TextStyle(fontFamily: 'Noto', fontSize: 20),),
//),
//onTap: (){
//Navigator.push(context,
//new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
//);
//},
//),
//
//// writing prompts bubble
//Padding(
//padding: const EdgeInsets.only(bottom: 20, left: 14, top: 10),
//child: Align(
//alignment: Alignment.bottomLeft,
//child: Container(
//height: 35,
//width: 150,
//decoration: BoxDecoration(
//boxShadow: [
//BoxShadow(
//color: Colors.grey.withOpacity(0.5),
//spreadRadius: 2,
//blurRadius: 7,
//offset: Offset(3, 3), // changes position of shadow
//),
//],
//color: Colors.white,
//borderRadius: BorderRadius.circular(15)
//),
//child: Center(child: Text('Writing Prompt', style: TextStyle(fontFamily: 'Noto', fontSize: 17),)),
//),
//),
//)
//]
//),
//),
//);
//},
//);
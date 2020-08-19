
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
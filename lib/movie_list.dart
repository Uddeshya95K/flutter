import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {

  var movies;
  Color mainColor = const Color(0xff3C3261);

  void getData() async {
    var data = await getJson();

    setState(() {
      movies = data['results'];
    });
  }

  void searchOperation(String searchText){
    
  }

  Widget appBarTitle = new Text("Movies");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
  getData();
  return new Scaffold(
    backgroundColor: Colors.white,
    body: new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new MovieTitle(mainColor),
          new Expanded(
            child: new ListView.builder(
              itemCount: movies == null ? 0 : movies.length,
              itemBuilder: (context, i) {
                return  new FlatButton(
                  child: new MovieCell(movies,i),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context){
                      return new MovieDetail(movies[i]);
                    }));
                  },
                  color: Colors.white,
                );
            }),
          )
        ],
      ),
    ),
    appBar: new AppBar(
      centerTitle: true,
      title:appBarTitle,
      backgroundColor: Colors.pinkAccent,
      actions: <Widget>[
        new IconButton(icon: actionIcon,onPressed:(){
          setState(() {
            if ( this.actionIcon.icon == Icons.search){
              this.actionIcon = new Icon(Icons.close);
              this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search,color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)
                  ),
                  onChanged: searchOperation,
              );
            }
            else {
              this.actionIcon = new Icon(Icons.search);
              this.appBarTitle = new Text("Movies");
            }
          });
        },),
      ]
    ),
  );
  }
}

class MovieTitle extends StatelessWidget{

  final Color mainColor;


  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: new Text(
        'Top Rated',
        style: new TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo'
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

}

Future<Map> getJson() async {
  try
  {
  var url =
      'http://api.themoviedb.org/3/discover/movie?api_key={Keys}';
  http.Response response = await http.get(url);
  return json.decode(response.body);
  }
  on Exception {
    return null;
  }
}

class MovieCell extends StatelessWidget{

  final movies;
  final i;
  Color mainColor = const Color(0xff3C3261);
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  MovieCell(this.movies,this.i);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(
                      image: new NetworkImage(
                          image_url + movies[i]['poster_path']),
                      fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(
                        color: mainColor,
                        blurRadius: 5.0,
                        offset: new Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            new Expanded(
                child: new Container(
                  margin: const      EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                  child: new Column(children: [
                    new Text(
                      movies[i]['title'],
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    new Padding(padding: const EdgeInsets.all(2.0)),
                    new Text(movies[i]['overview'],
                      maxLines: 3,
                      style: new TextStyle(
                          color: const Color(0xff8785A4),
                          fontFamily: 'Arvo'
                      ),)
                  ],
                    crossAxisAlignment: CrossAxisAlignment.start,),
                )
            ),
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );

  }

}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_app/movie.dart';
import 'http_helper.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final String iconBase = 'https://image.tmdb.org/t/p/w92';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  List result;
  HttpHelper helper;
  int moviesCount;
  List movies;
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('فیلم ها');
  bool isLoading = true;

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    helper.getUpComing().then((value) => {
          setState(() {
            result = value;
          })
        });
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: searchBar, actions: <Widget>[
            IconButton(
                icon: visibleIcon,
                onPressed: () => {
                      setState(() {
                        if (this.visibleIcon.icon == Icons.search) {
                          this.visibleIcon = Icon(Icons.cancel);
                          this.searchBar = TextField(
                            textDirection: TextDirection.ltr,
                            onSubmitted: (String text) {
                              search(text);
                            },
                            textInputAction: TextInputAction.search,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          );
                        } else {
                          setState(() {
                            this.visibleIcon = Icon(Icons.search);
                            this.searchBar = Text('فیلم ها');
                          });
                          initialize();
                        }
                      })
                    })
          ]),
          body: Container(
            child: result == null || isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Directionality(
                    textDirection: TextDirection.ltr,
                    child: ListView.builder(
                        itemCount: moviesCount,
                        itemBuilder: (BuildContext context, int position) {
                          if (movies.length == 0)
                            return Container();
                          else if (movies[position].posterPath != null) {
                            image = NetworkImage(
                                iconBase + movies[position].posterPath);
                          } else {
                            image = NetworkImage(defaultImage);
                          }
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              onTap: () {
                                MaterialPageRoute route = MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetail(movies[position]));
                                Navigator.push(context, route);
                              },
                              leading: CircleAvatar(
                                backgroundImage: image,
                              ),
                              title: Text(movies[position].title),
                              subtitle: Text('Released: ' +
                                  (movies[position].releaseDate == null
                                      ? 'no Release Date'
                                      : movies[position].releaseDate) +
                                  ' - Vote: ' +
                                  movies[position].voteAverage.toString()),
                            ),
                          );
                        })),
          ),
        ));
  }

  Future initialize() async {
    setState(() {
      this.isLoading = true;
    });
    movies = List();
    movies = await helper.getUpComing();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
      this.isLoading = false;
    });
  }

  Future search(text) async {
    setState(() {
      this.isLoading = true;
    });
    movies = List();
    movies = await helper.findMovie(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
      this.isLoading = false;
    });
  }
}

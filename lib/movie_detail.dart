import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';

  MovieDetail(this.movie);

  @override
  Widget build(BuildContext context) {
    String path;
    double height = MediaQuery.of(context).size.height;
    if (movie.posterPath != null) {
      path = imgPath + movie.posterPath;
    } else {
      path =
          'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
    }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              movie.title,
              textDirection: TextDirection.ltr,
            ),
          ),
          body: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(16),
                      height: height / 1.5,
                      child: Center(
                        child: Image.network(path),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(movie.overview),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

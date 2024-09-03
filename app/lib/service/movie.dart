import 'dart:convert';

import 'package:app/service/url.dart';
import 'package:http/http.dart' as http;

class Movie {
  String title;
  String genre;
  String originalLanguage;
  String overview;
  double popularity;
  String releaseDate;
  int voteCount;
  String poster;
  int id;

  Movie({
    required this.title,
    required this.genre,
    required this.originalLanguage,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.voteCount,
    required this.poster,
    required this.id,
  });

  factory Movie.fromResponseBody(var jsonResponse) {
    return Movie(
        title: jsonResponse['title'],
        genre: jsonResponse['genre'],
        originalLanguage: jsonResponse['original_language'],
        overview: jsonResponse['overview'],
        popularity: jsonResponse['popularity'],
        releaseDate: jsonResponse['release_date'],
        voteCount: jsonResponse['vote_count'],
        poster: jsonResponse['poster'],
        id: int.parse(jsonResponse['id']));
  }

  static Future<Movie> fromId(int id, String token) async {
    Uri getUri = getUrl("/api/movie/get/$id/");
    final http.Response response = await http.get(
      getUri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      return Movie.fromResponseBody(json.decode(response.body));
    } else {
      throw Error();
    }
  }

  static Future<List<int>> getMovieIds(String token) async {
    Uri getUri = getUrl("/api/movie/list/");
    final http.Response response = await http.get(
      getUri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rawDecode = json.decode(response.body);
      List<int> intList = rawDecode.map((item) => item as int).toList();
      return intList;
    } else {
      throw Error();
    }
  }

  static Future<List<Movie>> getBatchMovies(
      List<int> movieIds, String token) async {
    List<Movie> movies = [];

    Uri getUri = getUrl("/api/movie/batchget/");
    final http.Response response = await http.post(
      getUri,
      body: jsonEncode(movieIds),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rawDecode = jsonDecode(utf8.decode(response.bodyBytes));

      for (var item in rawDecode) {
        movies.add(Movie.fromResponseBody(item));
      }
      return movies;
    } else {
      throw Error();
    }
  }

  static Future<List<Movie>> batchRecommend(
      Map<String, List<int>> movies, String token) async {
    List<int> movieIds = [];

    Uri getUri = getUrl("/api/movie/batchrecommend/");
    final http.Response response = await http.post(
      getUri,
      body: jsonEncode(movies),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rawDecode = jsonDecode(utf8.decode(response.bodyBytes));

      for (var item in rawDecode) {
        movieIds.add(int.parse(item));
      }

      return await getBatchMovies(movieIds, token);
    } else {
      throw Error();
    }
  }
}

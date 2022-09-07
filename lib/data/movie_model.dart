import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/data/PhotoResponse.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: 'popularity')
  double popularity;
  @JsonKey(name: 'vote_count')
  int voteCount;
  @JsonKey(name: 'video')
  bool video;
  @JsonKey(name: 'poster_path')
  String posterPath;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'adult')
  bool adult;
  @JsonKey(name: 'backdrop_path')
  String backdropPath;
  @JsonKey(name: 'original_language')
  String originalLanguage;
  @JsonKey(name: 'original_title')
  String originalTitle;
  @JsonKey(name: 'genre_ids')
  List<int> genreIds;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'vote_average')
  num voteAverage;
  @JsonKey(name: 'overview')
  String overview;
  @JsonKey(name: 'release_date')
  String releaseDate;

  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "height")
  int height;
  @JsonKey(name: "urls")
  Urls urls;
  // @JsonKey(name: "user")
  // User user;
  @JsonKey(name: "width")
  int width;

  MovieModel(
      {double popularity,
      int voteCount,
      bool video,
      String posterPath,
      int id,
      bool adult,
      String backdropPath,
      String originalLanguage,
      String originalTitle,
      List<int> genreIds,
      String title,
      num voteAverage,
      String overview,
      String releaseDate,
      String description,
      int height,
      int width,
      Urls urls}) {
    this.popularity = popularity;
    this.voteCount = voteCount;
    this.video = video;
    this.posterPath = posterPath;
    this.id = id;
    this.adult = adult;
    this.backdropPath = backdropPath;
    this.originalLanguage = originalLanguage;
    this.originalTitle = originalTitle;
    this.genreIds = genreIds;
    this.title = title;
    this.voteAverage = voteAverage;
    this.overview = overview;
    this.releaseDate = releaseDate;
    this.description = description;
    this.height = height;
    this.width = width;
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}

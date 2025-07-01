import 'genre.dart';
import 'actor.dart';
import 'country.dart';

class Movie {
  final int id;
  final String title;
  final int episodes;
  final String duration;
  final String status;
  final String language;
  final int releaseYear;
  final String? imageUrl;
  final String? content;
  final Country country;
  final List<Genre> genres;
  final List<Actor> actors;

  Movie({
    required this.id,
    required this.title,
    required this.episodes,
    required this.duration,
    required this.status,
    required this.language,
    required this.releaseYear,
    this.imageUrl,
    this.content,
    required this.country,
    required this.genres,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      episodes: int.tryParse(json['episodes'].toString()) ?? 0,
      duration: json['duration'] ?? '',
      status: json['status'] ?? '',
      language: json['language'] ?? '',
      releaseYear: int.tryParse(json['release_year'].toString()) ?? 0,
      imageUrl: json['imageUrl'],
      content: json['content'],
      country: Country.fromJson(json['country']),
      genres: (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
      actors: (json['actors'] as List).map((e) => Actor.fromJson(e)).toList(),
    );
  }
}

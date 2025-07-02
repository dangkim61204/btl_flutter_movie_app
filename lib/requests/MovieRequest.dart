class MovieRequest {
  final int? id;
  final String title;
  final int episodes;
  final String duration;
  final String status;
  final String language;
  final int releaseYear;
  final int countryId;
  final List<int> genreIds;
  final List<int> actorIds;
  final String? imageUrl;
  final String? content;

  MovieRequest({
    required this.id,
    required this.title,
    required this.episodes,
    required this.duration,
    required this.status,
    required this.language,
    required this.releaseYear,
    required this.countryId,
    required this.genreIds,
    required this.actorIds,
    this.imageUrl,
    this.content,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'episodes': episodes,
    'duration': duration,
    'status': status,
    'language': language,
    'release_year': releaseYear,
    'country_id': countryId,
    'genre_ids': genreIds,
    'actor_ids': actorIds,
    'imageUrl': imageUrl ?? '',
    'content': content ?? '',
  };
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_flutter/screens/forms/Movie_form.dart';
import 'package:movie_flutter/screens/forms/Movie_form_edit.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_screen.dart';

class MovieScreen extends StatefulWidget {
  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final MovieService _movieService = MovieService();
  late Future<List<Movie>> _futureMovies;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    _futureMovies = _movieService.getMovies();
  }

  void _confirmDelete(Movie movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xoá phim'),
        content: Text('Bạn có chắc muốn xoá "${movie.title}" không?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _movieService.deleteMovie(movie.id);
                Navigator.pop(context);
                setState(_loadMovies);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
              }
            },
            child: Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh
            Container(
              height: 180,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000/${movie.imageUrl}',
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (_, url, error) {
                  print("❌ Ảnh lỗi: $url - $error");
                  return Icon(Icons.broken_image, size: 60);
                },
              ),
            ),

            // Tiêu đề & quốc gia
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'QG: ${movie.country.name}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieEditFormScreen(movie: movie),
                        ),
                      ).then((updated) {
                        if (updated == true) setState(_loadMovies);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(movie),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎬 Danh sách phim')),
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text("Lỗi: ${snapshot.error}"));

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có phim'));

          final movies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (_, i) => _buildMovieCard(movies[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MovieFormScreen()),
          );
        },
        child: Icon(Icons.add),

      ),
    );
  }
}

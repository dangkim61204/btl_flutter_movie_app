import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

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
            child: Text('Xoá'),
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
        // Có thể chuyển sang màn sửa nếu cần
        // Navigator.push(...);
      },
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bọc bằng Container với BoxDecoration
            Container(
              height: 180,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
              child: movie.imageUrl != null && movie.imageUrl!.isNotEmpty
                  ?CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000/${movie.imageUrl}',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  debugPrint("❌ Ảnh lỗi: $url - lỗi: $error");
                  return Icon(Icons.broken_image, size: 60);
                },
              )
                  : Center(child: Icon(Icons.movie, size: 60)),
            ),


            // Tiêu đề và quốc gia
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'QG: ${movie.country.name}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Nút xoá
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _confirmDelete(movie),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách phim')),
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError) {
            print("❌ Lỗi FutureBuilder: ${snapshot.error}");
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có phim nào'));

          final movies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              childAspectRatio: 0.65, // tỉ lệ ảnh/card
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (_, index) => _buildMovieCard(movies[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updated = await Navigator.pushNamed(context, '/movie/form');
          if (updated == true) setState(_loadMovies);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

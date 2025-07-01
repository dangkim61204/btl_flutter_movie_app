import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../services/genre_service.dart';

class GenreScreen extends StatefulWidget {
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final GenreService _genreService = GenreService();
  late Future<List<Genre>> _futureGenres;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  void _loadGenres() {
    _futureGenres = _genreService.getGenres();
  }

  void _showForm({Genre? genre}) {
    final nameController = TextEditingController(text: genre?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(genre == null ? 'Thêm thể loại' : 'Sửa thể loại'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Tên thể loại'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              try {
                if (genre == null) {
                  await _genreService.createGenre(name);
                } else {
                  await _genreService.updateGenre(genre.id, name);
                }
                Navigator.pop(context);
                setState(_loadGenres);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${e.toString()}')),
                );
              }
            },
            child: Text('Lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Genre genre) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xóa thể loại'),
        content: Text('Bạn có chắc muốn xóa "${genre.name}" không?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _genreService.deleteGenre(genre.id);
                Navigator.pop(context);
                setState(_loadGenres);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${e.toString()}')),
                );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách thể loại')),
      body: FutureBuilder<List<Genre>>(
        future: _futureGenres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) {
            print(" Lỗi FutureBuilder: ${snapshot.error}");
            return Center(
              child: Text(
                ' Lỗi: ${snapshot.error.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có thể loại nào'));

          final genres = snapshot.data!;
          return ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return ListTile(
                title: Text(genre.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(genre: genre),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(genre),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}

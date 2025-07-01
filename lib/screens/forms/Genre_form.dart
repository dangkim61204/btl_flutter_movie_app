import 'package:flutter/material.dart';
import 'package:movie_flutter/models/genre.dart';
import 'package:movie_flutter/services/genre_service.dart';

class GenreFormScreen extends StatefulWidget {
  final Genre? genre;
  const GenreFormScreen({super.key, this.genre});

  @override
  State<GenreFormScreen> createState() => _GenreFormScreenState();
}

class _GenreFormScreenState extends State<GenreFormScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) _controller.text = widget.genre!.name;
  }

  void _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    if (widget.genre == null) {
      await GenreService().createGenre(name);
    } else {
      await GenreService().updateGenre(widget.genre!.id, name);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.genre != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Sửa thể loại" : "Thêm thể loại")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Tên thể loại")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text(isEdit ? "Cập nhật" : "Thêm"))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_flutter/models/actor.dart';
import 'package:movie_flutter/services/actor_service.dart';

class ActorScreen extends StatefulWidget {
  @override
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  final ActorService _actorService = ActorService();
  late Future<List<Actor>> _futureActors;

  @override
  void initState() {
    super.initState();
    _loadActors();
  }

  void _loadActors() {
    _futureActors = _actorService.getActors();
  }

  void _showForm({Actor? actor}) {
    final nameController = TextEditingController(text: actor?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(actor == null ? 'Thêm diễn viên' : 'Sửa diễn viên'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Tên diễn viên'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              try {
                if (actor == null) {
                  await _actorService.createActor(name);
                } else {
                  await _actorService.updateActor(actor.id, name);
                }
                Navigator.pop(context);
                setState(_loadActors);
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

  void _confirmDelete(Actor actor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xoá diễn viên'),
        content: Text('Bạn có chắc muốn xoá "${actor.name}" không?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _actorService.deleteActor(actor.id);
                Navigator.pop(context);
                setState(_loadActors);
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
      appBar: AppBar(title: Text('Danh sách diễn viên')),
      body: FutureBuilder<List<Actor>>(
        future: _futureActors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError) {
            print("❌ Lỗi FutureBuilder: ${snapshot.error}");
            return Center(
              child: Text(
                '❌ Lỗi: ${snapshot.error.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có diễn viên nào'));

          final actors = snapshot.data!;
          return ListView.builder(
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final actor = actors[index];
              return ListTile(
                title: Text(actor.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(actor: actor),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(actor),
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

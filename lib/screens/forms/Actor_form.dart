import 'package:flutter/material.dart';
import 'package:movie_flutter/models/actor.dart';
import 'package:movie_flutter/services/actor_service.dart';

class ActorFormScreen extends StatefulWidget {
  final Actor? actor;
  const ActorFormScreen({super.key, this.actor});

  @override
  State<ActorFormScreen> createState() => _ActorFormScreenState();
}

class _ActorFormScreenState extends State<ActorFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    isEdit = widget.actor != null;
    if (isEdit) {
      _nameController.text = widget.actor!.name;
    }
  }

  void _submit() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (isEdit) {
      await ActorService().updateActor(widget.actor!.id, name);
    } else {
      await ActorService().createActor(name);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Sửa diễn viên" : "Thêm diễn viên")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên diễn viên"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isEdit ? "Cập nhật" : "Thêm"),
            ),
          ],
        ),
      ),
    );
  }
}

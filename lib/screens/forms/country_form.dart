import 'package:flutter/material.dart';
import 'package:movie_flutter/models/country.dart';
import 'package:movie_flutter/services/country_service.dart';

class CountryFormScreen extends StatefulWidget {
  final Country? country;
  const CountryFormScreen({super.key, this.country});

  @override
  State<CountryFormScreen> createState() => _CountryFormScreenState();
}

class _CountryFormScreenState extends State<CountryFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    isEdit = widget.country != null;
    if (isEdit) {
      _nameController.text = widget.country!.name;
    }
  }

  void _submit() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (isEdit) {
      await CountryService().updateCountry(widget.country!.id, name);
    } else {
      await CountryService().createCountry(name);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Sửa quốc gia" : "Thêm quốc gia")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên quốc gia"),
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

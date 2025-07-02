import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_flutter/requests/MovieRequest.dart';

import '../../models/genre.dart';
import '../../models/actor.dart';
import '../../models/country.dart';
import '../../services/movie_service.dart';
import '../../services/genre_service.dart';
import '../../services/actor_service.dart';
import '../../services/country_service.dart';

class MovieFormScreen extends StatefulWidget {
  @override
  _MovieFormScreenState createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
   int? _id;
  final _titleController = TextEditingController();
  final _episodesController = TextEditingController();
  final _durationController = TextEditingController();
  final _yearController = TextEditingController();
  final _contentController = TextEditingController();

  String _status = 'đang chiếu';
  String _language = 'Vietsub';

  List<Country> _countries = [];
  List<Genre> _genres = [];
  List<Actor> _actors = [];

  int? _selectedCountryId;
  List<int> _selectedGenreIds = [];
  List<int> _selectedActorIds = [];

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final countries = await CountryService().getCountries();
    final genres = await GenreService().getGenres();
    final actors = await ActorService().getActors();

    setState(() {
      _countries = countries;
      _genres = genres;
      _actors = actors;
      _selectedCountryId = countries.isNotEmpty ? countries.first.id : null;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final movie = MovieRequest(
      id: _id,
      title: _titleController.text,
      episodes: int.parse(_episodesController.text),
      duration: _durationController.text,
      status: _status,
      language: _language,
      releaseYear: int.parse(_yearController.text),
      countryId: _selectedCountryId!,
      genreIds: _selectedGenreIds,
      actorIds: _selectedActorIds,
      imageUrl: '', // imageUrl sẽ được backend cập nhật sau khi upload file
      content: _contentController.text,
    );

    try {
      await MovieService().saveMovie(
        movie,
        'POST',
        hasFile: _pickedImage != null,
        filePath: _pickedImage?.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thêm phim thành công")));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm phim mới')),
      body: _countries.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImage != null
                    ? Image.file(_pickedImage!, height: 200, fit: BoxFit.cover)
                    : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text("Chọn ảnh")),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tên phim'),
                validator: (value) => value!.isEmpty ? 'Nhập tên phim' : null,
              ),
              TextFormField(
                controller: _episodesController,
                decoration: InputDecoration(labelText: 'Số tập'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Thời lượng'),
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Năm phát hành'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Nội dung'),
              ),
              DropdownButtonFormField(
                value: _status,
                items: ['đang chiếu', 'hoàn thành', 'sắp chiếu']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                decoration: InputDecoration(labelText: 'Trạng thái'),
              ),
              DropdownButtonFormField(
                value: _language,
                items: ['Vietsub', 'Thuyết minh']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _language = val!),
                decoration: InputDecoration(labelText: 'Ngôn ngữ'),
              ),
              DropdownButtonFormField<int>(
                value: _selectedCountryId,
                decoration: InputDecoration(labelText: 'Quốc gia'),
                items: _countries
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCountryId = val),
              ),
              SizedBox(height: 12),
              Text("Thể loại", style: TextStyle(fontWeight: FontWeight.bold)),
              ..._genres.map((g) {
                return CheckboxListTile(
                  value: _selectedGenreIds.contains(g.id),
                  title: Text(g.name),
                  onChanged: (v) {
                    setState(() {
                      if (v!) _selectedGenreIds.add(g.id);
                      else _selectedGenreIds.remove(g.id);
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 12),
              Text("Diễn viên", style: TextStyle(fontWeight: FontWeight.bold)),
              ..._actors.map((a) {
                return CheckboxListTile(
                  value: _selectedActorIds.contains(a.id),
                  title: Text(a.name),
                  onChanged: (v) {
                    setState(() {
                      if (v!) _selectedActorIds.add(a.id);
                      else _selectedActorIds.remove(a.id);
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Thêm phim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

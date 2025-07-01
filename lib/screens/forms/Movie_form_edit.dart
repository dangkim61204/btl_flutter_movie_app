import 'package:flutter/material.dart';
import 'package:movie_flutter/models/movie.dart';



class MovieEditFormScreen extends StatefulWidget {
  final Movie movie;

  const MovieEditFormScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieEditFormScreenState createState() => _MovieEditFormScreenState();
}

class _MovieEditFormScreenState extends State<MovieEditFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _episodesController;
  late TextEditingController _durationController;
  late TextEditingController _releaseYearController;
  late TextEditingController _contentController;

  late String status;
  late String language;

  // Dữ liệu mẫu giả định (sau sẽ thay bằng API)
  final List<String> countries = ['Việt Nam', 'Hàn Quốc', 'Mỹ'];
  final List<String> genres = ['Hành động', 'Tình cảm', 'Kinh dị'];
  final List<String> actors = ['Trấn Thành', 'Ngô Thanh Vân', 'Chi Pu'];

  String? selectedCountry;
  List<String> selectedGenres = [];
  List<String> selectedActors = [];

  @override
  void initState() {
    super.initState();

    final movie = widget.movie;

    _titleController = TextEditingController(text: movie.title);
    _episodesController = TextEditingController(text: movie.episodes.toString());
    _durationController = TextEditingController(text: movie.duration);
    _releaseYearController = TextEditingController(text: movie.releaseYear.toString());
    _contentController = TextEditingController(text: movie.content ?? '');

    status = movie.status;
    language = movie.language;
    selectedCountry = movie.country.name;

    selectedGenres = movie.genres.map((g) => g.name).toList();
    selectedActors = movie.actors.map((a) => a.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sửa phim")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Tên phim'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Nhập tiêu đề' : null,
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
                  controller: _releaseYearController,
                  decoration: InputDecoration(labelText: 'Năm phát hành'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Nội dung phim'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Quốc gia'),
                  value: selectedCountry,
                  items: countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedCountry = value),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Trạng thái'),
                  value: status,
                  items: ['hoàn thành', 'đang chiếu', 'sắp chiếu']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) => setState(() => status = value!),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Ngôn ngữ'),
                  value: language,
                  items: ['Vietsub', 'Thuyết minh']
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (value) => setState(() => language = value!),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Thể loại", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 10,
                  children: genres.map((genre) {
                    return FilterChip(
                      label: Text(genre),
                      selected: selectedGenres.contains(genre),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedGenres.add(genre);
                          } else {
                            selectedGenres.remove(genre);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Diễn viên", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 10,
                  children: actors.map((actor) {
                    return FilterChip(
                      label: Text(actor),
                      selected: selectedActors.contains(actor),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedActors.add(actor);
                          } else {
                            selectedActors.remove(actor);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("✅ Cập nhật phim:");
                      print("🎬 Tiêu đề: ${_titleController.text}");
                      print("📦 Thể loại: $selectedGenres");
                      print("🎭 Diễn viên: $selectedActors");
                      print("🌍 Quốc gia: $selectedCountry");
                      print("📜 Nội dung: ${_contentController.text}");

                      // Gọi API cập nhật ở đây nếu muốn
                    }
                  },
                  child: Text("Cập nhật phim"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

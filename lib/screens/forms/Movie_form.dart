// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:movie_flutter/models/actor.dart';
// import 'package:movie_flutter/models/country.dart';
// import 'package:movie_flutter/models/genre.dart';
// import 'package:movie_flutter/models/movie.dart';
// import 'package:movie_flutter/services/actor_service.dart';
// import 'package:movie_flutter/services/country_service.dart';
// import 'package:movie_flutter/services/genre_service.dart';
// import 'package:movie_flutter/services/movie_service.dart';
//
// class MovieFormScreen extends StatefulWidget {
//   final Movie? movie;
//   const MovieFormScreen({super.key, this.movie});
//
//   @override
//   State<MovieFormScreen> createState() => _MovieFormScreenState();
// }
//
// class _MovieFormScreenState extends State<MovieFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController titleController;
//   late TextEditingController episodesController;
//   late TextEditingController durationController;
//   late TextEditingController releaseYearController;
//   late TextEditingController imageUrlController;
//   late TextEditingController contentController;
//
//   String status = "hoàn thành";
//   String language = "Vietsub";
//   int? selectedCountryId;
//   List<int> selectedGenreIds = [];
//   List<int> selectedActorIds = [];
//
//   List<Genre> genres = [];
//   List<Actor> actors = [];
//   List<Country> countries = [];
//
//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.movie?.title ?? "");
//     episodesController = TextEditingController(text: widget.movie?.episodes.toString() ?? "");
//     durationController = TextEditingController(text: widget.movie?.duration ?? "");
//     releaseYearController = TextEditingController(text: widget.movie?.releaseYear.toString() ?? "");
//     imageUrlController = TextEditingController(text: widget.movie?.imageUrl ?? "");
//     contentController = TextEditingController(text: widget.movie?.content ?? "");
//     status = widget.movie?.status ?? "hoàn thành";
//     language = widget.movie?.language ?? "Vietsub";
//     selectedCountryId = widget.movie?.countryId;
//
//     // Gán genres và actors nếu có
//     selectedGenreIds = widget.movie?.genres?.map((e) => e.id).toList() ?? [];
//     selectedActorIds = widget.movie?.actors?.map((e) => e.id).toList() ?? [];
//
//     _loadSupportData();
//   }
//
//   Future<void> _loadSupportData() async {
//     final genreRes = await GenreService().getGenres();
//     final actorRes = await ActorService().getActors();
//     final countryRes = await CountryService().getCountries();
//
//     setState(() {
//       genres = (genreRes.bodyBytes.isNotEmpty)
//           ? (jsonDecode(utf8.decode(genreRes.bodyBytes)) as List)
//           .map((e) => Genre.fromJson(e))
//           .toList()
//           : [];
//
//       actors = (actorRes.bodyBytes.isNotEmpty)
//           ? (jsonDecode(utf8.decode(actorRes.bodyBytes)) as List)
//           .map((e) => Actor.fromJson(e))
//           .toList()
//           : [];
//
//       countries = (countryRes.bodyBytes.isNotEmpty)
//           ? (jsonDecode(utf8.decode(countryRes.bodyBytes)) as List)
//           .map((e) => Country.fromJson(e))
//           .toList()
//           : [];
//     });
//   }
//
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (selectedCountryId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng chọn quốc gia")),
//       );
//       return;
//     }
//
//     final movie = Movie(
//       id: widget.movie?.id ?? 0,
//       title: titleController.text,
//       episodes: int.parse(episodesController.text),
//       duration: durationController.text,
//       releaseYear: int.parse(releaseYearController.text),
//       status: status,
//       language: language,
//       imageUrl: imageUrlController.text,
//       content: contentController.text,
//       countryId: selectedCountryId!,
//       country: countries.firstWhere((c) => c.id == selectedCountryId),
//       genreIds: selectedGenreIds,
//       actorIds: selectedActorIds,
//       genres: genres.where((g) => selectedGenreIds.contains(g.id)).toList(),
//       actors: actors.where((a) => selectedActorIds.contains(a.id)).toList(),
//     );
//
//     // if (widget.movie != null) {
//     //   await MovieService().updateMovie(movie);
//     // } else {
//     //   await MovieService().createMovie(movie);
//     // }
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.movie != null ? "Sửa phim" : "Thêm phim")),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Tên phim'),
//                 validator: (value) => value!.isEmpty ? 'Không được để trống' : null,
//               ),
//               TextFormField(
//                 controller: episodesController,
//                 decoration: const InputDecoration(labelText: 'Số tập'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextFormField(
//                 controller: durationController,
//                 decoration: const InputDecoration(labelText: 'Thời lượng'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: status,
//                 items: ['hoàn thành', 'đang chiếu', 'sắp chiếu']
//                     .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                     .toList(),
//                 onChanged: (val) => setState(() => status = val!),
//                 decoration: const InputDecoration(labelText: 'Trạng thái'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: language,
//                 items: ['Vietsub', 'Thuyết minh']
//                     .map((l) => DropdownMenuItem(value: l, child: Text(l)))
//                     .toList(),
//                 onChanged: (val) => setState(() => language = val!),
//                 decoration: const InputDecoration(labelText: 'Ngôn ngữ'),
//               ),
//               TextFormField(
//                 controller: releaseYearController,
//                 decoration: const InputDecoration(labelText: 'Năm phát hành'),
//                 keyboardType: TextInputType.number,
//               ),
//               DropdownButtonFormField<int>(
//                 value: selectedCountryId,
//                 items: countries
//                     .map((c) =>
//                     DropdownMenuItem(value: c.id, child: Text(c.name)))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedCountryId = val!),
//                 decoration: const InputDecoration(labelText: 'Quốc gia'),
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: genres
//                     .map((g) => FilterChip(
//                   label: Text(g.name),
//                   selected: selectedGenreIds.contains(g.id),
//                   onSelected: (bool selected) {
//                     setState(() {
//                       selected
//                           ? selectedGenreIds.add(g.id)
//                           : selectedGenreIds.remove(g.id);
//                     });
//                   },
//                 ))
//                     .toList(),
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: actors
//                     .map((a) => FilterChip(
//                   label: Text(a.name),
//                   selected: selectedActorIds.contains(a.id),
//                   onSelected: (bool selected) {
//                     setState(() {
//                       selected
//                           ? selectedActorIds.add(a.id)
//                           : selectedActorIds.remove(a.id);
//                     });
//                   },
//                 ))
//                     .toList(),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: contentController,
//                 decoration: const InputDecoration(labelText: 'Nội dung'),
//                 maxLines: 4,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: Text(widget.movie != null ? "Cập nhật" : "Thêm"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

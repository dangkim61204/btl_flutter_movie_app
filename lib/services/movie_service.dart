import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/common.dart';
import '../models/movie.dart';

class MovieService {
  final String baseUrl = "${Common.domain}/movies";

  Future<List<Movie>> getMovies() async {
    print(" Đang gọi API: $baseUrl");

    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(Duration(seconds: 5));

      print(" STATUS: ${response.statusCode}");

      //  Giải mã UTF-8 đúng chuẩn
      final decodedBody = utf8.decode(response.bodyBytes);
      print(" BODY: $decodedBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        return (data as List).map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      print(" Lỗi khi gọi API: $e");
      rethrow;
    }
  }

  Future<void> deleteMovie(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception("Không thể xoá phim");
    }
  }
}

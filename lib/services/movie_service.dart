import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_flutter/requests/MovieRequest.dart';
import '../models/common.dart';
import '../models/movie.dart';

class MovieService {
  final String baseUrl = "${Common.domain}/api/movies";

  //get all
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

  //ham them moi
  Future<String?> saveMovie(MovieRequest movie, String method, {bool hasFile = false, String? filePath}) async {
    final url = method == 'POST'
        ? Uri.parse('${Common.domain}/api/movies')
        : Uri.parse('${Common.domain}/api/movies/${movie.id}');

    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Accept': 'application/json',
    });

    if (hasFile && filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
    } else {
      request.files.add(http.MultipartFile.fromBytes('image', [], filename: ''));
    }

    if (method == 'PUT') {
      request.fields['_method'] = 'PUT';
    }

    final fields = <String, String>{};
    movie.toJson().forEach((key, value) {
      if (value is List) {
        for (var v in value) {
          fields.putIfAbsent('$key[]', () => v.toString());
        }
      } else {
        fields[key] = value.toString();
      }
    });
    request.fields.addAll(fields);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Lỗi lưu phim: ${response.statusCode} - $respStr');
    }

    final jsonResp = jsonDecode(respStr);
    return jsonResp['imageUrl']; // ✅ lấy đường dẫn ảnh từ response
  }





//delete
  Future<void> deleteMovie(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception("Không thể xoá phim");
    }
  }
}

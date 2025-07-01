import 'dart:convert';

import 'package:movie_flutter/models/actor.dart';
import 'package:movie_flutter/models/common.dart';
import 'package:http/http.dart' as http;
class ActorService {
  final String baseUrl = "${Common.domain}/actors";

  Future<List<Actor>> getActors() async {
    print("📡 Đang gọi API: $baseUrl");

    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(Duration(seconds: 5));

      print(" STATUS: ${response.statusCode}");
      print(" BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((e) => Actor.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      print(" Lỗi khi gọi API: $e");
      rethrow;
    }
  }

  Future<void> createActor(String name) async {
    final body = jsonEncode({'name': name});
    final response = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode != 201) throw Exception("Không thể thêm");
  }

  Future<void> updateActor(int id, String name) async {
    final body = jsonEncode({'name': name});
    final response = await http.put(Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode != 200) throw Exception("Không thể cập nhật");
  }

  Future<void> deleteActor(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) throw Exception("Không thể xoá");
  }
}
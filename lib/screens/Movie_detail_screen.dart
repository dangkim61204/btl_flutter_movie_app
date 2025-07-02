import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_flutter/models/common.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh và thông tin
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh bên trái
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: '${Common.domain}/${movie.imageUrl}',
                    width: 140,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.broken_image, size: 60),
                  ),
                ),
                SizedBox(width: 12),

                // Thông tin bên phải
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      _buildInfo("Trạng thái", movie.status),
                      _buildInfo("Thời lượng", movie.duration),
                      _buildInfo("Số tập", movie.episodes.toString()),
                      _buildInfo("Ngôn ngữ", movie.language),
                      _buildInfo("Năm sản xuất", movie.releaseYear.toString()),
                      _buildInfo("Quốc gia", movie.country.name),
                      _buildInfo("Thể loại",
                          movie.genres.map((g) => g.name).join(', ')),
                      _buildInfo("Diễn viên",
                          movie.actors.map((a) => a.name).join(', ')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Nội dung phim
            Text(" Nội dung:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(
              movie.content?.trim().isNotEmpty == true
                  ? movie.content!
                  : 'Không có nội dung cho phim này.',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),
            Divider(),
            Text(" Bình luận",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("(Chức năng bình luận sẽ cập nhật sau...)"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(text: "$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

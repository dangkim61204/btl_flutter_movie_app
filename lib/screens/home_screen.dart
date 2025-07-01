import 'package:flutter/material.dart';
import 'genre_screen.dart';
import 'actor_screen.dart';
import 'movie_screen.dart';
import 'country_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang chủ')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Thể loại'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GenreScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Diễn viên'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActorScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Phim'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Quốc gia'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CountryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

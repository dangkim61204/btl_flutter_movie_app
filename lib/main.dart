import 'package:flutter/material.dart';
import 'package:movie_flutter/screens/actor_screen.dart';
import 'package:movie_flutter/screens/country_screen.dart';
import 'package:movie_flutter/screens/genre_screen.dart';
import 'package:movie_flutter/screens/home_screen.dart';
import 'package:movie_flutter/screens/movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý phim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
    );
  }
}
import 'package:animeone/ui/page/home.dart';
import 'package:flutter/material.dart';

/// Top level component
class MyApp extends StatelessWidget {

  final darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.pink,
    indicatorColor: Colors.pink,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.pink
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeOne',
      theme: darkTheme,
      home: HomePage(),
    );
  }

}

/// Entry point of this app
void main() {
  runApp(MyApp());
}
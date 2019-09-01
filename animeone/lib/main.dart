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

  final hour = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeOne',
      theme: hour > 17 ? darkTheme : lightTheme,
      home: HomePage(),
    );
  }

}

/// Entry point of this app
void main() {
  runApp(MyApp());
}
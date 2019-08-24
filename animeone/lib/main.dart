import 'package:animeone/ui/page/home.dart';
import 'package:flutter/material.dart';

/// Top level component
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeOne',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }

}

/// Entry point of this app
void main() {
  runApp(MyApp());
}
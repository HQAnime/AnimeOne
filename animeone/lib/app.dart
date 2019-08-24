import 'package:animeone/ui/page/main.dart';
import 'package:flutter/material.dart';

/// Top level component
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeOne',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// Entry point of this app
void main() {
  runApp(MyApp());
}
import 'package:animeone/ui/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Entry point of this app
void main() {
  runApp(MyApp());
}

/// Top level component
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final darkTheme = ThemeData(
    primarySwatch: Colors.pink,
    brightness: Brightness.dark,
    accentColor: Colors.pink,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.pink,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Setup navigation bar colour
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: useDark ? Colors.grey[900] : Colors.grey[50],
    //   systemNavigationBarIconBrightness: useDark ? Brightness.light : Brightness.dark
    // ));

    return MaterialApp(
      title: 'AnimeOne',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}

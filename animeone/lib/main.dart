import 'package:animeone/ui/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Top level component
class MyApp extends StatelessWidget {

  final darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.pink,
    indicatorColor: Colors.pink,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.pink,
  );

  // static final _hour = DateTime.now().hour;
  // // From 6pm to 6am for dark mode
  // final useDark = _hour > 17 || _hour < 7;

  @override
  Widget build(BuildContext context) {
    // Setup navigation bar colour 
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: useDark ? Colors.grey[900] : Colors.grey[50],
    //   systemNavigationBarIconBrightness: useDark ? Brightness.light : Brightness.dark
    // ));

    return MaterialApp(
      title: '永遠のAnimeOne',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }

}

/// Entry point of this app
void main() {
  runApp(MyApp());
}
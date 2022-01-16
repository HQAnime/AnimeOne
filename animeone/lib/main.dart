import 'dart:io';

import 'package:animeone/ui/page/home.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry point of this app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This can be done by changing the native project
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(Size(400, 400));
  }

  runApp(MyApp());
}

/// Top level component
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.pink,
      brightness: Brightness.dark,
    ).copyWith(
      // set navigation tab bar tint colour
      secondary: Colors.pinkAccent,
    ),
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.pink,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
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

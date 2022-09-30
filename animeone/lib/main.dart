import 'package:animeone/ui/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry point of this app
void main() {
  runApp(const MyApp());
}

/// Top level component
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;
      // update navigation bar colour
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor:
              brightness == Brightness.light ? Colors.white : Colors.black,
          systemNavigationBarIconBrightness: brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      );
    };
  }

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
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeOne',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}

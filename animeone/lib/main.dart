import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';

/// Entry point of this app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // setup logger and make sure it only prints in debug mode
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      final message = '${record.loggerName}: ${record.message}';
      print('${record.level.name}|$message');
    }
  });

  runApp(const MyApp());
}

class _PopIntent extends Intent {
  const _PopIntent();
}

/// Top level component
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    GlobalData.fontScaleNotifier.addListener(_onFontScaleChanged);
    GlobalData.darkModeNotifier.addListener(_onDarkModeChanged);
    GlobalData.localeNotifier.addListener(_onLocaleChanged);
    _locale = GlobalData().getLocale();
  }

  void _onFontScaleChanged() {
    if (mounted) setState(() {});
  }

  void _onDarkModeChanged() {
    if (mounted) setState(() {});
  }

  void _onLocaleChanged() {
    if (mounted) {
      setState(() {
        _locale = GlobalData().getLocale();
      });
    }
  }

  @override
  void dispose() {
    GlobalData.fontScaleNotifier.removeListener(_onFontScaleChanged);
    GlobalData.darkModeNotifier.removeListener(_onDarkModeChanged);
    GlobalData.localeNotifier.removeListener(_onLocaleChanged);
    super.dispose();
    final platformDispatcher = PlatformDispatcher.instance;
    platformDispatcher.onPlatformBrightnessChanged = () {
      final brightness = platformDispatcher.platformBrightness;
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
      secondary: Colors.pinkAccent,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.pink,
      inactiveTrackColor: Colors.pink.shade100,
      thumbColor: Colors.pink,
    ),
  );

  final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.pink,
    ).copyWith(
      secondary: Colors.pinkAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.pink,
      inactiveTrackColor: Colors.pink.shade100,
      thumbColor: Colors.pink,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.escape): const _PopIntent(),
        SingleActivator(LogicalKeyboardKey.keyW): const DirectionalFocusIntent(TraversalDirection.up),
        SingleActivator(LogicalKeyboardKey.keyA): const DirectionalFocusIntent(TraversalDirection.left),
        SingleActivator(LogicalKeyboardKey.keyS): const DirectionalFocusIntent(TraversalDirection.down),
        SingleActivator(LogicalKeyboardKey.keyD): const DirectionalFocusIntent(TraversalDirection.right),
      },
      child: Actions(
        actions: {
          _PopIntent: CallbackAction(onInvoke: (_) {
            _navigatorKey.currentState?.maybePop();
            return null;
          }),
        },
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'AnimeOne',
          locale: _locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supported) {
            if (_locale != null) return _locale;
            if (locale == null) return const Locale('en');
            for (final l in supported) {
              if (l.languageCode == locale.languageCode) return l;
            }
            return const Locale('en');
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: GlobalData.darkModeNotifier.value ? ThemeMode.dark : ThemeMode.system,
          home: HomePage(),
          builder: (context, child) {
            final scale = GlobalData().getFontScale();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

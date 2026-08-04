import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';
import 'package:dynamic_color/dynamic_color.dart';

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
  // Cached dynamic (wallpaper-based) schemes loaded from the platform.
  ColorScheme? _lightDynamic;
  ColorScheme? _darkDynamic;

  @override
  void initState() {
    super.initState();
    GlobalData.fontScaleNotifier.addListener(_onFontScaleChanged);
    GlobalData.darkModeNotifier.addListener(_onDarkModeChanged);
    GlobalData.dynamicColorNotifier.addListener(_onDynamicColorChanged);
    GlobalData.localeNotifier.addListener(_onLocaleChanged);
    _locale = GlobalData().getLocale();
    _loadDynamicSchemes();
  }

  /// Loads the system dynamic color scheme (Material You) when available.
  /// Dynamic color is an Android 12+ feature; other platforms use the pink seed.
  Future<void> _loadDynamicSchemes() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (!mounted || corePalette == null) return;
    setState(() {
      _lightDynamic = corePalette.toColorScheme(brightness: Brightness.light);
      _darkDynamic = corePalette.toColorScheme(brightness: Brightness.dark);
    });
  }

  void _onFontScaleChanged() {
    if (mounted) setState(() {});
  }

  void _onDarkModeChanged() {
    if (mounted) setState(() {});
  }

  void _onDynamicColorChanged() {
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
    GlobalData.dynamicColorNotifier.removeListener(_onDynamicColorChanged);
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

  /// Follow the system dynamic color (Material You) when enabled, defaulting to
  /// the pink brand otherwise. The cached scheme is null until the platform
  /// reports one (and on platforms without dynamic color, e.g. pre-Android 12).
  ThemeData _buildTheme(Brightness brightness) {
    final dynamicScheme =
        brightness == Brightness.light ? _lightDynamic : _darkDynamic;
    final useDynamic = !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        GlobalData.dynamicColorNotifier.value &&
        dynamicScheme != null;
    final scheme = useDynamic
        ? dynamicScheme
        : ColorScheme.fromSeed(seedColor: Colors.pink, brightness: brightness);
    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      iconTheme: IconThemeData(color: scheme.primary),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: scheme.primary),
        // Let Material 3 render the app bar with the default surface color so
        // it matches other dynamic-color apps instead of a saturated primary.
        systemOverlayStyle: brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.35),
        thumbColor: scheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'AnimeOne for All',
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
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode:
          GlobalData.darkModeNotifier.value ? ThemeMode.dark : ThemeMode.system,
      home: HomePage(),
      builder: (context, child) {
        final scale = GlobalData().getFontScale();
        return Shortcuts(
          shortcuts: {
            SingleActivator(LogicalKeyboardKey.escape): const _PopIntent(),
          },
          child: Actions(
            actions: {
              _PopIntent: CallbackAction(onInvoke: (_) {
                _navigatorKey.currentState?.maybePop();
                return null;
              }),
            },
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

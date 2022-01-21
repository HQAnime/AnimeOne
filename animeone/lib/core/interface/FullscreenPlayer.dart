import 'package:flutter/services.dart';

mixin FullscreenPlayer {
  void setLandscape() {
    // Fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      // Hide the status bar
      overlays: [],
    );

    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void resetOrientation() {
    // Reset UI overlay
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

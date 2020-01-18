@ECHO OFF
flutter build web && robocopy /e /is build\web\ ../firebase

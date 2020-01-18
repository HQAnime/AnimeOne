@ECHO off
REM /is to override, /e to include everything
flutter build web && robocopy /e /is build\web\ desktop\

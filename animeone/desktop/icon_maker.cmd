@ECHO off
npx electron-icon-maker --input=..\..\design\logo\round.png --output=.\icons && ROBOCOPY /move /e /is .\icons .\assets & move assets\icons\mac\*.* assets\icons & move assets\icons\win\*.* assets\icons & move assets\icons\png\*.* assets\icons & rmdir assets\icons\mac assets\icons\win assets\icons\png

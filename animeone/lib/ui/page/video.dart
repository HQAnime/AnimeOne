import 'dart:io';

import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Video extends StatefulWidget {
  final AnimeVideo? video;
  Video({Key? key, required this.video}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  final isIOS = Platform.isIOS;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  @override
  void dispose() {
    // Reset rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Reset UI overlay
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load webpage in app
    return Scaffold(
      appBar: isIOS ? AppBar() : null,
      body: Container(
        color: Colors.black,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: <Widget>[
        Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: WebView(
              onPageFinished: (url) {
                print('done');
                setState(() {
                  loading = false;
                });
              },
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: widget.video?.video,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
        buildLoading(),
      ],
    );
  }

  Widget buildLoading() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container();
  }
}

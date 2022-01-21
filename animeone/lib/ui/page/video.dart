import 'dart:io';

import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/interface/FullscreenPlayer.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Video extends StatefulWidget {
  final AnimeVideo? video;
  Video({Key? key, required this.video}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> with FullscreenPlayer {
  final isIOS = Platform.isIOS;
  bool loading = true;
  List<WebViewCookie> _cookies = [];
  String? videoLink;

  @override
  void initState() {
    super.initState();
    setLandscape();

    if (widget.video?.hasToken ?? false) {
      final token = widget.video?.video;
      if (token != null) {
        final parser = VideoSourceParser();
        parser.post(headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }, body: 'd=$token').then((res) {
          _cookies = parseCookies(res?.headers['set-cookie']);
          final body = parser.handleReponse(res);
          setState(() {
            videoLink = parser.parseHTML(body);
            print('Raw video link - $videoLink');
          });
        });
      }
    } else {
      videoLink = widget.video?.video;
    }
  }

  @override
  void dispose() {
    resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load webpage in app
    return Scaffold(
      appBar: isIOS
          ? AppBar(
              title: Text('Video'),
            )
          : null,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    // Only show video if the link is valid
    if (videoLink == null) return buildLoading();

    return Stack(
      children: <Widget>[
        Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: WebView(
              backgroundColor: Theme.of(context).primaryColor,
              initialCookies: _cookies,
              onPageFinished: (url) {
                print('done');
                setState(() {
                  loading = false;
                });
              },
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: videoLink,
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
      return SizedBox.shrink();
  }

  List<WebViewCookie> parseCookies(String? cookies) {
    // e=1642763963; expires=Fri, 21-Jan-2022 11:19:23 GMT; Max-Age=14398; path=/1003/2b.mp4; domain=.v.anime1.me; secure; HttpOnly,
    // p=eyJpc3MiOiJhbmltZTEubWUiLCJleHAiOjE2NDI3NjM5NjMwMDAsImlhdCI6MTY0Mjc0OTU2NTAwMCwic3ViIjoiLzEwMDMvMmIubXA0In0; expires=Fri, 21-Jan-2022 11:19:23 GMT; Max-Age=14398; path=/1003/2b.mp4; domain=.v.anime1.me; secure; HttpOnly,
    // h=5-ylVZg1CJDB4b95AhArlw; expires=Fri, 21-Jan-2022 11:19:23 GMT; Max-Age=14398; path=/1003/2b.mp4; domain=.v.anime1.me; secure; HttpOnly
    if (cookies == null) return [];
    return cookies.split('HttpOnly,').map((cookie) {
      final c = cookie.split(';');
      final name = c[0].split('=')[0];
      final value = c[0].split('=')[1];
      final path = c[3].split('=')[1];
      final domain = c[4].split('=')[1];
      return WebViewCookie(
        name: name,
        value: value,
        path: path,
        domain: domain,
      );
    }).toList();
  }
}

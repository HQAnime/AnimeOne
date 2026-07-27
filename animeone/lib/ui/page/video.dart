import 'dart:io';

import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/interface/FullscreenPlayer.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Video extends StatefulWidget {
  final AnimeVideo? video;
  const Video({super.key, required this.video});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> with FullscreenPlayer {
  final _logger = Logger('Video');
  final isIOS = Platform.isIOS;
  final isDesktop = !Platform.isAndroid && !Platform.isIOS;
  bool loading = true;
  List<WebViewCookie> _cookies = [];
  String? videoLink;

  late final WebViewController? _controller;

  @override
  void initState() {
    super.initState();

    if (!isDesktop) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              _logger.info('done loading');
              setState(() {
                loading = false;
              });
            },
            onPageFinished: (String url) {
              _logger.info('Page finished loading: $url');
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              _logger.severe('Web resource error: ${error.description}');
              setState(() {
                loading = false;
              });
            },
          ),
        )
        ..setBackgroundColor(Colors.black);
    }
    final cookieManager = WebViewCookieManager();
    for (final cookie in _cookies) {
      cookieManager.setCookie(cookie);
    }

    setLandscape();
    if (widget.video?.hasToken ?? false) {
      final token = widget.video?.video;
      if (token != null) {
        final parser = VideoSourceParser();
        parser.post(headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }, body: 'd=$token').then((res) {
          final cookieString = res?.headers['set-cookie'];
          _cookies = parseCookies(cookieString);
          final body = parser.handleReponse(res);
          setState(() {
            videoLink = parser.parseHTML(body);
            _logger.info('Raw video link - $videoLink');
            if (videoLink == null) {
              loading = false;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('沒有找到動畫鏈接'),
              ));
              return;
            }

            // add referer header
            _controller?.loadRequest(
              Uri.parse(videoLink!),
              headers: {
                'Referer': 'https://anime1.me/',
                'User-Agent':
                    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0',
                'Cookie': cookieString ?? '',
                // 'Range': 'bytes=0-',
                // "Sec-Fetch-Dest": "video",
                // "Dnt": "1",
                // "Priority": "i",
              },
            );
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
              title: const Text('Video'),
            )
          : null,
      body: Container(
        color: Colors.black,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    // Only show video if the link is valid
    if (videoLink == null) return buildLoading();

    if (isDesktop) {
      launchUrl(Uri.parse(videoLink!));
      return Center(
        child: TextButton(
          onPressed: () => launchUrl(Uri.parse(videoLink!)),
          child: const Text('Open in browser'),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Center(
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: WebViewWidget(controller: _controller!)),
        ),
        buildLoading(),
      ],
    );
  }

  Widget buildLoading() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const SizedBox.shrink();
    }
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

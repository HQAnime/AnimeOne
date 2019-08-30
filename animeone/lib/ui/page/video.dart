import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  
  final AnimeVideo video;
  Video({Key key, @required this.video}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();

}

class _VideoState extends State<Video> {

  VideoPlayerController videoController;
  ChewieController chewie;

  @override
  void initState() {
    super.initState();
    this.videoController = VideoPlayerController.network(widget.video.video + '.m3u8');
    this.chewie = ChewieController(
      videoPlayerController: videoController,
      allowedScreenSleep: false,
      aspectRatio: 16 / 9,
      autoPlay: true,
      errorBuilder: (context, msg) {
        return Text('無法加載視頻，使用瀏覽器播放', style: TextStyle(color: Colors.white));
      },
      looping: false,
    );
  }

  @override
  void dispose() {
    this.videoController.dispose();
    this.chewie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Chewie(
          controller: chewie,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.close),
                tooltip: '關閉視頻',
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.file_download),
                tooltip: '還不支持下載視頻',
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.launch),
                tooltip: '使用瀏覽器觀看',
                onPressed: () => widget.video.launchURL(),
              ),
            ),
          ],
        ),
      )
    );
  }
  
}

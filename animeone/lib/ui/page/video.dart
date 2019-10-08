import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  VideoSourceParser parser;
  String downloadLink;

  @override
  void initState() {
    super.initState();

    this.parser = new VideoSourceParser(widget.video.video);
    this.parser.downloadHTML().then((body) {
      String link = this.parser.parseHTML(body);
      if (link == null) {
        // If parser fails to get the link, pop and use browser
        Navigator.pop(context);
        launch(widget.video.video);
        dispose();
      } else {
        this.downloadLink = link;
        setState(() {
          this.videoController = VideoPlayerController.network(link);
          this.chewie = ChewieController(
            videoPlayerController: videoController,
            allowedScreenSleep: false,
            aspectRatio: 16 / 9,
            autoPlay: true,
            errorBuilder: (context, msg) {
              return Text(
                '無法加載視頻\n請截圖并且聯係開發者\n鏈接:$link\n\n$msg', 
                style: TextStyle(color: Colors.white), 
                textAlign: TextAlign.center
              );
            },
            looping: false,
          );
        });
      }
    });
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
        child: this.renderBody()
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
            // Expanded(
            //   child: IconButton(
            //     icon: Icon(Icons.file_download),
            //     tooltip: '還不支持下載視頻',
            //     onPressed: () {},
            //   ),
            // ),
            // Expanded(
            //   child: IconButton(
            //     icon: Icon(Icons.launch),
            //     tooltip: '使用瀏覽器觀看',
            //     onPressed: () => widget.video.launchURL(),
            //   ),
            // ),
          ],
        ),
      )
    );
  }

  renderBody() {
    if (this.chewie != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxHeight,
              child: Chewie(
                controller: chewie,
              ),
            )
          );
        }
      );
    } else {
      return CircularProgressIndicator();
    }
  }
  
}

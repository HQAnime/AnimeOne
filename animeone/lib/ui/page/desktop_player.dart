import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DesktopPlayer extends StatefulWidget {
  final String url;
  final Map<String, String>? headers;

  const DesktopPlayer({super.key, required this.url, this.headers});

  @override
  State<DesktopPlayer> createState() => _DesktopPlayerState();
}

class _DesktopPlayerState extends State<DesktopPlayer> {
  late final Player _player;
  late final VideoController _controller;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _player.stream.playing.listen((v) {
      if (mounted) setState(() => _playing = v);
    });
    _play();
  }

  Future<void> _play() async {
    await _player.open(
      Media(
        widget.url,
        httpHeaders: widget.headers,
      ),
    );
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _skip(Duration offset) {
    final pos = _player.state.position + offset;
    _player.seek(pos >= Duration.zero ? pos : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Video(controller: _controller),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.black87,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
            onPressed: () => _skip(const Duration(seconds: -10)),
            tooltip: '-10s',
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(
              _playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              if (_playing) {
                _player.pause();
              } else {
                _player.play();
              }
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.forward_30, color: Colors.white, size: 32),
            onPressed: () => _skip(const Duration(seconds: 30)),
            tooltip: '+30s',
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

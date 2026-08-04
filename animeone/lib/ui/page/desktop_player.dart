import 'dart:async';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/WatchEntry.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DesktopPlayer extends StatefulWidget {
  final String url;
  final Map<String, String>? headers;
  final String? episodeLink;
  final String? episodeName;

  const DesktopPlayer({
    super.key,
    required this.url,
    this.headers,
    this.episodeLink,
    this.episodeName,
  });

  @override
  State<DesktopPlayer> createState() => _DesktopPlayerState();
}

class _DesktopPlayerState extends State<DesktopPlayer> {
  late final Player _player;
  late final VideoController _controller;
  bool _playing = false;
  final _focusNode = FocusNode();
  int _positionSec = 0;
  int _durationSec = 0;
  final _global = GlobalData();
  bool _speedBoost = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _enterFullscreen();
    _player = Player();
    _controller = VideoController(_player);
    _player.stream.playing.listen((v) {
      if (mounted) setState(() => _playing = v);
    });
    _player.stream.position.listen((d) {
      if (mounted) setState(() => _positionSec = d.inSeconds);
    });
    _player.stream.duration.listen((d) {
      _durationSec = d.inSeconds;
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
    // Wait for duration to be known before seeking.
    await Future.doWhile(() => Future.delayed(
        const Duration(milliseconds: 50), () => _durationSec <= 0));
    final episodeLink = widget.episodeLink;
    if (episodeLink != null) {
      final saved = _global.getWatchEntry(episodeLink);
      if (saved != null && saved.positionSec > 0) {
        _player.seek(Duration(seconds: saved.positionSec));
      }
    }
    _player.play();
  }

  void _enterFullscreen() async {
    await const MethodChannel('com.alexmercerind/media_kit_video')
        .invokeMethod('Utils.EnterNativeFullscreen');
  }

  void _exitFullscreen() async {
    await const MethodChannel('com.alexmercerind/media_kit_video')
        .invokeMethod('Utils.ExitNativeFullscreen');
  }

  void _save() {
    if (widget.episodeLink == null) return;
    final done = _durationSec > 0 &&
        (_positionSec >= _durationSec * 0.88 || _positionSec >= 20 * 60);
    _global.saveWatchEntry(WatchEntry(
      episodeLink: widget.episodeLink!,
      episodeName: widget.episodeName ?? widget.url,
      positionSec: _positionSec,
      durationSec: _durationSec,
      done: done,
    ));
  }

  @override
  void dispose() {
    _hideOverlayTimer?.cancel();
    _save();
    _player.dispose();
    _focusNode.dispose();
    _exitFullscreen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _togglePlay() {
    if (_playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _skip(Duration offset) {
    final pos = _player.state.position + offset;
    final clamped = pos >= Duration.zero ? pos : Duration.zero;
    final max = _player.state.duration;
    _player.seek(clamped > max ? max : clamped);
  }

  void _jump80() => _skip(const Duration(seconds: 80));

  void _onLongPressStart(LongPressStartDetails _) {
    _player.setRate(2.0);
    if (mounted) setState(() => _speedBoost = true);
  }

  void _onLongPressEnd(LongPressEndDetails _) {
    _player.setRate(1.0);
    if (mounted) setState(() => _speedBoost = false);
  }

  void _close() {
    _save();
    final nav = Navigator.of(context);
    Future.microtask(() => nav.pop());
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.space): _TogglePlayIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft):
            _SkipIntent(const Duration(seconds: -10)),
        SingleActivator(LogicalKeyboardKey.arrowRight):
            _SkipIntent(const Duration(seconds: 30)),
        SingleActivator(LogicalKeyboardKey.escape): _CloseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowUp):
            _SkipIntent(const Duration(seconds: 0)),
      },
      child: Actions(
        actions: {
          _TogglePlayIntent: CallbackAction(onInvoke: (_) => _togglePlay()),
          _SkipIntent:
              CallbackAction<_SkipIntent>(onInvoke: (i) => _skip(i.offset)),
          _CloseIntent: CallbackAction(onInvoke: (_) {
            _close();
            return null;
          }),
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.mediaPlay): _togglePlay,
              const SingleActivator(LogicalKeyboardKey.mediaPause): _togglePlay,
              const SingleActivator(LogicalKeyboardKey.mediaStop): _togglePlay,
              const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious):
                  () => _skip(const Duration(seconds: -10)),
              const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
                  _skip(const Duration(seconds: 30)),
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Video(
                    controller: _controller,
                    controls: null,
                  ),
                  // Transparent layer for long-press and tap-to-show.
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _onVideoTap,
                          onDoubleTap: () =>
                              _skip(const Duration(seconds: -10)),
                          onLongPressStart: _onLongPressStart,
                          onLongPressEnd: _onLongPressEnd,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _onVideoTap,
                          onDoubleTap: () => _skip(const Duration(seconds: 10)),
                          onLongPressStart: _onLongPressStart,
                          onLongPressEnd: _onLongPressEnd,
                        ),
                      ),
                    ],
                  ),
                  IgnorePointer(
                    ignoring: !_overlayVisible,
                    child: AnimatedOpacity(
                      opacity: _overlayVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: _buildTopBar(),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _speedBoost && !_overlayVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _buildSpeedBadge(),
                  ),
                  _buildControlsBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsBar() {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: IgnorePointer(
        ignoring: !_overlayVisible,
        child: AnimatedOpacity(
          opacity: _overlayVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0x44000000),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: _togglePlay,
                  tooltip: AppLocalizations.of(context)!.clickToPlay,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.16),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      overlayColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.16),
                    ),
                    child: Slider(
                      value: _durationSec > 0
                          ? (_positionSec / _durationSec).clamp(0.0, 1.0)
                          : 0.0,
                      onChanged: (v) {
                        _player.seek(
                            Duration(seconds: (v * _durationSec).round()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _buildSpeedBadge() {
    return const Positioned(
      top: 12,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Color(0x44000000),
          shape: StadiumBorder(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text('2x',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  // Re-show overlay when tapping the video.
  Timer? _hideOverlayTimer;
  bool _overlayVisible = true;

  void _onVideoTap() {
    _hideOverlayTimer?.cancel();
    setState(() => _overlayVisible = !_overlayVisible);
    if (_overlayVisible) {
      _hideOverlayTimer = Timer(const Duration(seconds: 10), () {
        if (mounted) setState(() => _overlayVisible = false);
      });
    }
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Material(
              color: Color(0x44000000),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 24),
                onPressed: _close,
                tooltip: AppLocalizations.of(context)!.closePlayer,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0x44000000),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_formatDuration(_positionSec)} / ${_formatDuration(_durationSec)}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            if (_speedBoost)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0x44000000),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('2x',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            const Spacer(),
            Material(
              color: Color(0x44000000),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.fast_forward,
                    color: Colors.white, size: 24),
                onPressed: _jump80,
                tooltip: AppLocalizations.of(context)!.skipJump80,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _TogglePlayIntent extends Intent {}

class _SkipIntent extends Intent {
  final Duration offset;
  const _SkipIntent(this.offset);
}

class _CloseIntent extends Intent {}

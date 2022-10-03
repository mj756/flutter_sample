import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioDemo extends StatefulWidget {
  @override
  State<AudioDemo> createState() => _AudioDemoState();
}

class _AudioDemoState extends State<AudioDemo> {
  late AudioPlayer _player = AudioPlayer();
  static const url =
      'https://file-examples.com/storage/feb2e515cc6339d7ba1ffcd/2017/11/file_example_MP3_700KB.mp3';
  @override
  void initState() {
    _player = AudioPlayer();
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        print('loading');
      } else if (!isPlaying) {
        print('not playing');
      } else {
        print('playing');
      }
    });
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _init() async {
    await _player.setUrl(url).then((value) {
      _player.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ElevatedButton(onPressed: () {}, child: Text('Play'))],
      ),
    );
  }
}

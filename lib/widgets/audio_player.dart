import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  @override
  void initState() {
    super.initState();
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      _handleInterruptions(audioSession);
      // Use another plugin to load audio to play.
      await _player.setUrl(
          "https://cdn1.suno.ai/e48c0ee8-24c8-459b-8d91-469dbd6fc3a5.mp3");
    });
  }

  void _handleInterruptions(AudioSession audioSession) {
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      _player.pause();
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_player.playing) {
              _player.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
    audioSession.devicesChangedEventStream.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: StreamBuilder<ja.PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      if (playerState?.processingState !=
                          ja.ProcessingState.ready) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 64.0,
                          height: 64.0,
                          child: const CircularProgressIndicator(),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            playerState?.playing == true
                                ? IconButton(
                                    icon: const Icon(Icons.pause),
                                    iconSize: 30.0,
                                    onPressed: _player.pause,
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: 30.0,
                                    onPressed: _player.play,
                                  ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

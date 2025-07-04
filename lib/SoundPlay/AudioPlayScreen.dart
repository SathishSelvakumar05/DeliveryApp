// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:just_audio/just_audio.dart';
//
// class AudioPickerPlayer extends StatefulWidget {
//   @override
//   _AudioPickerPlayerState createState() => _AudioPickerPlayerState();
// }
//
// class _AudioPickerPlayerState extends State<AudioPickerPlayer> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String? _fileName;
//   bool isPlaying = false;
//
//   Future<void> _pickAudioFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mp3', 'wav', 'm4a'],
//     );
//
//     if (result != null && result.files.single.path != null) {
//       final path = result.files.single.path!;
//       setState(() {
//         _fileName = result.files.single.name;
//       });
//
//       await _audioPlayer.setFilePath(path);
//       await _audioPlayer.play();
//       setState(() {
//         isPlaying = true;
//       });
//     }
//   }
//
//   void _togglePlayPause() {
//     if (_audioPlayer.playing) {
//       _audioPlayer.pause();
//     } else {
//       _audioPlayer.play();
//     }
//     setState(() {
//       isPlaying = _audioPlayer.playing;
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initAudioSession();
//   }
//   Future<void> _initAudioSession() async {
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.music());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: _pickAudioFile,
//             child: Text('Pick Audio'),
//           ),
//           if (_fileName != null) ...[
//             Text('Playing: $_fileName'),
//             IconButton(
//               icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//               onPressed: _togglePlayPause,
//             ),
//           ]
//         ],
//       ),
//     );
//   }
// }

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

class AudioPickerPlayer extends StatefulWidget {
  @override
  _AudioPickerPlayerState createState() => _AudioPickerPlayerState();
}

class _AudioPickerPlayerState extends State<AudioPickerPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _fileName;
  bool isPlaying = false;
  double _speed = 1.0;
  LoopMode _loopMode = LoopMode.off;

  @override
  void initState() {
    super.initState();
    _initAudioSession();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      setState(() {
        _fileName = result.files.single.name;
      });

      await _audioPlayer.setFilePath(path);
      await _audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = _audioPlayer.playing;
    });
  }

  void _changeLoopMode() {
    setState(() {
      if (_loopMode == LoopMode.off) {
        _loopMode = LoopMode.one;
      } else if (_loopMode == LoopMode.one) {
        _loopMode = LoopMode.all;
      } else {
        _loopMode = LoopMode.off;
      }
      _audioPlayer.setLoopMode(_loopMode);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration? d) {
    if (d == null) return "--:--";
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAudioFile,
              child: Text('Pick Audio'),
            ),
            if (_fileName != null) ...[
              Text('Playing: $_fileName'),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayPause,
              ),
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;
                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Text(
                        "${formatDuration(position)} / ${formatDuration(duration)}",
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<Duration>(
                stream: _audioPlayer.bufferedPositionStream,
                builder: (context, snapshot) {
                  final buffered = snapshot.data ?? Duration.zero;
                  return Text("Buffered: ${formatDuration(buffered)}");
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Speed: ${_speed.toStringAsFixed(1)}x"),
                  Slider(
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    value: _speed,
                    label: "${_speed.toStringAsFixed(1)}x",
                    onChanged: (value) {
                      setState(() {
                        _speed = value;
                        _audioPlayer.setSpeed(_speed);
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loop Mode: ${_loopMode.name}"),
                  IconButton(
                    icon: Icon(Icons.repeat),
                    onPressed: _changeLoopMode,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}


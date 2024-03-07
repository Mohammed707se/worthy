// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class VoiceScreen extends StatefulWidget {
  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _duration = 0.0;
  double _position = 0.0;

  @override
  void initState() {
    super.initState();

    // Specify the audio file path here
    String audioFilePath = 'assets/flutter_sound.wav';
    _audioPlayer.setUrl(audioFilePath);

    // Listen for duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration.inMilliseconds.toDouble();
      });
    });

    // Listen for audio position changes
    _audioPlayer.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        _position = position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrowcircleleft2.svg'),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Discover the radiant beauty that resides within you, waiting to be unveiled through the practice of mindfulness and self-reflection. Embrace the journey of inner exploration, where the gentle whispers of your soul guide you towards a profound sense of self-love and acceptance.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset('assets/Group15.png'),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    'release the notion that my body size defines my attractiveness; I am beautiful just as I am. Today, I choose self-acceptance over self-criticism and embrace the beauty within me.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                      onPressed: () {
                        if (_isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          // Play the asset directly without using AssetSource
                          _audioPlayer.play('assets/flutter_sound.wav');
                        }
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        _audioPlayer.stop();
                        setState(() {
                          _isPlaying = false;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

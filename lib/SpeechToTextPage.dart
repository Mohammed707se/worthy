// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:worthy/VoiceScreen.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  String recognizedText = "";

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  Future<void> _initializeSpeechToText() async {
    // التحقق من وجود صلاحيات الميكروفون
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      // إذا لم تكن الصلاحيات موجودة، طلبها
      await Permission.microphone.request();
      // قم بفحص الحالة مرة أخرى بعد طلب الصلاحيات
      status = await Permission.microphone.status;
    }

    if (status.isDenied || status.isRestricted) {
      // If permissions are denied or restricted, request them
      print("Requesting microphone permission...");
      await Permission.microphone.request();
      // Check the status again after requesting
      status = await Permission.microphone.status;
      print("Microphone permission status after request: $status");
    }

    if (status.isGranted) {
      // If permissions are granted, initialize SpeechToText
      print("Microphone permission granted. Initializing SpeechToText...");
      bool isAvailable = await _speech.initialize();
      if (isAvailable) {
        print("SpeechToText initialized successfully");
      } else {
        print("SpeechToText initialization failed");
      }
    } else {
      print("Permission for microphone is denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appearance'),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrowcircleleft2.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('assets/Playlist5.png'),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: startListening,
                child: AvatarGlow(
                  glowColor: Colors.blue,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Icon(Icons.mic),
                      radius: 40.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'press the mic, and hold to record',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                child: Text(
                  'What features of your appearance that you feel insecure about?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(
                    recognizedText,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        recognizedText = ""; // Clear the recognized text
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color: Color(0xff8367C7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> VoiceScreen())
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Color(0xff8367C7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Text(
              //   'النص المعترف به: $recognizedText',
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 20.0),
              // ElevatedButton(
              //   onPressed: startListening,
              //   child: Text('بدء التسجيل'),
              // ),
              // SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  void startListening() {
    if (!_speech.isListening && _speech.isAvailable) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
          });
        },
        listenFor: Duration(seconds: 10),
      );
    } else {
      print("SpeechToText is not initialized or not available.");
    }
  }
}

import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:salinsalita/models/course.dart';
import 'package:salinsalita/screens/home/components/course_card.dart';
import 'package:salinsalita/screens/home/components/video_info.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SpeechCatch extends StatefulWidget {
  final String username;

  const SpeechCatch({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<SpeechCatch> createState() => _SpeechCatchState(username: '');
}

class _SpeechCatchState extends State<SpeechCatch> {
  final SpeechToText _speechToText = SpeechToText();
  late String username;
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  late Timer _speechTimeout;
  var _imageUrl = '';

  _SpeechCatchState({required this.username});

  @override
  void initState() {
    super.initState();
    initSpeech();
    username = widget.username;
    _speechTimeout = Timer(const Duration(seconds: 2), () {
      _stopListening();
    });
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onResult);

    // Cancel the existing timer before starting a new one
    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }

    // Start a new timer if speech recognition is successful
    if (_speechToText.isListening) {
      _speechTimeout = Timer(const Duration(seconds: 2), () {
        _stopListening();
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }
    super.dispose();
  }

  void _stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }
    setState(() {});
  }

  void _onResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });

    // Cancel the existing timer before starting a new one
    _speechTimeout.cancel();

    // Start a new timer if speech recognition is successful
    if (_confidenceLevel > 0) {
      _speechTimeout = Timer(const Duration(seconds: 2), () {
        _stopListening();
        // Fetch the URL after the timer stops
        String filePath =
            'signlanguage/${_wordsSpoken.replaceAll(' ', ' ')}.gif';
        fetchFileFromStorage(filePath);
      });
    }
  }

  Future<void> fetchFileFromStorage(String filePath) async {
    // Check if the spoken word is not empty and the timer has stopped
    if (_wordsSpoken.isNotEmpty && !_speechTimeout.isActive) {
      try {
        final ref = FirebaseStorage.instance.ref();
        final pathReference = ref.child(filePath);
        final url = await pathReference.getDownloadURL();
        print('File URL: $url'); // Use pathReference here

        // Set the URL to display after fetching
        setState(() {
          _imageUrl = url;
        });
        // Moved this print statement outside of setState
      } catch (e) {
        print('Error fetching file: $e');
        print('Word Spoken: $_wordsSpoken');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            if (!_imageUrl.isNotEmpty)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Courses",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...courses
                              .map((course) => Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: CourseCard(
                                      course: course,
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const VideoInfo(),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap the microphone or write the word to translate "
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              child: _imageUrl.isNotEmpty
                  ? Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            Image.network(
                              _imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                print('Stack trace: $stackTrace');
                                return const Text('Failed to load image');
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return FutureBuilder<void>(
                                    future: Future.delayed(
                                        const Duration(seconds: 6)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return child;
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment:
            MainAxisAlignment.end, // Aligns the FAB to the bottom
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Aligns the FAB to the right
            children: [
              const SizedBox(width: 30),
              const SizedBox(width: 18),
              AvatarGlow(
                glowColor: Color.fromRGBO(16, 44, 87, 1),
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                child: FloatingActionButton(
                  onPressed: _speechToText.isListening
                      ? _stopListening
                      : _startListening,
                  tooltip: 'Listen',
                  backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
                  child: Icon(
                    _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      // Implement your search functionality using the entered value
                      print('Searching for: $value');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 40), // Add a sized box here
        ],
      ),
    );
  }
}

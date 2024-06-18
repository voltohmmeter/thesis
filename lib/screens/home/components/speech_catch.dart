import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:salinsalita/models/course.dart';
import 'package:salinsalita/screens/home/components/course_card.dart';
import 'package:salinsalita/screens/home/components/video_info.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SpeechCatch extends StatefulWidget {
  final String username;

  const SpeechCatch({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<SpeechCatch> createState() => _SpeechCatchState(username: username);
}

class _SpeechCatchState extends State<SpeechCatch> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final Connectivity _connectivity = Connectivity();

  late String username;
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  late Timer _speechTimeout;
  Timer? _inactivityTimer;
  var _imageUrl = '';
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  _SpeechCatchState({required this.username});

  final GlobalKey _courseCardKeys = GlobalKey();
  final GlobalKey _micButtonKey = GlobalKey();
  final GlobalKey _textInputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initSpeech();
    initConnectivity();
    _speechTimeout = Timer(const Duration(seconds: 2), () {
      _stopListening();
    });
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _createTutorial();
  }

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }
    if (!mounted) {
      return Future.value(null);
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      await _speakTTS("Please connect to the internet First");
    }
  }

  void _startListening() async {
    if (_connectionStatus == ConnectivityResult.none) {
      await _speakTTS("Please connect to the internet to use this feature");
      return;
    }

    await _speechToText.listen(onResult: _onResult);

    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }

    if (_speechToText.isListening) {
      _speechTimeout = Timer(const Duration(seconds: 2), () {
        _stopListening();
      });
    }
  }

  @override
  void dispose() {
    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    if (_speechTimeout.isActive) {
      _speechTimeout.cancel();
    }
    _resetInactivityTimer();
    setState(() {});
  }

  void _onResult(SpeechRecognitionResult result) {
    _processResult(result.recognizedWords);
  }

  void _processResult(String recognizedWords) {
    setState(() {
      _wordsSpoken = recognizedWords;
      _confidenceLevel = 1.0; // Assume full confidence for text input
    });

    _speechTimeout.cancel();

    if (_wordsSpoken.isNotEmpty) {
      _speechTimeout = Timer(const Duration(seconds: 2), () {
        _stopListening();
        String filePath =
            'signlanguage/${_wordsSpoken.replaceAll(' ', ' ')}.gif';
        fetchFileFromStorage(filePath);
      });
    }
  }

  Future<void> fetchFileFromStorage(String filePath) async {
    if (_wordsSpoken.isNotEmpty && !_speechTimeout.isActive) {
      try {
        final ref = FirebaseStorage.instance.ref();
        final pathReference = ref.child(filePath);
        final url = await pathReference.getDownloadURL();
        print('File URL: $url');

        setState(() {
          _imageUrl = url;
        });

        await _speakTTS("The sign language of $_wordsSpoken is now displaying");
      } catch (e) {
        print('Error fetching file: $e');
        print('Word Spoken: $_wordsSpoken');
        await _speakTTS("The said sign language is not on the database yet");
      }
      _resetInactivityTimer();
    }
  }

  Future<void> _speakTTS(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 15), () {
      setState(() {
        _imageUrl = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 75),
            if (_imageUrl.isEmpty)
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Courses",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          key: _courseCardKeys,
                          children: courses.map((course) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: CourseCard(
                                course: course,
                                onTap: () {
                                  setState(() {});
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const VideoInfo(),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                        ? "Tap the microphone or write the word to translate"
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            if (_imageUrl.isNotEmpty)
              Expanded(
                child: Column(
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
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return FutureBuilder<void>(
                                future:
                                    Future.delayed(const Duration(seconds: 6)),
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
                ),
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
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 75,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    key: _textInputKey,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      _processResult(value);
                    },
                  ),
                ),
              ),
              AvatarGlow(
                glowColor: Color.fromRGBO(16, 44, 87, 1),
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                child: FloatingActionButton(
                  key: _micButtonKey,
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
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _createTutorial() async {
    final targets = [
      TargetFocus(
        identify: 'floatingButton',
        keyTarget: _courseCardKeys,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Text(
              'This Cards Contains Sign Language Tutorials \n Click this to view the video tutorials',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'editButton',
        keyTarget: _micButtonKey,
        shape: ShapeLightFocus.Circle,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Text(
              'Pressed this button to enable the speech input \n Note: this can only accepts inputs if the internet connection is on',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'settingsButton',
        keyTarget: _textInputKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Text(
              'Type the corresponding word to dsiplay the sign language\n Note: this can only accepts inputs if the internet connection is on ',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    ];

    final tutorial = TutorialCoachMark(
      targets: targets,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }
}

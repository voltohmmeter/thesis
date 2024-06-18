import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salinsalita/service/database.dart';
import 'package:audioplayers/audioplayers.dart';

class Question extends StatefulWidget {
  final String category;
  Question({required this.category});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool show = false;
  int score = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  Stream? QuizStream;
  PageController controller = PageController();

  getontheload() async {
    QuizStream = await DatabaseMethods().getCategoryQuiz(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Future<void> playSound(String fileName) async {
    await audioPlayer.play(AssetSource('$fileName'));
  }

  void checkAnswer(String selectedOption, String correctOption) {
    if (selectedOption == correctOption) {
      score++;
      playSound('correct_answer.wav');
    } else {
      playSound('wrong_answer.wav');
    }
    show = true;
    setState(() {});
  }

  Widget allQuiz() {
    return StreamBuilder(
      stream: QuizStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 40.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ds["Image"],
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    for (int i = 1; i <= 4; i++)
                      GestureDetector(
                        onTap: () {
                          checkAnswer(ds["option$i"], ds["correct"]);
                        },
                        child: show
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ds["correct"] == ds["option$i"]
                                            ? Colors.green
                                            : Colors.red,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  ds["option$i"],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff818181),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  ds["option$i"],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          show = false;
                        });
                        if (index == snapshot.data.docs.length - 1) {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                    score: score,
                                    total: snapshot.data.docs.length),
                              ),
                            );
                          });
                        } else {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Color(0xff004840),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 72, 64, 0.867),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xfff35b32),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50.0,
                ),
                Text(
                  widget.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(child: allQuiz()),
        ],
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  final int score;
  final int total;

  ResultsPage({required this.score, required this.total});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    playResultSound();
  }

  Future<void> playResultSound() async {
    String soundFileName;
    if (widget.score / widget.total > 0.8) {
      soundFileName = 'success.mp3';
    } else {
      soundFileName = 'failed.mp3';
    }
    await audioPlayer.play(AssetSource(soundFileName));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message;
    if (widget.score / widget.total > 0.8) {
      message = "You are great in this!";
    } else {
      message = "Better luck next time.";
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 72, 64, 0.867),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: ${widget.score} / ${widget.total}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Categories'),
            ),
          ],
        ),
      ),
    );
  }
}

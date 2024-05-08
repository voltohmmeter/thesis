import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salinsalita/pages/question.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 251, 244, 1),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color.fromARGB(255, 255, 254, 254),
                      ),
                    ),
                    Container(
                      height: 220,
                      padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 206, 178, 146),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(11, 32, 61, 1),
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.only(
                          top: 120.0, left: 20.0, right: 20.0),
                      child: const Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Play &\nLearn",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Play Quiz by\nguessing the\nimages",
                                style: TextStyle(
                                    color: Color(0xffa4a4a4),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Top Quiz Categories",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Question(category: "The Basics")));
                            },
                            child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5.0,
                                child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 231, 203),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      Image.asset(
                                        "assets/images/sign2.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      const Text(
                                        "The Basics",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]) //Column
                                    ) //Container
                                ),
                          ), //Material
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Question(category: "Greetings")));
                            },
                            child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5.0,
                                child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 250, 219, 184),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      Image.asset(
                                        "assets/images/sign2.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      const Text(
                                        "Greetings",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]) //Column
                                    ) //Container
                                ),
                          ), //Material
                        ],
                      ) //Row
                      ), //Padding
                  const SizedBox(height: 20.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Question(category: "Numbers")));
                            },
                            child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5.0,
                                child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 250, 219, 184),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      Image.asset(
                                        "assets/images/sign2.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      const Text(
                                        "Numbers",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]) //Column
                                    ) //Container
                                ),
                          ), //Material
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Question(category: "Letters")));
                            },
                            child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5.0,
                                child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 231, 203),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      Image.asset(
                                        "assets/images/sign2.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      const Text(
                                        "Letters",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]) //Column
                                    ) //Container
                                ),
                          ), //Material
                        ],
                      ) //Row
                      ), //Padding
                ],
              )),
        ));
  }
}

import 'dart:convert';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salinsalita/constants/color.dart';

import "colors.dart" as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({Key? key}) : super(key: key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  bool _playArea = false;
  late CustomVideoPlayerController _customVideoPlayerController;

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
    //_onTapVideo(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.AppColor.gradientFirst,
              color.AppColor.gradientSecond
            ],
            begin: const FractionalOffset(0.0, 0.4),
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            _playArea == false
                ? Container(
                    padding:
                        const EdgeInsets.only(top: 70, left: 30, right: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios,
                                  size: 20,
                                  color: color.AppColor.secondPageIconColor),
                            ),
                            Expanded(child: Container()),
                            Icon(Icons.info_outline,
                                size: 20,
                                color: color.AppColor.secondPageIconColor),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Filipino SignLanguage",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.secondPageTitleColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Tutorials",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.secondPageTitleColor),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      color.AppColor
                                          .secondPageContainerGradient1stColor,
                                      color.AppColor
                                          .secondPageContainerGradient2ndColor
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "68 min",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 180,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      color.AppColor
                                          .secondPageContainerGradient1stColor,
                                      color.AppColor
                                          .secondPageContainerGradient2ndColor
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.handyman_outlined,
                                    size: 20,
                                    color: color.AppColor.secondPageIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Salin Salita",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 30,
                          right: 30,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: color.AppColor.secondPageIconColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      _playView(context),
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(70)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 63, 66, 66),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Lesson 1: For Starters",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color.AppColor.circuitsColor),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(Icons.loop,
                                size: 30, color: color.AppColor.loopColor),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "reload",
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.setsColor,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(child: _ListView()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playView(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController,
        ),
      ),
    );
  }

  _ontapVideo(int index) {
    CachedVideoPlayerController cachedVideoPlayerController;
    cachedVideoPlayerController =
        CachedVideoPlayerController.network(videoInfo[index]["videoUrl"])
          ..initialize().then((value) => {setState(() {})});
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: cachedVideoPlayerController);
  }

  _ListView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
              onTap: () {
                _ontapVideo(index);
                debugPrint(index.toString());
                setState(() {
                  if (_playArea == false) {
                    _playArea = true;
                  }
                });
              },
              child: _BuildCard(index));
        });
  }

  _BuildCard(int index) {
    return SizedBox(
      height: 135,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(videoInfo[index]["thumbnail"]),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index]["title"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoInfo[index]["time"],
                      style: TextStyle(color: Colors.blue[500]),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xffeaeefc),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "",
                  style: TextStyle(color: Color(0xff839fed)),
                ),
              ),
              Row(
                children: [
                  for (int i = 1; i < 70; i++)
                    i.isEven
                        ? Container(
                            width: 3,
                            height: 1,
                            decoration:
                                const BoxDecoration(color: Color(0xff839fed)),
                          )
                        : Container(
                            height: 1,
                            width: 3,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color? color;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 2.0,
            spreadRadius: .05,
          ), //BoxShadow
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

enum Source { Assets, Network }

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CustomVideoPlayerController _customVideoPlayerController;

  String videoUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  Source currentSource = Source.Assets;
  String assetVideoPath = "assets/videos/whale.mp4";

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController,
            ),
          ),
          _sourceButtons(),
        ],
      ),
    );
  }

  Widget _sourceButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          color: Colors.blue, // Example color, replace with your desired color
          textColor: Colors.white, // Text color
          child: const Text(
            'Network', // Replace 'Button Text' with your desired text
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.Network;
              initializeVideoPlayer(currentSource);
            });
          },
        ),
        MaterialButton(
          color: Colors.blue, // Example color, replace with your desired color
          textColor: Colors.white, // Text color
          child: const Text(
            'Assets', // Replace 'Button Text' with your desired text
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.Assets;
              initializeVideoPlayer(currentSource);
            });
          },
        ),
      ],
    );
  }

// Source source
  void initializeVideoPlayer(Source source) {
    CachedVideoPlayerController cachedVideoPlayerController;
    if (source == Source.Assets) {
      cachedVideoPlayerController =
          CachedVideoPlayerController.asset(assetVideoPath)
            ..initialize().then((value) => {setState(() {})});
    } else if (source == Source.Network) {
      cachedVideoPlayerController =
          CachedVideoPlayerController.network(videoUrl)
            ..initialize().then((value) {
              setState(() {});
            });
    } else {
      return;
    }

    // cachedVideoPlayerController =
    //     CachedVideoPlayerController.asset(assetVideoPath)
    //       ..initialize().then((value) => {setState(() {})});
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: cachedVideoPlayerController);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }
}

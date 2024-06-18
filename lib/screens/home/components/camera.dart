import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class SignLanguageRecognition extends StatefulWidget {
  @override
  _SignLanguageRecognitionState createState() =>
      _SignLanguageRecognitionState();
}

class _SignLanguageRecognitionState extends State<SignLanguageRecognition> {
  CameraController? cameraController;
  CameraImage? cameraImage;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    cameraController?.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        cameraController?.startImageStream((image) {
          setState(() {
            cameraImage = image;
            runModelOnFrame();
          });
        });
      });
    });
  }

  runModelOnFrame() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      if (predictions != null && predictions.isNotEmpty) {
        setState(() {
          output = predictions.first['label'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Language Recognition')),
      body: Column(
        children: [
          Expanded(
            child: cameraController != null &&
                    cameraController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: cameraController!.value.aspectRatio,
                    child: CameraPreview(cameraController!),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              output,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }
}

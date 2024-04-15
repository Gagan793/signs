
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase Core
    loadCamera();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized.');
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }
  }

  void loadCamera() async {
    final cameras = await availableCameras();
    CameraDescription? frontCamera;

    for (var camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera == null) {
      frontCamera = cameras.isNotEmpty ? cameras[0] : null;
    }

    if (frontCamera == null) {
      print("No cameras found.");
      return;
    }

    cameraController = CameraController(frontCamera, ResolutionPreset.veryHigh);
    await cameraController!.initialize();

    if (mounted) {
      setState(() {
        isCameraInitialized = true;
        cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          // Call your face detection method here.
        });
      });
    }
  }

  void _startCamera() {
    if (isCameraInitialized) {
      cameraController!.startImageStream((imageStream) {
        cameraImage = imageStream;
        // Call your face detection method here.
      });
    }
  }

  void _stopCamera() {
    if (isCameraInitialized) {
      cameraController!.stopImageStream();
    }
  }

  @override
  void dispose() {
    _stopCamera();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Camera')),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: isCameraInitialized
                ? AspectRatio(
                    aspectRatio: cameraController!.value.aspectRatio,
                    child: CameraPreview(cameraController!),
                  )
                : CircularProgressIndicator(), // Add a loading indicator.
          ),
        ),
        ElevatedButton(
          onPressed: isCameraInitialized ? _startCamera : null,
          child: Text('Start Camera'),
        ),
        ElevatedButton(
          onPressed: _stopCamera,
          child: Text('Stop Camera'),
        ),
        // Display detected faces or results here.
      ]),
    );
  }
}

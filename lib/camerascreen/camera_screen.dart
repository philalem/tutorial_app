import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../previewscreen/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  Future<void> _initializeVideoFuture;
  List<String> paths = [];
  bool isRecording = false;
  double _width = 60;
  double _height = 60;
  bool _pause = false;
  bool _chooseColor = true;
  var _color = Colors.white;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      _initializeVideoFuture = _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final deviceRatio = width / height;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          _getCamera(deviceRatio, isIOS),
          Positioned(
            bottom: height * 0.05,
            child: Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (_controller.value.isRecordingVideo) {
                        _controller.stopVideoRecording();
                        setState(() {
                          _color = Colors.white;
                          _pause = true;
                          _width = 60;
                          _height = 60;
                        });
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PreviewImageScreen(paths: paths),
                        ),
                      );
                    },
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  _captureControlRowWidget(context, paths),
                  Spacer(
                    flex: 3,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (_controller.value.isRecordingVideo) {
                        _controller.stopVideoRecording();
                        setState(() {
                          _color = Colors.white;
                          _pause = true;
                          _width = 60;
                          _height = 60;
                        });
                      }
                      if (paths.isEmpty) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PreviewImageScreen(paths: paths),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  print("disconnecting camera");
                  _controller.dispose();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: _cameraTogglesRowWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCamera(deviceRatio, isIOS) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }
    return Transform.scale(
      scale:
          _controller.value.aspectRatio / (deviceRatio * (isIOS ? 0.95 : 0.90)),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context, List<String> paths) {
    return Container(
      width: 80.0,
      height: 80.0,
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 0.0,
        child: AnimatedContainer(
          width: _width,
          height: _height,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isRecording ? 10 : 60),
            shape: BoxShape.rectangle,
            color: _color,
          ),
        ),
        onPressed: () {
          setState(() {
            if (isRecording) {
              _color = Colors.white;
              _pause = true;
              _width = 60;
              _height = 60;
            } else {
              _pause = false;
              _color = Colors.red;
              _width = 50;
              _height = 50;
              _startOneSecondTimer();
            }
          });
          _onCapturePressed(context, paths);
        },
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Container();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return IconButton(
      onPressed: _onSwitchCamera,
      icon: Icon(
        _getCameraLensIcon(lensDirection),
        color: Colors.white,
        size: 30,
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera_solid;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  void _onCapturePressed(context, List<String> paths) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      HapticFeedback.mediumImpact();
      String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser uid = await _auth.currentUser();
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/${uid.uid.toString()}/user-posts';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${timestamp()}.mp4';

      if (_controller.value.isRecordingVideo) {
        print("stopping the recording");
        setState(() {
          isRecording = false;
        });
        await _controller.stopVideoRecording();
      } else {
        print("path to recording: " + filePath);
        print("starting the recording");
        setState(() {
          paths.add(filePath);
          isRecording = true;
        });
        await _controller.startVideoRecording(filePath);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }

  void _startOneSecondTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_pause) {
          timer.cancel();
          setState(() {
            _color = Colors.white;
            _chooseColor = true;
          });
        } else {
          setState(() {
            _color = _chooseColor ? Colors.red[200] : Colors.red;
            _chooseColor = !_chooseColor;
          });
        }
      },
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraProvider extends ChangeNotifier {
   CameraController? _cameraController;
  List<XFile> _capturedImages = [];
  int count = 0;

  CameraProvider() {
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    count++;
    final PermissionStatus status = await Permission.camera.status;

    if (status.isDenied) {
      await Permission.camera.request();
    }else if(status.isDenied && count>1){
      openAppSettings();

    }
    
     else {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.low,
      );

      await _cameraController!.initialize();
    }

    notifyListeners();
  }

  CameraController get cameraController => _cameraController!;
  List<XFile> get capturedImages => _capturedImages;

  Future<void> takePicture() async {
    try {
      final XFile picture = await _cameraController!.takePicture();
      _capturedImages.add(picture);
      notifyListeners();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void disposeCamera() {
    _cameraController!.dispose();
  }
}

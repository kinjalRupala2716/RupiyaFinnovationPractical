import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/screens/camera_provider.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  @override
  void initState() {
    super.initState();
    // _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, _) {
        if (cameraProvider.cameraController == null ||
            !cameraProvider.cameraController.value.isInitialized) {
          return Container();
        }

        return Stack(
          children: [
            CameraPreview(cameraProvider.cameraController),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: ElevatedButton(
                onPressed: () {
                  cameraProvider.takePicture();
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        );
      },
    );
  }
}

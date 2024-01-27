import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/model/seats_model.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/widget/camera_preview_widget.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/provider/camera_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;

  PermissionStatus? permissionStatus;
  List<SeatsModel> seatsModel = [];
  CameraProvider? cameraProvider;

  Future<List<SeatsModel>> loadJsonData() async {
    final String data = await rootBundle.loadString('assets/seats.json');
    final List<dynamic> jsonData = jsonDecode(data);

    return jsonData.map((seatJson) => SeatsModel.fromJson(seatJson)).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadSeatData();
    log("welcome");
  }

  Future<void> _loadSeatData() async {
    String jsonData = '''
    {
    "seats": [
        {
            "column": "13",
            "name": "L16",
            "row": "1"
        },
        {
            "column": "12",
            "name": "L15",
            "row": "1"
        },
        {
            "column": "12",
            "name": "L6",
            "row": "3"
        },
        {
            "column": "10",
            "name": "L13",
            "row": "1"
        },
        {
            "column": "10",
            "name": "L5",
            "row": "3"
        },
        {
            "column": "8",
            "name": "L12",
            "row": "0"
        },
        {
            "column": "8",
            "name": "L11",
            "row": "1"
        },
        {
            "column": "8",
            "name": "L4",
            "row": "3"
        },
        {
            "column": "6",
            "name": "L10",
            "row": "0"
        },
        {
            "column": "6",
            "name": "L9",
            "row": "1"
        },
        {
            "column": "6",
            "name": "L3",
            "row": "3"
        },
        {
            "column": "4",
            "name": "L8",
            "row": "0"
        },
        {
            "column": "4",
            "name": "L7",
            "row": "1"
        },
        {
            "column": "4",
            "name": "L2",
            "row": "3"
        },
        {
            "column": "3",
            "name": "8",
            "row": "0"
        },
        {
            "column": "3",
            "name": "7",
            "row": "1"
        },
        {
            "column": "2",
            "name": "6",
            "row": "0"
        },
        {
            "column": "2",
            "name": "5",
            "row": "1"
        },
        {
            "column": "2",
            "name": "L1",
            "row": "3"
        },
        {
            "column": "1",
            "name": "4",
            "row": "0"
        },
        {
            "column": "1",
            "name": "3",
            "row": "1"
        },
        {
            "column": "0",
            "name": "2",
            "row": "0"
        },
        {
            "column": "0",
            "name": "1",
            "row": "1"
        }
    ]
}
    ''';

    Map<String, dynamic> jsonDataMap = json.decode(jsonData);

    setState(() {
      List<dynamic> seatList = jsonDataMap['seats'];
      seatsModel =
          seatList.map((seatJson) => SeatsModel.fromJson(seatJson)).toList();
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Images'),
      ),
      body: Consumer<CameraProvider>(
        builder: (context, cameraProvider, _) {
          return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10),
              // itemCount: cameraProvider.capturedImages.length == 0
              //     ? 0
              //     : cameraProvider.capturedImages.length,
              itemCount:
                  seatsModel.length < cameraProvider.capturedImages.length
                      ? seatsModel.length
                      : cameraProvider.capturedImages.length,
              itemBuilder: (context, index) {
                if (index < cameraProvider.capturedImages.length &&
                    index < seatsModel.length) {
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.amber,
                    child: Stack(
                      children: [
                        Image.file(
                          File(cameraProvider.capturedImages[index].path),
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(
                            seatsModel[index].name == null
                                ? "abc"
                                : seatsModel[index].name.toString(),
                            style: const TextStyle(color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No more pairs.'));
                }
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: permissionStatus == PermissionStatus.denied
            ? Colors.red
            : Colors.green,
        onPressed: () {
          _initializeCamera(context);
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _initializeCamera(BuildContext ctx) async {
    final PermissionStatus status = await Permission.camera.status;
    permissionStatus = status;

    if (status.isDenied) {
      await Permission.camera.request();
      openAppSettings();
    } else {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.low,
      );

      await _cameraController.initialize().then((value) => Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (context) => const CameraPreviewWidget())));
    }
  }
}

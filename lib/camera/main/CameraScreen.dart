import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dvhacks/camera/tools/content.dart';
import 'package:dvhacks/camera/ui/document.dart';
import 'package:dvhacks/camera/ui/processing.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dvhacks/screens/splash.dart';
import 'ConfirmationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CameraScreen1 extends StatefulWidget {
  final bool validity;

  const CameraScreen1({Key key, @required this.validity}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen1> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

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
        print("We couldn't find any cameras");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.ultraHigh,
        enableAudio: false);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
        backgroundColor: const Color(0xFf66D5C1),
        title: Text(
          'Petcare Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () async {
                    print("pressed");
                    await FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => splash())));
                  },
                  child: Icon(
                    Icons.portrait_rounded,
                    color: Colors.black,
                  )))
        ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Container(
              child: _cameraPreviewWidget(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.all(20.0),
              color: Color.fromRGBO(0, 0, 0, .3),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 90.0,
                      ),
                      ButtonTheme(
                        height: 70,
                        child: FloatingActionButton(
                            backgroundColor: const Color(0xFf66D5C1),
                            onPressed: takePicture,
                            child: Icon(
                              Icons.camera,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        width: 90.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  takePicture() {
    snapPic().then((String path) async {
      bool result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationScreen(path)),
      );

      final picture = File(path);

      if (result) {
        MaterialPageRoute loading =
            MaterialPageRoute(builder: (context) => Processing());

        Navigator.push(context, loading);

        String string = "";
        final bytes = picture.readAsBytesSync();
        string = base64.encode(bytes);
        //Navigator.pop(context, string);

        Content content = new Content("CNH", "@file/jpeg", string);

        Response response = await post("http://zionapi.onset.com.br/api/sync/",
            body: jsonEncode(content.toJson()),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });

        Navigator.pop(context, loading);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Document(response.body)),
        );
      }

      picture.delete();
    });
  }

  Future<String> snapPic() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      final Directory extDir = await getTemporaryDirectory();
      final String dirPath = '${extDir.path}/Pitures';
      await new Directory(dirPath).create(recursive: true);
      final String path = '$dirPath/${DateTime.now()}.jpg';

      await controller.takePicture(path);

      return path;
    } on CameraException catch (e) {
      return null;
    }
  }
}

// Developers of petcare giving credit (JT)

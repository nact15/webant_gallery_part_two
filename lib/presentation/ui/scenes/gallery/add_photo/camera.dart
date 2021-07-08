import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/generated/l10n.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;

  Camera({Key key, this.camera}) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool flashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max,
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 15,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 30,
                  child: Center(
                    child: Text(
                      S.of(context).titleCamera,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: IconButton(
                onPressed: () async {
                  setState(() => flashOn = !flashOn);
                  await _controller
                      .setFlashMode(flashOn ? FlashMode.always : FlashMode.off);
                },
                icon: Icon(
                  flashOn ? Icons.flash_on : Icons.flash_off,
                  size: 20,
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final size = MediaQuery.of(context).size;
            final deviceRatio = size.width / size.height;
            return Container(
              child: AspectRatio(
                aspectRatio: deviceRatio,
                child: Transform.scale(
                  scale: 1,
                  alignment: Alignment.center,
                  child: CameraPreview(_controller),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: OutlinedButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final _image = await _controller.takePicture();
              final File image = File(_image.path);
              Navigator.of(context).pop(image);
            } catch (e) {
              print(e);
            }
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 3.0, color: Colors.white),
            shape: CircleBorder(),
          ),
          child: const Icon(
            Icons.circle,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

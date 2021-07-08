import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/select_photo.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;
  File image;

  Camera({Key key, this.camera, this.image}) : super(key: key);

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
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
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
              height: 36,
              width: 36,
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 36,
                  child: Center(
                    child: Text(
                      'Photo',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: IconButton(
                onPressed: () async {
                  setState(() => flashOn = !flashOn);
                  await _controller
                      .setFlashMode(flashOn ? FlashMode.torch : FlashMode.off);
                },
                icon: Icon(
                  flashOn ? Icons.flash_on : Icons.flash_off,
                  size: 22,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final _image = await _controller.takePicture();
            widget.image = File(_image.path);
            Navigator.of(context).pop(context);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(
          Icons.circle,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

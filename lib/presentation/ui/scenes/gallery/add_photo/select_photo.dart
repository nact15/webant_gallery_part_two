import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webant_gallery_part_two/generated/l10n.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/upload_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/choose_photo_bottom_sheet.dart';

import 'camera.dart';

class SelectPhoto extends StatefulWidget {
  const SelectPhoto({Key key}) : super(key: key);

  @override
  _SelectPhotoState createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> {
  File image;
  final _picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    if (imageSource == ImageSource.camera) {
      selectCamera();
    } else {
      final pickedFile = await _picker.getImage(source: imageSource);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorWhite,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: nextPage,
            child: Text(
              S.of(context).buttonNext,
              style: TextStyle(
                fontSize: 17,
                color: AppColors.decorationColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colorOfSearchBar,
                  border: Border(
                    bottom: BorderSide(
                        color: AppColors.mainColorAccent, width: 1.0),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: image == null
                      ? Image.asset(AppStrings.imageAnt)
                      : Image.file(image),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) =>
                            ChoosePhotoBottomSheet(getImage),
                      ),
                      style: AppStyles.styleButtonAlreadyHaveAccount,
                      child: Text(
                        S.of(context).buttonSelectPhoto,
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextPage() {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorNoImage),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UploadPhoto(
            image: image,
          ),
        ),
      );
    }
  }

  Future<CameraDescription> takePicture() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  void selectCamera() async {
    final firstCamera = await takePicture();
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) =>
              Camera(camera: firstCamera, image: image)),
    );
  }
}

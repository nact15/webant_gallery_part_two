import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';

class SelectPhoto extends StatefulWidget {
  const SelectPhoto({Key key}) : super(key: key);

  @override
  _SelectPhotoState createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthButton = MediaQuery.of(context).size.width * 0.91;

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorWhite,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              ('Next'),
              style: TextStyle(
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.colorOfSearchBar,
                border: Border(
                  bottom: BorderSide(color: AppColors.mainColorAccent, width: 1.0),
                ),
              ),
              height: 375,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: _image == null
                    ? Image.asset(AppStrings.imageAnt)
                    : Image.file(_image),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                    width: widthButton,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: getImage,
                      style: AppStyles.styleButtonAlreadyHaveAccount,
                      child: Text(
                        'Select photo',
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

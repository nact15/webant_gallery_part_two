import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webant_gallery_part_two/data/repositories/http_post_photo.dart';
import 'package:webant_gallery_part_two/domain/repositories/firestore_repository.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/upload_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/choose_photo_bottom_sheet.dart';

import 'add_photo_bloc/add_photo_bloc.dart';

class SelectPhoto extends StatefulWidget {
  const SelectPhoto({Key key}) : super(key: key);

  @override
  _SelectPhotoState createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> {
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
              ('Next'),
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
                  child: _image == null
                      ? Image.asset(AppStrings.imageAnt)
                      : Image.file(_image),
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
                        'Select photo',
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
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<AddPhotoBloc>(
            create: (BuildContext context) => AddPhotoBloc(HttpPostPhoto()),
            child: UploadPhoto(
              image: _image,
            ),
          ),
        ),
      );
    }
  }
}

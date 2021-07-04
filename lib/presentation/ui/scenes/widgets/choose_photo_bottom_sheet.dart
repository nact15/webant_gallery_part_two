
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';


class ChoosePhotoBottomSheet extends StatelessWidget {
  ChoosePhotoBottomSheet(this._callBack);
  final void Function(ImageSource) _callBack;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: Align(
            alignment: Alignment.center,
            child: const Text(
              'Camera',
              style: TextStyle(color: AppColors.decorationColor),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _callBack(ImageSource.camera);
          },
        ),
        CupertinoActionSheetAction(
          child: Align(
            alignment: Alignment.center,
            child: const Text(
              'Gallery',
              style: TextStyle(color: AppColors.decorationColor),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _callBack(ImageSource.gallery);
          },
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => Gallery(),
          )),
          color: AppColors.mainColor,
          iconSize: 17,
        );
      },
    );
  }
}

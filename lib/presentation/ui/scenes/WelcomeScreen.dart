import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';

import 'EnterPage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: AppColors.colorGreyAccent
      ),
      title: AppStrings.titleGallery,
      home: EnterPage(),
    );
  }
}

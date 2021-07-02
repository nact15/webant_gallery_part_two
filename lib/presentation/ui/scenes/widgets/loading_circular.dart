import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';

class LoadingCircular extends StatelessWidget {
  const LoadingCircular({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: AppColors.mainColorAccent,
              strokeWidth: 2.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                AppStrings.loading,
                style: TextStyle(color: AppColors.mainColorAccent),
              ),
            ),
          ],
      ),
    );
  }
}

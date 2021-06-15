import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';

import '../login_pages/enter_page.dart';

class AppBarSign extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSign({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 75,
      leading: TextButton(
        child: AppStyles.textCancel,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return EnterPage();
          },
        )),
      ),
      backgroundColor: AppColors.colorWhite,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

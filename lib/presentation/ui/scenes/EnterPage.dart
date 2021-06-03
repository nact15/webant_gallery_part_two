import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';

import 'SignInPage.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key key}) : super(key: key);

  final double heightButton = 36;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 208, 0, 40),
              child: Image.asset(AppStrings.imageAnt),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: AppStyles.textWelcome,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: buttons(context, AppStyles.styleButtonCreateAccount,
                  AppStyles.textCreateAccount),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: buttons(context, AppStyles.styleButtonAlreadyHaveAccount,
                  AppStyles.textAlreadyHaveAccount),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context, ButtonStyle styleButton, Text text) {
    double widthButton = MediaQuery.of(context).size.width * 0.91;

    return SizedBox(
        width: widthButton,
        height: heightButton,
        child: ElevatedButton(
          style: styleButton,
          child: text,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          },
        ),
    );
  }
}

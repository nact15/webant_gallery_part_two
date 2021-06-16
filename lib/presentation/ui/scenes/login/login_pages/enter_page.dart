import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/authorization_bloc/authorization_bloc.dart';

import 'sign_in_page.dart';
import 'sign_up_page.dart';

enum typeTextField { USERNAME, BIRTHDAY, EMAIL, PASSWORD, CONFIRM_PASSWORD, PASSWORD_SIGH_IN, PHONE }

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
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              child: buttons(context, AppStyles.styleButtonCreateAccount,
                  AppStyles.textCreateAccount, SignUpPage()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: buttons(context, AppStyles.styleButtonAlreadyHaveAccount,
                  AppStyles.textAlreadyHaveAccount, SignInPage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons(
      BuildContext context, ButtonStyle styleButton, Text text, page) {
    double widthButton = MediaQuery.of(context).size.width ;
    return SizedBox(
      width: widthButton,
      height: heightButton,
      child: ElevatedButton(
        style: styleButton,
        child: text,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider<AuthorizationBloc>(
                  create: (BuildContext context) => AuthorizationBloc(),
                  child: page,
                ),
              ),
          );
        },
      ),
    );
  }
}

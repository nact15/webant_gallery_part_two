import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/select_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/text_form_fields.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/widget_app_bar.dart';

import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  double heightFields = 36.0;
  double widthButton = 120.0;
  TextEditingController nameController;
  TextEditingController passwordController;
  HttpOauthGateway httpOauthGateway = HttpOauthGateway();

  @override
  void initState() {
    nameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBarSign(),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(AppStrings.signIn, style: AppStyles.styleSign),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormFields(
                    controller: nameController,
                    hint: AppStrings.hintName,
                    typeField: typeTextField.USERNAME,
                    textInputType: TextInputType.name,
                    obscure: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 29),
                  child: TextFormFields(
                    controller: passwordController,
                    hint: AppStrings.hintPassword,
                    typeField: typeTextField.PASSWORD_SIGH_IN,
                    textInputType: TextInputType.visiblePassword,
                    obscure: true,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text(
                        AppStrings.forgotPassOrEmail,
                        style: TextStyle(color: AppColors.mainColorAccent),
                      ),
                      onPressed: () {},
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                    ),
                  ),
                ),
                Padding(
                  //sign in
                  padding: EdgeInsets.only(top: 50),
                  child: SizedBox(
                    height: heightFields,
                    width: widthButton,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.mainColor,
                      ),
                      onPressed: () => ifSignIn(),
                      child: Text(
                        AppStrings.signIn,
                        style: AppStyles.signInButtonMain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  //sign up
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: heightFields,
                    width: widthButton,
                    child: TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        _ifSignup();
                      }, //to SignUpPage
                      child: Text(
                        AppStrings.signUp,
                        style: AppStyles.signUpButtonSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ifSignIn() async {
    if (_formKey.currentState.validate()) {
      try {
        RegistrationModel user = await httpOauthGateway.authorization(
            nameController.text, passwordController.text);
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Gallery(user: user),
            ),
          );
        }
      } on DioError {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppStrings.loginError),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _ifSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }
}

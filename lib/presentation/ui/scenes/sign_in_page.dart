import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/select_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_information/sign_in_info.dart';

import 'sign_up_page.dart';

enum typeTextField { EMAIL, PASSWORD }

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = true;
  double heightFields = 36.0;
  double widthButton = 120.0;

  SignInInfo signInInfo = SignInInfo();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    double widthTextForm = MediaQuery.of(context).size.width * 0.90;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
        ),
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
                  //email
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    width: widthTextForm,
                    height: heightFields,
                    child: TextFormField(
                      inputFormatters: AppStyles.noSpace,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(height: 0),
                          contentPadding: EdgeInsets.all(8.0),
                          focusedBorder: AppStyles.borderTextField.copyWith(
                              borderSide:
                                  BorderSide(color: AppColors.decorationColor)),
                          enabledBorder: AppStyles.borderTextField,
                          focusedErrorBorder: AppStyles.borderTextField,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          hintText: AppStrings.hintEmail,
                          hintStyle:
                              TextStyle(color: AppColors.mainColorAccent),
                          suffixIcon: Icon(
                            Icons.mail_outline,
                            color: AppColors.mainColorAccent,
                          )),
                      validator: (value) =>
                          _selectValidator(value, typeTextField.EMAIL),
                      onChanged: (value) => signInInfo.email = value,
                      //save email value
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                  ),
                ),
                Padding(
                  //password
                  padding: EdgeInsets.only(top: 29),
                  child: SizedBox(
                    width: widthTextForm,
                    height: heightFields,
                    child: TextFormField(
                      inputFormatters: AppStyles.noSpace,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        contentPadding: EdgeInsets.all(8.0),
                        focusedBorder: AppStyles.borderTextField.copyWith(
                            borderSide:
                                BorderSide(color: AppColors.decorationColor)),
                        enabledBorder: AppStyles.borderTextField,
                        focusedErrorBorder: AppStyles.borderTextField,
                        errorBorder: AppStyles.borderTextFieldError,
                        hintText: AppStrings.hintPassword,
                        hintStyle: TextStyle(color: AppColors.mainColorAccent),
                        suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off), //hide password
                            color: AppColors.mainColorAccent,
                            padding: EdgeInsets.all(6.0),
                            onPressed: () {
                              setState(() {
                                  _passwordVisible = !_passwordVisible;
                                },
                              );
                            }),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) =>
                          _selectValidator(value, typeTextField.PASSWORD),
                      onChanged: (value) => signInInfo.password = value,
                      //save password value
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => node.unfocus(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text(AppStrings.forgotPassOrEmail,
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
                      onPressed: () => _ifSignIn(),
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

  String _selectValidator(String value, typeTextField typeField) {
    switch (typeField) {
      case typeTextField.EMAIL:
        if (value == null || value.isEmpty) {
          return AppStrings.emptyEmail;
        } else if (!value.contains('@') || value.length < 3) {
          return AppStrings.incorrectEmail;
        }
        return null;
        break;
      case typeTextField.PASSWORD:
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        } else if (value.length < 8) {
          return 'Password must be longer than 8';
        } else if (!value.contains(RegExp('[a-z]'))) {
          return 'Password must contain at least one lowercase letter';
        }
        return null;
        break;
    }
    return 'Error';
  }

  void _ifSignIn() {
    if (_formKey.currentState.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
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

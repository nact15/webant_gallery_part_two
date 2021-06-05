import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/select_page.dart';

import 'sign_in_page.dart';

enum typeTextField { USERNAME, BIRTHDAY, EMAIL, PASSWORD }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String _password;
  String _email;
  String _userName;
  DateTime _birthday;
  bool _passwordVisible = true;
  double heightTextForm = 36;
  DateTime selectedDate = DateTime.now();
  TextEditingController controller;

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
                  child: Text(AppStrings.signUp, style: AppStyles.styleSign),
                ),
                Padding(
                  //user name
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    width: widthTextForm,
                    height: heightTextForm,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
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
                        hintText: AppStrings.hintName,
                        hintStyle: TextStyle(color: AppColors.mainColorAccent),

                        suffixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.emptyName;
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _userName = value;
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                  ),
                ),
                Padding(
                  //birthday
                  padding: EdgeInsets.only(top: 29),
                  child: Container(
                    width: widthTextForm,
                    height: heightTextForm,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        MaskTextInputFormatter(mask: "##.##.####"),
                        //FilteringTextInputFormatter.deny(RegExp('[А-я]')),
                      ],
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
                          hintText: AppStrings.hintBirthday,
                          hintStyle:
                              TextStyle(color: AppColors.mainColorAccent),
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: AppColors.mainColorAccent,
                          )),
                      validator: (value) =>
                          _selectValidator(value, typeTextField.EMAIL),
                      // onDateSelected: (DateTime value) {
                      //   _birthday = value;
                      // },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                  ),
                ),
                Padding(
                  //email
                  padding: EdgeInsets.only(top: 29),
                  child: Container(
                    width: widthTextForm,
                    height: heightTextForm,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                      onSaved: (String value) {
                        _email = value;
                      },
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
                    height: heightTextForm,
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
                        hintText: AppStrings.hintPassword,
                        hintStyle: TextStyle(color: AppColors.mainColorAccent),
                        suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off), //hide password
                            color: AppColors.mainColorAccent,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(
                                () {
                                  _passwordVisible = !_passwordVisible;
                                },
                              );
                            }),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) =>
                          _selectValidator(value, typeTextField.PASSWORD),
                      // onSaved: (String value) {
                      //   _password = value;
                      // },
                      onChanged: (value) => _password = value,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => node.unfocus(),
                    ),
                  ),
                ),
                Padding(
                  //sign up
                  padding: EdgeInsets.only(top: 70),
                  child: SizedBox(
                    height: 36,
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.mainColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      },
                      child: Text(
                        AppStrings.signUp,
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Padding(
                  //sign up
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 36,
                    width: 120,
                    child: TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        _ifSignup();
                      }, //to SignInPage
                      child: Text(
                        AppStrings.signIn,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mainColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _selectValidator(String value, typeTextField typeField) {
    switch (typeField) {
      case typeTextField.USERNAME:
        if (value.isEmpty) {
          return AppStrings.tooYoung;
        }
        return null;
        break;
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
      case typeTextField.BIRTHDAY:
        // TODO: Handle this case.
        break;
    }
    return 'Error';
  }

  void _ifSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
          //TODO
          //builder: (context) => GalleryScreen(),
          ),
    );
  }

  void _ifSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}

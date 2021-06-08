import 'package:date_text_masked/date_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/data/repositories/http_registration_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/widget_app_bar.dart';

import 'sign_in_page.dart';

enum typeTextField { USERNAME, BIRTHDAY, EMAIL, PASSWORD, CONFIRMPASSWORD }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  RegistrationModel _registrationModel = RegistrationModel();

  bool _passwordVisible = true;
  double heightTextForm = 36;
  DateTime selectedDate = DateTime.now();
  //TextEditingController controller;

  @override
  void initState() {
    //controller = TextEditingController();
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

    double widthTextForm = MediaQuery
        .of(context)
        .size
        .width * 0.90;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        resizeToAvoidBottomInset: true,
        appBar: AppBarSign(),
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child:
                      Text(AppStrings.signUp, style: AppStyles.styleSign),
                    ),
                    Padding(
                      //user name
                      padding: EdgeInsets.only(top: 50),
                      child: Container(
                        width: widthTextForm,
                        height: heightTextForm,
                        child: TextFormField(
                          //controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            contentPadding: EdgeInsets.all(8.0),
                            focusedBorder: AppStyles.borderTextField.copyWith(
                                borderSide: BorderSide(
                                    color: AppColors.decorationColor)),
                            enabledBorder: AppStyles.borderTextField,
                            focusedErrorBorder: AppStyles.borderTextField,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            hintText: AppStrings.hintName,
                            hintStyle:
                            TextStyle(color: AppColors.mainColorAccent),
                            suffixIcon: selectIcon(typeTextField.USERNAME),
                          ),
                          validator: (value) =>
                              _selectValidator(value, typeTextField.USERNAME),
                          onSaved: (String value) {
                            _registrationModel.username = value;
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
                          //controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            MaskTextInputFormatter(mask: "##.##.####"),
                          ],

                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              contentPadding: EdgeInsets.all(8.0),
                              focusedBorder: AppStyles.borderTextField.copyWith(
                                  borderSide: BorderSide(
                                      color: AppColors.decorationColor)),
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
                              suffixIcon: selectIcon(typeTextField.BIRTHDAY)),
                          // validator: (value) =>
                          //     _selectValidator(value, typeTextField.EMAIL),
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
                          //controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: AppStyles.noSpace,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            contentPadding: EdgeInsets.all(8.0),
                            focusedBorder: AppStyles.borderTextField.copyWith(
                                borderSide: BorderSide(
                                    color: AppColors.decorationColor)),
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
                            suffixIcon: selectIcon(typeTextField.EMAIL),
                          ),
                          validator: (value) =>
                              _selectValidator(value, typeTextField.EMAIL),
                          onSaved: (String value) {
                            _registrationModel.email = value;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                        ),
                      ),
                    ),
                    Padding(
                      //old password
                      padding: EdgeInsets.only(top: 29),
                      child: SizedBox(
                        width: widthTextForm,
                        height: heightTextForm,
                        child: TextFormField(
                          //controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: AppStyles.noSpace,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              contentPadding: EdgeInsets.all(8.0),
                              focusedBorder: AppStyles.borderTextField.copyWith(
                                  borderSide: BorderSide(
                                      color: AppColors.decorationColor)),
                              enabledBorder: AppStyles.borderTextField,
                              focusedErrorBorder: AppStyles.borderTextField,
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              hintText: AppStrings.hintOldPassword,
                              hintStyle:
                              TextStyle(color: AppColors.mainColorAccent),
                              suffixIcon: selectIcon(typeTextField.PASSWORD)),
                          obscureText: !_passwordVisible,
                          validator: (value) =>
                              _selectValidator(value, typeTextField.PASSWORD),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),

                        ),
                      ),
                    ),
                    Padding(
                      //confirm password
                      padding: EdgeInsets.only(top: 29),
                      child: SizedBox(
                        width: widthTextForm,
                        height: heightTextForm,
                        child: TextFormField(
                          //controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: AppStyles.noSpace,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            contentPadding: EdgeInsets.all(8.0),
                            focusedBorder: AppStyles.borderTextField.copyWith(
                                borderSide: BorderSide(
                                    color: AppColors.decorationColor)),
                            enabledBorder: AppStyles.borderTextField,
                            focusedErrorBorder: AppStyles.borderTextField,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            hintText: AppStrings.hintOldPassword,
                            hintStyle:
                            TextStyle(color: AppColors.mainColorAccent),
                            suffixIcon: selectIcon(typeTextField.PASSWORD),
                          ),
                          obscureText: !_passwordVisible,
                          validator: (value) =>
                              _selectValidator(value, typeTextField.PASSWORD),
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
                          onPressed: () => _ifSignUp(),
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
                      //sign in
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 36,
                        width: 120,
                        child: TextButton(
                          style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory),
                          onPressed: () {
                            _ifSignIn();
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
        ),
      ),
    );
  }

  Widget selectIcon(typeTextField typeField) {
    switch (typeField) {
      case typeTextField.PASSWORD:
        return IconButton(
            icon: _passwordVisible
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off), //hide password
            color: AppColors.mainColorAccent,
            padding: EdgeInsets.all(6.0),
            onPressed: () {
              setState(
                    () {
                  _passwordVisible = !_passwordVisible;
                },
              );
            });
        break;
      case typeTextField.EMAIL:
        return Icon(
          Icons.mail_outline,
          color: AppColors.mainColorAccent,
        );
        break;
      case typeTextField.USERNAME:
        return Icon(
          Icons.account_circle_outlined,
          color: AppColors.mainColorAccent,
        );
        break;
      case typeTextField.BIRTHDAY:
        return Icon(
          Icons.date_range,
          color: AppColors.mainColorAccent,
        );
      case typeTextField.CONFIRMPASSWORD:
      // TODO: Handle this case.
        break;
    }
    return null;
  }

  String _selectValidator(String value, typeTextField typeField) {
    switch (typeField) {
      case typeTextField.USERNAME:
        if (value == null || value.isEmpty || value.length <= 3) {
          return AppStrings.emptyName;
        }
        return null;
        break;
      case typeTextField.EMAIL:
        if (value == null || value.isEmpty) {
          return AppStrings.emptyEmail;
        } else if (!value.contains('@') ||
            value.length < 3 ||
            !value.contains('.')) {
          return AppStrings.incorrectEmail;
        }
        return null;
        break;
      case typeTextField.PASSWORD:
        if (value == null || value.isEmpty) {
          return AppStrings.emptyPassword;
        } else if (value.length <= 8) {
          return AppStrings.passwordErrorLength;
        } else if (!value.contains(RegExp('[A-Z]'))) {
          return AppStrings.passwordOneLetter;
        }
        return null;
        break;
      case typeTextField.CONFIRMPASSWORD:
        if (value == null || value.isEmpty) {
          return AppStrings.confirmPassword;
        }
        // else if (value != _signUpInfo.password) {
        //   return AppStrings.passwordMatch;
        // }
        return null;
      case typeTextField.BIRTHDAY:
      //TODO
        break;
    }
    return AppStrings.error;
  }

  void _ifSignUp() {
    if (_formKey.currentState.validate()) {
      print(_registrationModel.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Gallery(),
          ),
        );
    }
  }

    void _ifSignIn() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
      );
    }
}


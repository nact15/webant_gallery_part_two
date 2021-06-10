import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_registration_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/select_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/text_form_fields.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/widget_app_bar.dart';

import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  double heightTextForm = 36;
  DateTime selectedDate = DateTime.now();
  TextEditingController nameController;
  TextEditingController birthdayController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneController;

  @override
  void initState() {
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        resizeToAvoidBottomInset: true,
        appBar: AppBarSign(),
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                      //birthday
                      padding: const EdgeInsets.only(top: 29),
                      child: TextFormFields(
                        controller: birthdayController,
                        hint: AppStrings.hintBirthday,
                        typeField: typeTextField.BIRTHDAY,
                        textInputType: TextInputType.datetime,
                        textInputFormatter: <TextInputFormatter>[
                          MaskTextInputFormatter(
                              mask: (AppStrings.dateMask),
                              filter: {"#": RegExp(r'[0-9]')})
                        ],
                        obscure: false,
                      ),
                    ),
                    Padding(
                      //email
                      padding: EdgeInsets.only(top: 29),
                      child: TextFormFields(
                        controller: emailController,
                        hint: AppStrings.hintEmail,
                        typeField: typeTextField.EMAIL,
                        textInputType: TextInputType.emailAddress,
                        obscure: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 29),
                      child: TextFormFields(
                        controller: phoneController,
                        hint: AppStrings.hintPhone,
                        typeField: typeTextField.PHONE,
                        textInputType: TextInputType.phone,
                        textInputFormatter: <TextInputFormatter>[
                          MaskTextInputFormatter(mask: (AppStrings.phoneMask),
                          filter: {"#": RegExp(r'[0-9]')}),
                        ],
                        obscure: false,
                      ),
                    ),
                    Padding(
                      //password
                      padding: EdgeInsets.only(top: 29),
                      child: TextFormFields(
                        controller: passwordController,
                        hint: AppStrings.hintOldPassword,
                        typeField: typeTextField.PASSWORD,
                        textInputType: TextInputType.visiblePassword,
                        obscure: true,
                      ),
                    ),
                    Padding(
                      //confirm password
                      padding: EdgeInsets.only(top: 29),
                      child: TextFormFields(
                        controller: passwordController,
                        hint: AppStrings.hintConfirmPassword,
                        typeField: typeTextField.CONFIRM_PASSWORD,
                        textInputType: TextInputType.visiblePassword,
                        obscure: true,
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
                          onPressed: () => ifSignUp(),
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

  void ifSignUp() async {
    if (_formKey.currentState.validate()) {
      try {
        print(birthdayController.text ?? DateTime.now().toString());
        print(DateTime.now().toString());
        HttpRegistrationGateway().registration(
            username: nameController.text,
            password: passwordController.text,
            birthday: birthdayController.text.isNotEmpty
                ? birthdayController.text
                : DateTime.now().toString(),
            email: emailController.text,
            phone: phoneController.text);
        RegistrationModel user = await HttpOauthGateway().authorization(
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

  void _ifSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}

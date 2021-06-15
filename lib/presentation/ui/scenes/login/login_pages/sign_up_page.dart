import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_registration_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/text_form_fields.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/widget_app_bar.dart';

import 'enter_bloc/authorization_bloc.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  UserModel userModel;

  double heightTextForm = 36;
  DateTime selectedDate = DateTime.now();
  TextEditingController nameController;
  TextEditingController birthdayController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneController;
  TextEditingController confirmPasswordController;
  ScrollController scrollController;
  bool buttonColor;

  @override
  void initState() {
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    confirmPasswordController = TextEditingController();
    buttonColor = true;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationBloc, AuthorizationState>(
      listener: (context, state) {
        if (state is ErrorAuthorization) {
          setState(() => buttonColor = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.loginError),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, state) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          resizeToAvoidBottomInset: true,
          appBar: AppBarSign(),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(AppStrings.signUp, style: AppStyles.styleSign),
                  ),
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
                    scrollController: scrollController,
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
                    scrollController: scrollController,
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
                    scrollController: scrollController,
                  ),
                ),
                Padding(
                  //phone
                  padding: EdgeInsets.only(top: 29),
                  child: TextFormFields(
                    controller: phoneController,
                    hint: AppStrings.hintPhone,
                    typeField: typeTextField.PHONE,
                    textInputType: TextInputType.phone,
                    textInputFormatter: <TextInputFormatter>[
                      MaskTextInputFormatter(
                          mask: (AppStrings.phoneMask),
                          filter: {"#": RegExp(r'[0-9]')}),
                    ],
                    obscure: false,
                    scrollController: scrollController,
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
                    scrollController: scrollController,
                  ),
                ),
                Padding(
                  //confirm password
                  padding: EdgeInsets.only(top: 29),
                  child: TextFormFields(
                    controller: confirmPasswordController,
                    hint: AppStrings.hintConfirmPassword,
                    typeField: typeTextField.CONFIRM_PASSWORD,
                    textInputType: TextInputType.visiblePassword,
                    obscure: true,
                    scrollController: scrollController,
                  ),
                ),
                Center(
                  child: Padding(
                    //sign up
                    padding: EdgeInsets.only(top: 29),
                    child: SizedBox(
                      height: 36,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: AppColors.colorWhite,
                          splashFactory: NoSplash.splashFactory,
                          primary:
                              buttonColor ? AppColors.mainColor : Colors.white,
                        ),
                        onPressed: () => addSignUpEvent(),
                        child: signUp(),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    //sign in
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: 36,
                      width: 120,
                      child: TextButton(
                        style:
                            ButtonStyle(splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          signIn();
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addSignUpEvent() {
    if (_formKey.currentState.validate()) {
      context.read<AuthorizationBloc>().add(
            AuthorizationSignUpEvent(
              name: nameController.text,
              password: passwordController.text,
              email: emailController.text,
              phone: phoneController.text,
              birthday: birthdayController.text.isNotEmpty
                  ? birthdayController.text
                  : DateTime.now().toString(),
            ),
          );
    }
  }

  Widget signUp() {
    return BlocBuilder<AuthorizationBloc, AuthorizationState>(
        builder: (context, state) {
      if (state is LoadingAuthorization) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => buttonColor = false);
        });
        return CircularProgressIndicator(
          color: AppColors.mainColorAccent,
        );
      }
      if (state is AccessAuthorization) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Gallery(
                user: state.user,
              ),
            ),
          );
        });
      }
      return Text(
        AppStrings.signIn,
        style: AppStyles.signInButtonMain,
      );
    });
  }

  void signIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}

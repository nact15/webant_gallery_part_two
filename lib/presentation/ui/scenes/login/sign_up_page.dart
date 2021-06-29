import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webant_gallery_part_two/domain/usecases/validation.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/password_inputs.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/user_text_fields.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/widget_app_bar.dart';

import 'authorization_bloc/authorization_bloc.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController;
  TextEditingController birthdayController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneController;
  TextEditingController confirmPasswordController;
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
    final node = FocusScope.of(context);

    return BlocConsumer<AuthorizationBloc, AuthorizationState>(
      listener: (context, state) {
        if (state is ErrorAuthorization) {
          setState(() => buttonColor = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.err),
              backgroundColor: Colors.red,
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
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(AppStrings.signUp, style: AppStyles.styleSign),
                  ),
                ),
                Padding(
                  //user name
                  padding: const EdgeInsets.only(top: 40),
                  child: TextFormFields(
                    controller: nameController,
                    hint: AppStrings.hintName,
                    typeField: typeTextField.USERNAME,
                    textInputType: TextInputType.name,
                    node: node,
                  ),
                ),
                Padding(
                  //birthday
                  padding: const EdgeInsets.only(top: 29),
                  child: TextFormFields(
                    controller: birthdayController,
                    hint: AppStrings.hintBirthday,
                    typeField: typeTextField.BIRTHDAY,
                    textInputType: TextInputType.number,
                    textInputFormatter: <TextInputFormatter>[
                      MaskTextInputFormatter(
                          mask: (AppStrings.dateMask),
                          filter: {"#": RegExp(r'[0-9]')})
                    ],
                    node: node,
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
                    node: node,
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
                    node: node,
                  ),
                ),
                Padding(
                  //password
                  padding: EdgeInsets.only(top: 29),
                  child: PasswordInputs(
                    typeField: typePasswordField.NEW_PASSWORD,
                    controller: passwordController,
                    hint: 'Password',
                    node: node,
                    validation: Validation(),
                  ),
                ),
                Padding(
                  //confirm password
                  padding: EdgeInsets.only(top: 29),
                  child: PasswordInputs(
                    typeField: typePasswordField.CONFIRM_PASSWORD,
                    controller: confirmPasswordController,
                    hint: 'Confirm password',
                    node: node,
                    confirmPasswordController: passwordController,
                    callBack: addSignUpEvent,
                    validation: Validation(),
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
                        onPressed: () {
                          node.unfocus();
                          addSignUpEvent();
                        },
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
                        onPressed: signIn, //to SignInPage
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
            SignUpEvent(
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
        context.read<AuthorizationBloc>().add(LoginFetch());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Gallery(),
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

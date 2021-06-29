import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
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
  bool buttonColor = true;

  @override
  void initState() {
    nameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
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
              //duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          appBar: AppBarSign(),
          body: Form(
            key: _formKey,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(AppStrings.signIn, style: AppStyles.styleSign),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormFields(
                    controller: nameController,
                    hint: AppStrings.hintName,
                    typeField: typeTextField.USERNAME,
                    textInputType: TextInputType.name,
                    node: node,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 29),
                  child: PasswordInputs(
                    typeField: typePasswordField.OLD_PASSWORD,
                    controller: passwordController,
                    hint: 'Password',
                    node: node,
                    callBack: addLoginEvent,
                    validation: Validation(),
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
                Center(
                  child: Padding(
                    //sign in
                    padding: EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: heightFields,
                      width: widthButton,
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
                          addLoginEvent();
                        },
                        child: signIn(),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    //sign up
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: heightFields,
                      width: widthButton,
                      child: TextButton(
                        style:
                            ButtonStyle(splashFactory: NoSplash.splashFactory),
                        onPressed: signup, //to SignUpPage
                        child: Text(
                          AppStrings.signUp,
                          style: AppStyles.signUpButtonSecondary,
                        ),
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

  void addLoginEvent() {
    if (_formKey.currentState.validate()) {
      context
          .read<AuthorizationBloc>()
          .add(SignInEvent(nameController.text, passwordController.text));
    }
  }

  Widget signIn() {
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

  void signup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }
}

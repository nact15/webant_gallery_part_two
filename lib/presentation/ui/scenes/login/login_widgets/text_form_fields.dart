import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/select_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/sign_in_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/sign_up_page.dart';

class TextFormFields extends StatefulWidget {
  const TextFormFields(
      {Key key,
      this.controller,
      this.hint,
      this.typeField,
      this.textInputType,
      this.obscure, this.textInputFormatter})
      : super(key: key);
  final TextEditingController controller;
  final String hint;
  final typeTextField typeField;
  final TextInputType textInputType;
  final bool obscure;
  final List<TextInputFormatter> textInputFormatter;

  @override
  _TextFormFieldsState createState() => _TextFormFieldsState(
      controller, hint, typeField, textInputType, obscure, textInputFormatter);
}

class _TextFormFieldsState extends State<TextFormFields> {
  _TextFormFieldsState(this.controller, this.hint, this.typeField,
      this.textInputType, this.obscure, this.textInputFormatter);

  TextEditingController controller;
  String hint;
  typeTextField typeField;
  TextInputType textInputType;
  bool _passwordVisible = true;
  bool obscure = false;
  List<TextInputFormatter> textInputFormatter;
  String password;
  double heightFields = 36.0;
  double widthButton = 120.0;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthTextForm = MediaQuery.of(context).size.width * 0.90;

    final node = FocusScope.of(context);
    return Container(
      width: widthTextForm,
      height: heightFields,
      child: TextFormField(
        cursorColor: AppColors.mainColorAccent,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: textInputType,
        inputFormatters: textInputFormatter,
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0),
          contentPadding: EdgeInsets.all(8.0),
          focusedBorder: AppStyles.borderTextField.copyWith(
              borderSide: BorderSide(color: AppColors.decorationColor)),
          enabledBorder: AppStyles.borderTextField,
          focusedErrorBorder: AppStyles.borderTextField,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.mainColorAccent),
          suffixIcon: selectIcon(typeField),
        ),
        obscureText: obscure ? !_passwordVisible : false,
        obscuringCharacter: '*',
        validator: (value) => _selectValidator(value, typeField),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => typeField == typeTextField.CONFIRM_PASSWORD
            ? node.unfocus()
            : node.nextFocus(),
      ),
    );
  }

  Widget selectIcon(typeTextField typeField) {
    switch (typeField) {
      case typeTextField.PASSWORD_SIGH_IN:
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
      case typeTextField.CONFIRM_PASSWORD:
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
                  password = controller.text;
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
      case typeTextField.PHONE:
        return Icon(Icons.phone, color: AppColors.mainColorAccent,);
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
      case typeTextField.CONFIRM_PASSWORD:
        if (value == null || value.isEmpty) {
          return AppStrings.confirmPassword;
        }
        else if (value != password) {
          return AppStrings.passwordMatch;
        }
        return null;
      case typeTextField.BIRTHDAY:
        return null;
        break;
      case typeTextField.PASSWORD_SIGH_IN:
        if (value == null || value.isEmpty) {
          return AppStrings.emptyPassword;
        }
        return null;
      case typeTextField.PHONE:
        if (value.isEmpty || value == null){
          return 'Please enter a phone number';
        } else if (value.length <18){
          return 'Phone number is too short';
        } return null;
    }
    return AppStrings.error;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/validation.dart';

class PasswordTextFields extends StatefulWidget {
  PasswordTextFields(
      {Key key,
      this.typeField,
      this.controller,
      this.hint,})
      : super(key: key);
  final typeTextField typeField;
  final TextEditingController controller;
  final String hint;

  @override
  _PasswordTextFieldsState createState() =>
      _PasswordTextFieldsState(typeField, controller, hint);
}

class _PasswordTextFieldsState extends State<PasswordTextFields> {
  typeTextField typeField;
  bool _passwordVisible;
  TextEditingController controller;
  String hint;
  String confirmPassword;

  _PasswordTextFieldsState(
      this.typeField, this.controller, this.hint,);

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SizedBox(
      //height: heightFields,
      child: TextFormField(
        cursorColor: AppColors.mainColorAccent,
        cursorHeight: 20,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          //errorStyle: TextStyle(height: 0),
          contentPadding: EdgeInsets.all(6),
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
          hintStyle: TextStyle(
            color: AppColors.mainColorAccent,
          ),
          suffixIcon: IconButton(
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
              }),
        ),
        obscureText: !_passwordVisible,
        obscuringCharacter: '*',
        validator: (value) => Validation().selectValidator(
            value: value,
            typeField: typeField,
            confirmPassword: confirmPassword),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }
}

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
      this.hint,
      this.node,
      this.callBack})
      : super(key: key);
  final typeTextField typeField;
  final TextEditingController controller;
  final String hint;
  final node;
  final VoidCallback callBack;

  @override
  _PasswordTextFieldsState createState() =>
      _PasswordTextFieldsState(typeField, controller, hint, node, callBack);
}

class _PasswordTextFieldsState extends State<PasswordTextFields> {
  typeTextField typeField;
  bool _passwordVisible;
  TextEditingController controller;
  String hint;
  String confirmPassword;
  var node;
  VoidCallback callBack;
  Validation validation;

  _PasswordTextFieldsState(
      this.typeField, this.controller, this.hint, this.node, this.callBack);

  @override
  void initState() {
    _passwordVisible = false;
    validation = Validation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: AppColors.mainColorAccent,
        cursorHeight: 20,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
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
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _passwordVisible = !_passwordVisible),
            child: Icon(
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off, //hide password
              color: AppColors.mainColorAccent,
            ),
          ),
        ),
        obscureText: !_passwordVisible,
        obscuringCharacter: '*',
        validator: (value) => validation.selectValidator(
            value: value,
            typeField: typeField,
            confirmPassword: confirmPassword),
        textInputAction: typeField == typeTextField.PASSWORD ? TextInputAction.next : TextInputAction.go,
        onEditingComplete: () {
          if (typeField == typeTextField.PASSWORD) {
            node.unfocus();
          }
          else{
            callBack();
            node.unfocus();
          }
        },
    );
  }
}

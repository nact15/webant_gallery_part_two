import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/validation.dart';

class PasswordInputs extends StatefulWidget {
  const PasswordInputs(
      {Key key,
      this.controller,
      this.confirmPasswordController,
      this.hint,
      this.typeField,
      this.callBack,
      this.node,
      this.validation})
      : super(key: key);
  final TextEditingController controller;
  final TextEditingController confirmPasswordController;
  final String hint;
  final typePasswordField typeField;
  final VoidCallback callBack;
  final node;
  final validation;

  @override
  _PasswordInputsState createState() => _PasswordInputsState(
      controller: controller,
      confirmPasswordController: confirmPasswordController,
      label: hint,
      typeField: typeField,
      callBack: callBack,
      node: node,
      validation: validation);
}

class _PasswordInputsState extends State<PasswordInputs> {
  TextEditingController controller;
  TextEditingController confirmPasswordController;
  String label;
  typePasswordField typeField;
  VoidCallback callBack;
  var validation;
  var node;

  _PasswordInputsState(
      {this.controller,
      this.confirmPasswordController,
      this.label,
      this.typeField,
      this.callBack,
      this.node,
      this.validation});

  bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
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
        focusedBorder: AppStyles.borderTextField
            .copyWith(borderSide: BorderSide(color: AppColors.decorationColor)),
        enabledBorder: AppStyles.borderTextField,
        focusedErrorBorder: AppStyles.borderTextField,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
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
      validator: (value) => validation.selectPasswordValidator(
          value, typeField, confirmPasswordController),
      textInputAction:
          callBack != null ? TextInputAction.go : TextInputAction.next,
      onEditingComplete: () {
        if (callBack != null) {
          callBack();
          node.unfocus();
        } else {
          node.nextFocus();
        }
      },
    );
  }
}

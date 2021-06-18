import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';

class IconsFields extends StatefulWidget {
  const IconsFields({Key key, this.typeField, this.passwordVisible})
      : super(key: key);
  final typeTextField typeField;
  final bool passwordVisible;

  @override
  _IconsFieldsState createState() =>
      _IconsFieldsState(typeField, passwordVisible);
}

class _IconsFieldsState extends State<IconsFields> {
  final typeTextField typeField;
  bool passwordVisible;

  _IconsFieldsState(this.typeField, this.passwordVisible);

  @override
  Widget build(BuildContext context) {
    switch (typeField) {
      case typeTextField.PASSWORD_SIGH_IN:
        return IconButton(
            icon: passwordVisible
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off), //hide password
            color: AppColors.mainColorAccent,
            padding: EdgeInsets.all(6.0),
            onPressed: () {
              setState(
                () {
                  passwordVisible = !passwordVisible;
                },
              );
            });
        break;
      case typeTextField.PASSWORD:
        return GestureDetector(
          child: Icon(
            passwordVisible
                ? Icons.visibility
                : Icons.visibility_off, //hide password
            color: AppColors.mainColorAccent,
          ),
          onTap: () {
            setState(() => passwordVisible = !passwordVisible);
          },
        );
        break;
      case typeTextField.CONFIRM_PASSWORD:
        return GestureDetector(
          child: Icon(
            passwordVisible
                ? Icons.visibility
                : Icons.visibility_off, //hide password
            color: AppColors.mainColorAccent,
          ),
          onTap: () {
            setState(() => passwordVisible = !passwordVisible);
          },
        );
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
        return Icon(
          Icons.phone,
          color: AppColors.mainColorAccent,
        );
    }
    return null;
  }
}

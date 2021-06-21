import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';

class InputIcons extends StatefulWidget {
  const InputIcons({Key key, this.typeField, this.passwordVisible})
      : super(key: key);
  final typeTextField typeField;
  final bool passwordVisible;

  @override
  _InputIconsState createState() =>
      _InputIconsState(typeField, passwordVisible);
}

class _InputIconsState extends State<InputIcons> {
  final typeTextField typeField;
  bool passwordVisible;

  _InputIconsState(this.typeField, this.passwordVisible);

  @override
  Widget build(BuildContext context) {
    switch (typeField) {
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
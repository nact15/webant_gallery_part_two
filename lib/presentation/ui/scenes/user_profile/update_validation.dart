import 'package:flutter/cupertino.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';

class UpdateValidation {
  String selectPasswordValidator(String value, typePasswordField typeField,
      TextEditingController confirmPasswordController) {
    switch (typeField) {
      case typePasswordField.NEW_PASSWORD:
        if (value.isNotEmpty) {
          if (value.length < 8) {
            return AppStrings.passwordErrorLength;
          } else if (!value.contains(RegExp('[A-Z]'))) {
            return AppStrings.passwordOneLetter;
          }
        }
        return null;
        break;
      case typePasswordField.CONFIRM_PASSWORD:
        if (value.isNotEmpty && value != confirmPasswordController.text) {
          return AppStrings.passwordMatch;
        }
        return null;
        break;
      case typePasswordField.OLD_PASSWORD:
        return null;
        break;
    }
    return null;
  }
}

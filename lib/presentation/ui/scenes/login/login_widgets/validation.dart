import 'package:intl/intl.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';

class Validation {

  DateTime toDate(String birthday) {
    DateTime date = DateFormat("dd.MM.yyyy").parseLoose(birthday);
    return date;
  }
  String confirmPassword;

  String selectValidator(
      {String value, typeTextField typeField, String confirmPassword}) {
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
      //   if (value == null || value.isEmpty) {
      //     return AppStrings.confirmPassword;
      //   } else if (value != confirmPassword) {
      //     return AppStrings.passwordMatch;
      //   }
      return null;
      break;
      case typeTextField.BIRTHDAY:
        try {
          if (value.length == 10) {
            DateTime birthday = toDate(value);
            DateTime today = DateTime.now();
            int yearDiff = today.year - birthday.year;
            DateTime adultDate = DateTime(
              birthday.year + 18,
              birthday.month,
              birthday.day,
            );
            if (adultDate.isAfter(today)) {
              return AppStrings.tooYoung;
            } else if (yearDiff > 100) {
              return 'You are too old!';
            }
          }
        } catch (e) {
          return 'Invalid date';
        }
        return null;
        break;
      case typeTextField.PASSWORD_SIGH_IN:
        if (value == null || value.isEmpty) {
          return AppStrings.emptyPassword;
        }
        return null;
      case typeTextField.PHONE:
        if (value.isEmpty || value == null) {
          return 'Please enter a phone number';
        } else if (value.length < 15) {
          return 'Phone number is too short';
        }
        return null;
    }
    return AppStrings.error;
  }
}

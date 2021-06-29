import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webant_gallery_part_two/domain/usecases/validation.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';

import 'input_icons.dart';

class TextFormFields extends StatefulWidget {
  const TextFormFields(
      {Key key,
      this.controller,
      this.hint,
      this.typeField,
      this.textInputType,
      this.textInputFormatter,
      this.scrollController, this.node})
      : super(key: key);
  final TextEditingController controller;
  final ScrollController scrollController;
  final String hint;
  final typeTextField typeField;
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatter;
  final node;

  @override
  _TextFormFieldsState createState() => _TextFormFieldsState(controller, hint,
      typeField, textInputType, textInputFormatter, node);
}

class _TextFormFieldsState extends State<TextFormFields> {
  _TextFormFieldsState(
      this.controller,
      this.label,
      this.typeField,
      this.textInputType,
      this.textInputFormatter,
      this.node);

  TextEditingController controller;
  String label;
  typeTextField typeField;
  TextInputType textInputType;
  var node;
  List<TextInputFormatter> textInputFormatter;
  Validation validation = Validation();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: AppColors.mainColorAccent,
        cursorHeight: 20,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: textInputType,
        inputFormatters: textInputFormatter,
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
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.mainColorAccent,
          ),
          prefixIcon: Padding(
              padding: EdgeInsets.only(left: 5, bottom: 2),
              child: typeField == typeTextField.PHONE
                  ? Text('+7 ',
                      style: TextStyle(
                          fontSize: 17, color: AppColors.mainColorAccent),
                    )
                  : null),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: InputIcons(typeField: typeField),
        ),
        validator: (value) => validation.selectUserValidator(value: value, typeField: typeField),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
    );
  }
}

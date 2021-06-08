import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/user_page.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key key, this.user}) : super(key: key);
  final RegistrationModel user;

  @override
  _UserSettingsState createState() => _UserSettingsState(user);
}

class _UserSettingsState extends State<UserSettings> {
  _UserSettingsState(this.user);

  RegistrationModel user;
  final _formKey = GlobalKey<FormState>();
  double heightFields = 36.0;
  double widthButton = 120.0;

  @override
  Widget build(BuildContext context) {

    double widthTextForm = MediaQuery.of(context).size.width * 0.90;

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        leadingWidth: 75,
        backgroundColor: AppColors.colorWhite,
        elevation: 1,
        leading: TextButton(
          child: AppStyles.textCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(
                  color: AppColors.decorationColor,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 21),
              child: Center(
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    iconSize: 55,
                    color: AppColors.mainColorAccent,
                    onPressed: () {},
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColorAccent),
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                  ),
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Upload photo',
                  style: TextStyle(
                    color: AppColors.mainColorAccent,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 44, 0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal data',
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: widthTextForm,
                  height: heightFields,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      contentPadding: EdgeInsets.all(8.0),
                      focusedBorder: AppStyles.borderTextField.copyWith(
                          borderSide:
                          BorderSide(color: AppColors.decorationColor)),
                      enabledBorder: AppStyles.borderTextField,
                      focusedErrorBorder: AppStyles.borderTextField,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      hintStyle: TextStyle(color: AppColors.mainColorAccent),
                      suffixIcon: Icon(Icons.account_circle, color: AppColors.mainColorAccent,),
                    ),
                    initialValue: user.username,
                    // validator: (value) =>
                    //     _selectValidator(value, typeTextField.EMAIL),
                  ),
                ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}

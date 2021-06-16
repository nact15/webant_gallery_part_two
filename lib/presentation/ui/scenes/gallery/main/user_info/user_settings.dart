import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/user_info/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_widgets/text_form_fields.dart';

import 'alert_log_out_dialog.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  _UserSettingsState createState() => _UserSettingsState(user);
}

class _UserSettingsState extends State<UserSettings> {
  _UserSettingsState(this.user);

  UserModel user;
  final _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  final dateFormatter = DateFormat('dd.MM.yyyy');
  TextEditingController _nameController;
  TextEditingController _birthdayController;
  TextEditingController _emailController;
  String name;

  @override
  void initState() {
    _nameController = TextEditingController(text: user.username);
    _birthdayController = TextEditingController(text: toDate(user.birthday));
    _emailController = TextEditingController(text: user.email);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  DateTime fromDate(String stringDate) {
    return DateTime.parse(stringDate);
  }

  String toDate(stringDate) {
    var date = dateFormatter.format(DateTime.parse(stringDate));
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is Exit) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => EnterPage()),
                (Route<dynamic> route) => false);
          });
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    user = UserModel(
                        username: _nameController.text,
                        birthday: _birthdayController.text,
                        email: _emailController.text);
                    print(user.toJson());
                    //context.read<UserBloc>().add(UpdateUser(user));
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: AppColors.decorationColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 21),
                  child: Center(
                    child: GestureDetector(
                      onTap: getImage,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainColorAccent),
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                        ),
                        child: _image == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 55,
                                color: AppColors.mainColorAccent,
                              )
                            : ClipOval(
                                child: Image.file(
                                  _image,
                                  scale: 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                    onPressed: getImage,
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
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.personalData,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  //name
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormFields(
                    controller: _nameController,
                    hint: AppStrings.hintName,
                    typeField: typeTextField.USERNAME,
                    textInputType: TextInputType.name,
                  ),
                ),
                Padding(
                  //birthday
                  padding: EdgeInsets.only(top: 29),
                  child: TextFormFields(
                    controller: _birthdayController,
                    hint: AppStrings.hintBirthday,
                    typeField: typeTextField.BIRTHDAY,
                    textInputType: TextInputType.number,
                    textInputFormatter: <TextInputFormatter>[
                      MaskTextInputFormatter(
                          mask: (AppStrings.dateMask),
                          filter: {"#": RegExp(r'[0-9]')})
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 39),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'E-mail address',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  //email
                  padding: EdgeInsets.only(top: 20),
                  child: TextFormFields(
                    controller: _emailController,
                    hint: AppStrings.hintEmail,
                    typeField: typeTextField.EMAIL,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 39),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 71),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => showAlertDialog(context),
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      child: Text(
                        'Sign out',
                        style: TextStyle(color: AppColors.decorationColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

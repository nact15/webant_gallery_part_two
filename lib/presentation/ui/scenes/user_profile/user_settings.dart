import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/usecases/date_formatter.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/enter_page.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/sign_out_dialog.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/update_validation.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/back_widget.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/password_inputs.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/user_text_fields.dart';

import '../widgets/choose_photo_bottom_sheet.dart';
import 'delete_account_dialog.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  _UserSettingsState();

  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  File _image;
  final picker = ImagePicker();
  TextEditingController _nameController;
  TextEditingController _birthdayController;
  TextEditingController _emailController;
  TextEditingController _oldPasswordController;
  TextEditingController _newPasswordController;
  TextEditingController _confirmPasswordController;
  String confirmPassword;
  String name;
  UserModel user;
  DateFormatter dateFormatter;

  @override
  void initState() {
    _nameController = TextEditingController();
    _birthdayController = TextEditingController();
    _emailController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    dateFormatter = DateFormatter();
    _newPasswordController.addListener(() {
      setState(() {
        confirmPassword = _newPasswordController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        leadingWidth: 75,
        backgroundColor: AppColors.colorWhite,
        elevation: 1,
        leading: BackWidget(),
        actions: [
          TextButton(
            onPressed: () => updateUser(),
            child: Text(
              'Save',
              style: TextStyle(
                  color: AppColors.decorationColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserData) {
            if (state.isUpdate) {
              Fluttertoast.showToast(
                  msg: 'User profile has been updated',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppColors.mainColorAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          if (state is Exit) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => EnterPage()),
                (Route<dynamic> route) => false);
          }
          if (state is ErrorUpdate) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.err),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is UserUpdate) {
            Fluttertoast.showToast(
                msg: 'User profile has been updated',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.mainColorAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          if (state is LoadingUpdate) {
            return Center(
              child: LoadingCircular(),
            );
          }
          if (state is UserData) {
            user = state.user;
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 21),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              ChoosePhotoBottomSheet(getImage),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.mainColorAccent,
                            ),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              child: _image == null
                                  ? Icon(Icons.camera_alt,
                                      size: 55,
                                      color: AppColors.mainColorAccent)
                                  : CircleAvatar(
                                      backgroundImage: Image.file(_image).image,
                                      radius: 55,
                                      backgroundColor: AppColors.colorWhite,
                                    ),
                              radius: 50,
                              backgroundColor: AppColors.colorWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) =>
                            ChoosePhotoBottomSheet(getImage),
                      ),
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
                    padding: EdgeInsets.only(top: 20.0),
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
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextFormFields(
                      controller: _nameController
                        ..text = user.username,
                      hint: AppStrings.hintName,
                      typeField: typeTextField.USERNAME,
                      textInputType: TextInputType.name,
                      node: node,
                    ),
                  ),
                  Padding(
                    //birthday
                    padding: EdgeInsets.only(top: 29.0),
                    child: TextFormFields(
                      controller: _birthdayController
                        ..text = dateFormatter.fromDate(user.birthday),
                      hint: AppStrings.hintBirthday,
                      typeField: typeTextField.BIRTHDAY,
                      textInputType: TextInputType.number,
                      node: node,
                      textInputFormatter: <TextInputFormatter>[
                        MaskTextInputFormatter(
                            mask: (AppStrings.dateMask),
                            filter: {"#": RegExp(r'[0-9]')})
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 39.0),
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
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextFormFields(
                      controller: _emailController
                        ..text = user.email,
                      hint: AppStrings.hintEmail,
                      typeField: typeTextField.EMAIL,
                      textInputType: TextInputType.emailAddress,
                      node: node,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 39.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: PasswordInputs(
                      typeField: typePasswordField.OLD_PASSWORD,
                      controller: _oldPasswordController,
                      hint: 'Old password',
                      node: node,
                      validation: UpdateValidation(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 29.0),
                    child: PasswordInputs(
                      typeField: typePasswordField.NEW_PASSWORD,
                      controller: _newPasswordController,
                      hint: 'New password',
                      node: node,
                      validation: UpdateValidation(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 29.0),
                    child: PasswordInputs(
                      typeField: typePasswordField.CONFIRM_PASSWORD,
                      controller: _confirmPasswordController,
                      hint: 'Confirm password',
                      confirmPasswordController: _newPasswordController,
                      node: node,
                      validation: UpdateValidation(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 6.0),
                    child: Row(
                      children: <Widget>[
                        Text('You can'),
                        TextButton(
                          onPressed: () =>
                              showDeleteAccountDialog(context, user),
                          style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory),
                          child: Text(
                            'delete you account',
                            style: TextStyle(color: AppColors.decorationColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => showSignOutDialog(context),
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      child: Text(
                        'Sign out',
                        style: TextStyle(color: AppColors.decorationColor),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void updateUser() {
    if (_formKey.currentState.validate()) {
      user = user.copyWith(
          email: _emailController.text,
          username: _nameController.text,
          birthday: _birthdayController.text);
      context.read<UserBloc>().add(UpdateUser(user: user));
      if (_oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty) {
        context.read<UserBloc>().add(UpdatePassword(
            user, _oldPasswordController.text, _newPasswordController.text));
      }
    }
  }
}

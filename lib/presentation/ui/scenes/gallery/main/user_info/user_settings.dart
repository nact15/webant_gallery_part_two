import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/user_info/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_page.dart';

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
  double heightFields = 36.0;
  double widthButton = 120.0;
  File _image;
  final picker = ImagePicker();
  final dateFormatter = DateFormat('dd.MM.yyyy');
  TextEditingController _nameController;
  TextEditingController _birthdayController;
  TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _birthdayController = TextEditingController();
    _emailController = TextEditingController();
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

    DateTime birthday = DateTime.parse(user.birthday);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is Exit){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                EnterPage()), (Route<dynamic> route) => false);
          });
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                  //print(dateFormatter.format(birthday));
                  print(DateTime.parse(user.birthday));
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
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
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
                        suffixIcon: Icon(
                          Icons.account_circle,
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                      initialValue: user.username,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 29),
                  child: Container(
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
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                      initialValue: toDate(user.birthday),
                    ),
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
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
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
                        suffixIcon: Icon(
                          Icons.mail,
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                      initialValue: user.email,
                    ),
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(
        primary: AppColors.decorationColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = ElevatedButton(
      child: Text("Yes"),
      style: ElevatedButton.styleFrom(
        primary: AppColors.mainColorAccent,
      ),
      onPressed: () {
        context.read<UserBloc>().add(LogOut());
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Sign out"),
      content: Text("Would you like to sign out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

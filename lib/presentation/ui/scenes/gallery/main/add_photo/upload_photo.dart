import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({Key key, this.image}) : super(key: key);
  final File image;

  @override
  _UploadPhotoState createState() => _UploadPhotoState(image);
}

enum typeValidator { NAME, DESCRIPTION }

class _UploadPhotoState extends State<UploadPhoto> {
  _UploadPhotoState(this._image);

  final _formKey = GlobalKey<FormState>();

  final File _image;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  bool typeNew;
  bool typePopular;

  @override
  void initState() {
    typeNew = true;
    typePopular = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: AppColors.mainColor,
                iconSize: 17,
              );
            },
          ),
          backgroundColor: AppColors.colorWhite,
          elevation: 1,
          actions: [
            TextButton(
              onPressed: postPhoto,
              child: Text(
                ('Add'),
                style: TextStyle(
                    color: AppColors.decorationColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
            ),
          ],
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorOfSearchBar,
                  border: Border(
                    bottom: BorderSide(
                        color: AppColors.mainColorAccent, width: 1.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.file(_image),
                ),
              ),
              Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          height: 36,
                          child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                contentPadding: EdgeInsets.all(8.0),
                                errorStyle: TextStyle(height: 0),
                                focusedBorder: AppStyles.borderTextField
                                    .copyWith(
                                        borderSide: BorderSide(
                                            color: AppColors.decorationColor)),
                                enabledBorder: AppStyles.borderTextField,
                                focusedErrorBorder: AppStyles.borderTextField,
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length <= 3) {
                                  return AppStrings.emptyName;
                                }
                                return null;
                              }),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        height: 100,
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            contentPadding: EdgeInsets.all(8.0),
                            focusedBorder: AppStyles.borderTextField.copyWith(
                                borderSide: BorderSide(
                                    color: AppColors.decorationColor)),
                            enabledBorder: AppStyles.borderTextField,
                            //),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            ActionChip(
                              label: Text(
                                'New',
                                style: TextStyle(color: AppColors.mainColor),
                              ),
                              onPressed: () {},
                              backgroundColor: !typeNew
                                  ? AppColors.mainColorAccent
                                  : AppColors.decorationColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: ActionChip(
                                label: Text(
                                  'Popular',
                                  style: TextStyle(color: AppColors.mainColor),
                                ),
                                onPressed: () {
                                  setState(() {
                                    typePopular = !typePopular;
                                  });
                                },
                                backgroundColor: !typePopular
                                    ? AppColors.mainColorAccent
                                    : AppColors.decorationColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void postPhoto() {
    if (_formKey.currentState.validate()) {}
  }
}

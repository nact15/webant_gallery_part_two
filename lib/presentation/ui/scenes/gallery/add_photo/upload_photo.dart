import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/single_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/back_widget.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';

import 'add_photo_bloc/add_photo_bloc.dart';

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
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    typeNew = true;
    typePopular = false;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          leading: BackWidget(),
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
        body: BlocBuilder<AddPhotoBloc, AddPhotoState>(
          builder: (context, state) {
            if (state is LoadingPostPhoto) {
              return Scaffold(
                backgroundColor: AppColors.colorWhite,
                body: LoadingCircular(),
              );
            }
            if (state is CompletePost) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ScreenInfo(photo: state.photo)),
                    (Route<dynamic> route) => false);
              });
            }
            return Center(
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
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                            child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  contentPadding: EdgeInsets.all(8.0),
                                  focusedBorder: AppStyles.borderTextField
                                      .copyWith(
                                          borderSide: BorderSide(
                                              color:
                                                  AppColors.decorationColor)),
                                  enabledBorder: AppStyles.borderTextField,
                                  focusedErrorBorder: AppStyles.borderTextField,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input name';
                                  }
                                  return null;
                                }),
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
                                focusedBorder: AppStyles.borderTextField
                                    .copyWith(
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorAccent)),
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
                                    style:
                                        TextStyle(color: AppColors.mainColor),
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
                                      style:
                                          TextStyle(color: AppColors.mainColor),
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
            );
          },
        ),
      ),
    );
  }

  void postPhoto() {
    if (_formKey.currentState.validate()) {
      context.read<AddPhotoBloc>().add(PostPhoto(
          file: _image,
          name: _nameController.text,
          description: _descriptionController.text));
    }
  }
}

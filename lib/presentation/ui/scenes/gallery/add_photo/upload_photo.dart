import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_styles.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/back_widget.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';

import 'add_photo_bloc/add_photo_bloc.dart';
import 'input_tags.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({Key key, this.image, this.photo}) : super(key: key);
  final File image;
  final PhotoModel photo;

  @override
  _UploadPhotoState createState() => _UploadPhotoState(image, photo);
}

enum typeValidator { NAME, DESCRIPTION }

class _UploadPhotoState extends State<UploadPhoto> {
  _UploadPhotoState(this._image, this._photo);

  final PhotoModel _photo;
  final _formKey = GlobalKey<FormState>();

  final File _image;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  List<String> _tags = [];

  @override
  void initState() {
    _nameController = TextEditingController(text: _photo?.name ?? '');
    _descriptionController =
        TextEditingController(text: _photo?.description ?? '');
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
              onPressed: _postPhoto,
              child: Text(
                (_photo == null ? 'Add' : 'Edit'),
                style: TextStyle(
                    color: AppColors.decorationColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
            ),
          ],
        ),
        body: BlocConsumer<AddPhotoBloc, AddPhotoState>(
          listener: (context, state) {
            if (state is ErrorPostPhoto) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.err),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
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
                    MaterialPageRoute(builder: (context) => Gallery()),
                    (Route<dynamic> route) => false);
                Fluttertoast.showToast(
                    msg: 'Publication has been moderated',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: AppColors.mainColorAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
            }
            return SingleChildScrollView(
              child: Column(
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
                      child: _photo == null
                          ? Image.file(_image)
                          : Image.network(_photo.getImage()),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: InputTags(tags: _tags),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _postPhoto() {
    if (_formKey.currentState.validate()) {
      if (_image != null) {
        context.read<AddPhotoBloc>().add(
              PostPhoto(
                  file: _image,
                  name: _nameController.text,
                  tags: _tags,
                  description: _descriptionController.text),
            );
      } else {
        context.read<AddPhotoBloc>().add(
              EditingPhoto(
                  photo: _photo,
                  name: _nameController.text,
                  tags: _tags,
                  description: _descriptionController.text),
            );
      }
    }
  }
}

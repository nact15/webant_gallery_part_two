import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_post_photo.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';

part 'add_photo_event.dart';

part 'add_photo_state.dart';

class AddPhotoBloc extends Bloc<AddPhotoEvent, AddPhotoState> {
  AddPhotoBloc() : super(AddPhotoInitial());
  PhotoModel photo;
  HttpPostPhoto httpPostPhoto = HttpPostPhoto();

  @override
  Stream<AddPhotoState> mapEventToState(
    AddPhotoEvent event,
  ) async* {
    if (event is PostPhoto) {
      try {
        yield LoadingPostPhoto();
        photo =
            await httpPostPhoto.postPhoto(file: event.file, name: event.name);
        yield CompletePost();
      } on DioError catch (err) {
        yield ErrorPostPhoto('Lost internet connection');
      }
    }
    if (event is DeletingPhoto) {
      try {
        await httpPostPhoto.deletePhoto(event.photo);
        yield DeletePhoto();
      } on DioError catch (err) {
        yield ErrorPostPhoto('Lost internet connection');
      }
    }
    if (event is EditingPhoto) {
      try {
        httpPostPhoto.editPhoto(event.photo, event.name, event.description);
        yield CompletePost();
      } on DioError catch (err) {
          yield ErrorPostPhoto('Lost internet connection');
      }
    }
  }
}

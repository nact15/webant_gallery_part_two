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
  //final GalleryBloc galleryBloc;
  //StreamSubscription galleryBlocSubscription;

  // @override
  // Future<void> close() {
  //   galleryBlocSubscription.cancel();
  //   return super.close();
  // }

  @override
  Stream<AddPhotoState> mapEventToState(
    AddPhotoEvent event,
  ) async* {
    if (event is PostPhoto) {
      yield LoadingPostPhoto();
      photo =
          await HttpPostPhoto().postPhoto(file: event.file, name: event.name);
      yield CompletePost(photo);
    }
    if (event is DeletingPhoto) {
      try {
        await HttpPostPhoto().deletePhoto(event.photo);
        yield DeletePhoto();
      } on DioError {}
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_post_photo.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';

part 'add_photo_event.dart';
part 'add_photo_state.dart';

class AddPhotoBloc extends Bloc<AddPhotoEvent, AddPhotoState> {
  AddPhotoBloc() : super(AddPhotoInitial());
  PhotoModel photo;

  @override
  Stream<AddPhotoState> mapEventToState(
    AddPhotoEvent event,
  ) async* {
    if (event is PostPhoto){
      yield LoadingPostPhoto();
      photo = await HttpPostPhoto().postPhoto(file: event.file, name: event.name);
     yield CompletePost(photo);
    }
  }
}

import 'dart:async';

import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';

abstract class FirestoreRepository{

  Stream<int> getCount(PhotoModel photo);
  Stream<int> getViewsCountOfUserPhoto(UserModel user);
  Future<void> incrementViewsCount(PhotoModel photo);
  Future<void> createPhoto(PhotoModel photo, List<String> tags);
  Future<List<dynamic>> getTags(PhotoModel photo);

}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/firestore_repository.dart';

class FirebaseFirestoreRepository extends FirestoreRepository {
  final _photos = FirebaseFirestore.instance.collection('photos');

  @override
  Stream<int> getCount(PhotoModel photo) {
    return _photos
        .doc(photo.id.toString())
        .snapshots()
        .map((doc) => doc['viewsCount']);
  }

  @override
  Stream<int> getViewsCountOfUserPhoto(UserModel user) {
    return _photos.where('user', isEqualTo: '/api/users/${user.id}').snapshots().map(
        (event) =>
            event.docs.fold(0, (prev, next) => prev + next['viewsCount']));
  }

  @override
  Future<void> createPhoto(PhotoModel photo, List<String> tags) async {
    Map<String, dynamic> data = photo.toJson();
    data.addAll({
      'tags': tags,
      'viewsCount': 0,
    });
    _photos
        .doc(photo.id.toString())
        .set(data)
        .onError((error, stackTrace) => null);
  }

  @override
  Future<void> incrementViewsCount(PhotoModel photo) async {
    var photoRef = _photos.doc(photo.id.toString());
    await photoRef.get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        Map<String, dynamic> data = photo.toJson();
        data.addAll({
          'viewsCount': 0,
        });
        photoRef.set(data);
      }
    }).catchError((onError) {
      return;
    });
    await photoRef.get().then((DocumentSnapshot doc) {
      photoRef.update({'viewsCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<List<dynamic>> getTags(PhotoModel photo) async {
    DocumentSnapshot doc = await _photos.doc(photo.id.toString()).get();
    if (doc.exists) {
      try {
        List<dynamic> tags = doc['tags'];
        if (tags.isNotEmpty || tags != null) {
          return tags;
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}

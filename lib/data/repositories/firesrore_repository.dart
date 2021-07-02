import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/firestore_repository.dart';

class FirebaseFirestoreRepository extends FirestoreRepository {
  final photos = FirebaseFirestore.instance.collection('photos');

  @override
  Stream<int> getCount(PhotoModel photo) {
    return photos
        .doc(photo.id.toString())
        .snapshots()
        .map((doc) => doc['viewsCount']);
  }

  @override
  Stream<int> getViewsCountOfUserPhoto(UserModel user){
    return photos.where('user', isEqualTo: user.username).snapshots().map((event) => event.docs.fold(
        0, (prev, next) => prev + next['viewsCount']));
  }

  @override
  Future<void> incrementViewsCount(PhotoModel photo) async {
    var photoRef = photos.doc(photo.id.toString());
    await photoRef.get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        photoRef.set(photo.toJson());
      }
    }).catchError((onError) {
      return 0;
    });
    await photoRef.get().then((DocumentSnapshot doc) {
      doc.reference.update({'viewsCount': FieldValue.increment(1)});
    }).catchError((onError) {
      return 0;
    });
  }
}

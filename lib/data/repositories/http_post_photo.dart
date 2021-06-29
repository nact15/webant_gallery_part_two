import 'dart:io';

import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/image_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/post_photo_gateway.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/welcome_screen.dart';

import 'http_oauth_gateway.dart';
import 'http_oauth_interceptor.dart';

class HttpPostPhoto extends PostPhotoGateway {
  final Dio dio = Dio()
    ..interceptors.add(LogInterceptor(responseBody: true))
    ..options.baseUrl = 'http://gallery.dev.webant.ru/api'
    ..interceptors.add(alice.getDioInterceptor());

  @override
  Future<PhotoModel> postPhoto(
      {File file, String name, String description}) async {
    dio.interceptors.add(HttpOauthInterceptor(dio, HttpOauthGateway()));
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response response = await dio.post('/media_objects', data: formData);
    var mediaObject = ImageModel.fromJson(response.data);
    String date = DateTime.now().toString();
    Response photo = await dio.post('/photos', data: {
      'name': name,
      'dateCreate': date,
      'description': description,
      'new': true,
      'popular': false,
      'image': 'api/media_objects/${mediaObject.id}'
    });
    return PhotoModel.fromJson(photo.data);
  }

  @override
  Future<void> deletePhoto(PhotoModel photo) async {
    await dio.delete('/photos/${photo.id}');
    //await dio.delete('/media_objects/${photo.image.id}');
  }

  @override
  Future<void> editPhoto(
      PhotoModel photo, String name, String description) async {
    await dio.put('/photos/${photo.id}', data: {
      'name': name,
      'description': description,
    });
  }
}

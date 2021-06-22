import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

import 'http_oauth_gateway.dart';
import 'http_oauth_interceptor.dart';

class HttpUserGateway extends UserGateway {
  HttpUserGateway();

  Dio dio = Dio()
    ..interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
        error: true))
    ..options.baseUrl = HttpStrings.baseUrl;

  @override
  Future<void> registration(UserModel userModel) async {
    await dio.post('/users', data: userModel.toJson());
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    dio.interceptors.add(HttpOauthInterceptor(dio, HttpOauthGateway()));
    await dio.put('/users/${userModel.id}', data: {
      'username': userModel.username,
      'email': userModel.email,
      'birthday': userModel.birthday,
    });
  }

  @override
  Future<void> deleteUser(UserModel userModel) async {
    dio.interceptors.add(HttpOauthInterceptor(dio, HttpOauthGateway()));
    await dio.delete('/users/${userModel.id}');
  }

  @override
  Future<void> updatePasswordUser(UserModel userModel, String oldPassword, String newPassword) async {
    dio.interceptors.add(HttpOauthInterceptor(dio, HttpOauthGateway()));
    await dio.put('/users/update_password/${userModel.id}', data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword
    });
  }
}

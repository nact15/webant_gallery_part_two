import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:webant_gallery_part_two/data/repositories/http_oauth_interceptor.dart';
import 'package:webant_gallery_part_two/domain/models/oauth/oauth_model.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/oauth_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

class HttpOauthGateway extends OauthGateway {
  HttpOauthGateway();

  final _storage = Storage.FlutterSecureStorage();

  Dio dio = Dio()..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: false,
      requestHeader: false,
      responseHeader: false));

  UserModel userModel;
  OauthModel oauthModel;

  @override
// ignore: missing_return
  Future<UserModel> authorization(
      String username, String password) async {
    try {
      Response client = await dio.post(HttpStrings.urlClients, data: {
        AppStrings.name: username,
        HttpStrings.allowedGrantTypes: [HttpStrings.password, AppStrings.refreshToken]
      });
      if (client.statusCode == 201) {
        oauthModel = OauthModel.fromJson(client.data);
        final Map<String, dynamic> queryParameters = <String, dynamic>{
          HttpStrings.clientId: '${oauthModel.id}_${oauthModel.randomId}',
          HttpStrings.grantType: HttpStrings.password,
          HttpStrings.username: username,
          HttpStrings.password: password,
          HttpStrings.clientSecret: oauthModel.secret,
        };
        var getToken = await dio.get(HttpStrings.tokenEndpoint,
            queryParameters: queryParameters);
        print(getToken);
        print(getToken.statusMessage);
        if (getToken.statusCode == 200) {

          String accessToken = getToken.data['access_token'];
          String refreshToken = getToken.data[AppStrings.refreshToken];
          String secret = oauthModel.secret;
          String id = '${oauthModel.id}_${oauthModel.randomId}';

          _writeTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
              id: id,
              secret: secret);
          dio.options.headers['authorization'] = 'Bearer $accessToken';
          var user = await dio.get(HttpStrings.currentUser);
          if (user.statusCode == 200) {
            userModel = UserModel.fromJson(user.data);
            return userModel;
          }
        }
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUser() async {
    dio.interceptors.add(HttpOauthInterceptor(dio));
    var user = await dio.get(HttpStrings.currentUser);
    userModel = UserModel.fromJson(user.data);
    return userModel;
  }

  Future<String> refreshToken() async {
    final refreshToken = await _storage.read(key: 'USER_REFRESH_TOKEN');
    final id = await _storage.read(key: 'USER_ID');
    final secret = await _storage.read(key: 'USER_SECRET');
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      HttpStrings.clientId: id,
      HttpStrings.grantType: 'refresh_token',
      'refresh_token': refreshToken,
      HttpStrings.clientSecret: secret,
    };
    var getToken = await dio.get(HttpStrings.tokenEndpoint,
        queryParameters: queryParameters);
    if (getToken.statusCode == 200) {
      String token = getToken.data['access_token'];
      String refreshToken = getToken.data['refresh_token'];
      _writeTokens(accessToken: token, refreshToken: refreshToken, id: id, secret: secret);
      return token;
    }
    return 'error';
  }

  void _writeTokens(
      {String accessToken,
      String refreshToken,
      String id,
      String secret}) async {
    await _storage.write(key: 'USER_ACCESS_TOKEN', value: accessToken);
    await _storage.write(key: 'USER_REFRESH_TOKEN', value: refreshToken);
    await _storage.write(key: 'USER_ID', value: id);
    await _storage.write(key: 'USER_SECRET', value: secret);
  }
}

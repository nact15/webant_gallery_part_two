import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:webant_gallery_part_two/domain/models/oauth/oauth_model.dart';
import 'package:webant_gallery_part_two/domain/models/oauth/token_model.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';

class HttpOauthGateway<T> {
  HttpOauthGateway();
  final _storage = Storage.FlutterSecureStorage();

  Dio dio = Dio();
  final String tokenUrl = 'http://gallery.dev.webant.ru/api/users/current';
  RegistrationModel registrationModel;
  OauthModel oauthModel;
  TokenModel tokenModel;

  // ignore: missing_return
  Future<RegistrationModel> authorization(
      String username, String password) async {
    try {
      Response client = await dio.post(AppStrings.urlClients, data: {
        AppStrings.name: username,
        AppStrings.allowedGrantTypes: [AppStrings.password]
      });
      print(client.statusMessage);
      print(client);
      if (client.statusCode == 201) {
        oauthModel = OauthModel.fromJson(client.data);
        final Map<String, dynamic> queryParameters = <String, dynamic>{
          AppStrings.clientId: '${oauthModel.id}_${oauthModel.randomId}',
          AppStrings.grantType: AppStrings.password,
          AppStrings.username: username,
          AppStrings.password: password,
          AppStrings.clientSecret: oauthModel.secret,
        };
        var getToken = await dio.get(AppStrings.tokenEndpoint,
            queryParameters: queryParameters);
        print(getToken);
        print(getToken.statusMessage);
        if (getToken.statusCode == 200) {
          tokenModel = TokenModel.fromJson(getToken.data);
          String token = tokenModel.accessToken;
          var user = await dio.get(AppStrings.currentUser,
              options: Options(headers: {//Bearer token
                AppStrings.authorization: '${AppStrings.typeToken} $token'
              }));
          if (user.statusCode == 200) {
            registrationModel = RegistrationModel.fromJson(user.data);
            print(registrationModel);
            await _storage.write(key: 'USER_ACCESS_TOKEN', value: token);
            await _storage.write(key: 'USER_REFRESH_TOKEN', value: token);
            return registrationModel;
          }
        }
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

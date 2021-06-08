import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/oauth/oauth_model.dart';
import 'package:webant_gallery_part_two/domain/models/oauth/token_model.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class HttpOauthGateway<T> {
  HttpOauthGateway();

  Dio dio = Dio();
  final String tokenEndpoint = ('http://gallery.dev.webant.ru/oauth/v2/token');
  final String tokenUrl = 'http://gallery.dev.webant.ru/api/users/current';
  RegistrationModel registrationModel;
  OauthModel oauthModel;
  TokenModel tokenModel;

  Future<RegistrationModel> authorization(String username, String password) async {
    try {
      Response client =
      await dio.post('http://gallery.dev.webant.ru/api/clients', data: {
        'name': username,
        'allowedGrantTypes': ['password']
      });
      print(client.statusMessage);
      print(client);
      if (client.statusCode == 201) {
        oauthModel = OauthModel.fromJson(client.data);
        final Map<String, dynamic> queryParameters = <String, dynamic>{
          'client_id':
          oauthModel.id.toString() + '_' + oauthModel.randomId.toString(),
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_secret': oauthModel.secret,
        };
        var getToken =
        await dio.get(tokenEndpoint, queryParameters: queryParameters);
        print(getToken);
        print(getToken.statusMessage);
        if (getToken.statusCode == 200) {
          tokenModel = TokenModel.fromJson(getToken.data);
          String token = tokenModel.accessToken;
          var user = await dio.get(tokenUrl,
              options: Options(headers: {'Authorization': 'Bearer $token'}));
          if (user.statusCode == 200) {
            registrationModel = RegistrationModel.fromJson(user.data);
            print(registrationModel);
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

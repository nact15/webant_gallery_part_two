import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

class HttpOauthInterceptor extends Interceptor {

  final Dio dio;
  final _storage = Storage.FlutterSecureStorage();
  HttpOauthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String accessToken = await _storage.read(key: HttpStrings.userAccessToken);
    if (accessToken.isNotEmpty || accessToken != null) {
      options.headers = {HttpStrings.authorization: 'Bearer $accessToken'};
      print(accessToken);
    }
    return handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      String accessToken = await HttpOauthGateway().refreshToken();
      if (accessToken != null) {
        err.requestOptions.headers = ({HttpStrings.authorization: 'Bearer $accessToken'});
        dio.fetch(err.requestOptions).then(
              (r) => handler.resolve(r),
        );
        return err;
      }
      return err;
    }
  }
}

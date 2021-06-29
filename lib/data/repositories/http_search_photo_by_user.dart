import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/search_photo_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/welcome_screen.dart';

class HttpSearchPhotoByUserGateway extends SearchPhotoGateway<PhotoModel> {
  Dio dio = Dio()
    ..interceptors.add(LogInterceptor(responseBody: true))
    ..interceptors.add(alice.getDioInterceptor());

  @override
  // ignore: missing_return
  Future<BaseModel<PhotoModel>> fetchPhotos({int page, var queryText}) async {
    try {
      final String url = HttpStrings.urlPhotos;
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'user.id': queryText,
      };
      Response response = await dio.get(url, queryParameters: queryParameters);
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        return BaseModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }
}


import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';


class HttpSearchPhotoGateway extends PhotoGateway<PhotoModel> {
  HttpSearchPhotoGateway();

  Dio dio = Dio()..interceptors.add(LogInterceptor(
    responseBody: true,));

  @override
  // ignore: missing_return
  Future<BaseModel<PhotoModel>> fetchPhotos({int page, String queryText}) async {
    try {
      final String url = HttpStrings.urlPhotos;
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'name': queryText,
        'limit': 10,
        'page': page
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

  @override
  String enumToString() {
    throw UnimplementedError();
  }

}

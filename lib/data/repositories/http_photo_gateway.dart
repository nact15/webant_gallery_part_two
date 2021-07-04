import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/new_or_popular_photos.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/welcome_screen.dart';

class HttpPhotoGateway extends PhotoGateway<PhotoModel> {
  HttpPhotoGateway({this.type});

  Dio _dio = Dio()
    ..interceptors.add(LogInterceptor(
      responseBody: true,
    ))
    ..interceptors.add(alice.getDioInterceptor());
  final typePhoto type;

  @override
  // ignore: missing_return
  Future<BaseModel<PhotoModel>> fetchPhotos({int page, var queryText}) async {
    try {
      final String url = HttpStrings.urlPhotos;
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'page': page,
        'limit': 10,
        enumToString(): queryText ?? true,
      };
      Response response = await _dio.get(url, queryParameters: queryParameters);
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        return BaseModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  String enumToString() {
    switch (type) {
      case typePhoto.NEW:
        return AppStrings.newType.toLowerCase();
        break;
      case typePhoto.POPULAR:
        return AppStrings.popularType.toLowerCase();
        break;
      case typePhoto.SEARCH_BY_USER:
        return 'user.id';
        break;
      case typePhoto.SEARCH:
        return 'name';
        break;
    }
    return AppStrings.titleGallery;
  }
}

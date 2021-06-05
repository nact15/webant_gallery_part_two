import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/new_or_popular_photos.dart';


class HttpPhotoGateway extends PhotoGateway<PhotoModel> {
  HttpPhotoGateway(this.type);

  Dio dio = Dio();
  final typePhoto type;

  @override
  // ignore: missing_return
  Future<BaseModel<PhotoModel>> fetchPhotos(int page) async {
    try {
      final String url = AppStrings.urlPhotos;
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'page': page,
        'limit': 10,
        EnumToString(): true,
      };
      Response response = await dio.get(url, queryParameters: queryParameters);
      final statusCode = response.statusCode;
      print(response.data);
      if (statusCode == 200) {
        return BaseModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  String EnumToString() {
    switch (type) {
      case typePhoto.NEW:
        return AppStrings.newType.toLowerCase();
        break;
      case typePhoto.POPULAR:
        return AppStrings.popularType.toLowerCase();
        break;
    }
    return AppStrings.titleGallery;
  }
}

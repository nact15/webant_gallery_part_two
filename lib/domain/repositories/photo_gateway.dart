import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';

abstract class PhotoGateway<T> {

  String enumToString();

  Future<BaseModel<T>> fetchPhotos(int page);
}

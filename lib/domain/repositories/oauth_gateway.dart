import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';

abstract class OauthGateway<T>{
  Future<BaseModel<T>> authentication ();
}